//
//  NftRendererIos.swift
//  OpenNFT
//
//  Created by Matej on 16. 10. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import UIKit
import Photos
import Combine
import Foundation

final class NftRenderer {
        
    // MARK: - Init

    static let shared = NftRenderer()
    private init() {}
    
    // MARK: - Properties
    
    var appStateManager: AppStateManager!
    
    private var exportedMetadata: [NftRenderer.NftJson] = []
    private var exportingTask: Task<Void, Error>?
    private var subscriberTokens = Set<AnyCancellable>()
    private var folderDirURL: URL?
    private var wasErrorDuringExport: Bool = false

    // MARK: - Interface
    
    func export(shouldMint: Bool) {
        exportedMetadata = []

        guard appStateManager.traitsViewModel.hasValidData else {
            CustomLogger.log(type: .export, message: "Permission denied.", error: AppError.noPhotoPermission)
            self.appStateManager.error = AppError.noPhotoPermission
            return
        }
        
        // fetch existing collection if available
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "title == %@", appStateManager.collectionName)
        
        // First collection that has the same title
        if let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: options).firstObject {
            Analytics.track(event: .exportStartPressed, data: [
                "Number of NFT": appStateManager.numberOfItems,
                "Canvas width": Int(appStateManager.canvasViewModel.width),
                "Canvas height": Int(appStateManager.canvasViewModel.height)
            ])
            Analytics.startStopwatchFor(event: .exportFinished)

            guard collection.canPerform(.createContent) else {
                CustomLogger.log(type: .export, message: "Empty canvas.", error: AppError.emptyCanvas)
                self.appStateManager.error = AppError.emptyCanvas
                return
            }
            self.generate(shouldMint: shouldMint, collection: collection)
        } else { // otherwise create a new collection
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.appStateManager.collectionName)
            }, completionHandler: { success, error in
                if success {
                    Analytics.track(event: .exportAddedCollection)
                    self.export(shouldMint: shouldMint)
                } else {
                    Analytics.track(event: .exportAddedCollectionFailed)
                    CustomLogger.log(type: .export, message: "Failed creating a collection.", error: AppError.generic)
                    self.appStateManager.error = AppError.generic
                }
            })
        }
    }
    
    func cancelExport() {
        Analytics.track(event: .exportCancelPressed)
        Analytics.track(event: .exportFinished)
        exportingTask?.cancel()

        Task(priority: .userInitiated) {
            await MainActor.run {
                appStateManager.exportedIndex = 0
                appStateManager.isExporting = false
            }
        }
    }
}

// MARK: - Save to Photos

private extension NftRenderer {
    
    func generate(shouldMint: Bool, collection: PHAssetCollection) {
        Task {
            await MainActor.run {
                appStateManager.isExporting = true
            }
        }
    
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        exportingTask = Task(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            for index in 1...self.appStateManager.numberOfItems {
                guard
                    self.exportingTask?.isCancelled == false,
                    index < AppSettings.Feature.exportLimit || appStateManager.isUnlocked,
                    let context = CGContext(
                    data: nil,
                    width: Int(self.appStateManager.canvasViewModel.width),
                    height: Int(self.appStateManager.canvasViewModel.height),
                    bitsPerComponent: 8,
                    bytesPerRow: 0,
                    space: colorSpace,
                    bitmapInfo: bitmapInfo.rawValue)
                else { break}
                await self.generateNft(in: context, number: index, shouldMint: shouldMint, collection: collection)
            }

            // prepare metadata for export
            do {
                try MetadataExporter.prepareBatchForExport(
                    metadata: exportedMetadata,
                    filename: appStateManager.collectionName
                )
            } catch(let error) {
                let cocoaError = error as NSError
                guard
                    let title = cocoaError.localizedFailureReason,
                    let message = cocoaError.localizedRecoverySuggestion
                else {
                    self.appStateManager.error = AppError.generic
                    return
                }
                self.appStateManager.error = AppError.custom(title: title, message: message)
            }
            
            await MainActor.run {
                Analytics.track(event: .exportSuccess)
                Analytics.track(event: .exportFinished)

                if self.wasErrorDuringExport {
                    self.appStateManager.error = AppError.partialExport
                } else if let error = self.appStateManager.error {
                    self.appStateManager.error = error
                } else {
                    self.appStateManager.shouldShowSuccessAlert = true
                }

                self.cancelExport()
            }
        }
    }
    
    func generateNft(in context: CGContext, number: Int, shouldMint: Bool, collection: PHAssetCollection) async {
        guard let nftData = renderCg(traits: appStateManager.traitsViewModel.traits, inContext: context) else {
            self.appStateManager.error = AppError.generic
            return
        }

        exportedMetadata.append(nftData.json)
        
        nonisolated(unsafe) let renderer = self
        // Add the asset to collection
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: nftData.image)
            let addAssetRequest = PHAssetCollectionChangeRequest(for: collection)
            addAssetRequest?.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
        }, completionHandler: { success, error in
            // best effort export
            if success {
                Task {
                    await MainActor.run {
                        renderer.appStateManager.exportedIndex = number
                    }
                }
            } else { // in case 1 item export fails we mark it and show a warning at the end.
                renderer.wasErrorDuringExport = true
            }
        })
    }
}

// MARK: - Render

extension NftRenderer {
    
    struct NftJson: Encodable {
        let name: String

        var description: String {
            var s = ""
            for (index, item) in attributes.enumerated() {
                s.append(item.trait_type + ": " + item.value)
                if index + 1 < attributes.count {
                    s.append(", ")
                }
            }
            return s
        }
        let attributes: [TraitInfo]
        struct TraitInfo: Encodable {
            let trait_type: String
            let value: String
        }
    }
}

// MARK: - Render

private extension NftRenderer {
    
    // MARK: - CGContext
    
    func renderCg(traits: [TraitModel], inContext context: CGContext) -> (image: UIImage, json: NftJson)? {
        
        // paint background color
        context.setFillColor(appStateManager.canvasViewModel.backgroundColor.cgColor ?? UIColor.clear.cgColor)
        context.fill(CGRect(origin: .zero, size: appStateManager.canvasViewModel.canvasSize))
        
        // build NFT from traits
        var isImageReady = true
        var traitsInfo = [NftJson.TraitInfo]()
        let sortedTraits = traits.sorted(by: { $0.zIndex < $1.zIndex })
        for trait in sortedTraits {
            guard let traitImageModel = TraitGenerator.getRandomImageModel(for: trait) else {
                isImageReady = false
                break
            }

            // get trait image based on odds
            guard let traitImage = traitImageModel.image.rotate(angle: .degrees(trait.rotationAngle))?.cgImage else {
                isImageReady = false
                break
            }
            
            // Bounding box after rotation
            let imageBoundingBoxSize = traitImageModel.image.boundingBoxForRotatedRectangle(givenSize: trait.frame.size, angle: trait.rotationAngle)
            
            // Due to rotation the diff between original frame and new one is missing in position. I don't know why.
            // We need to adjust the destination drawing frame by the diff amount.
            let adjustmentX = (imageBoundingBoxSize.width - trait.frame.width)/2
            let adjustmentY = (imageBoundingBoxSize.height - trait.frame.height)/2

            // draw trait
            // transforms the Y drawing orientation
            let transformedFrame = CGRect(
                origin:
                    CGPoint(
                        x: trait.frame.origin.x - adjustmentX,
                        y: abs(trait.frame.origin.y - (appStateManager.canvasViewModel.height - imageBoundingBoxSize.height) - adjustmentY)
                    ),
                size: imageBoundingBoxSize
            )

            context.draw(
                traitImage,
                in: transformedFrame
            )
            traitsInfo.append(
                NftJson.TraitInfo(
                    trait_type: trait.name,
                    value: traitImageModel.customName ?? traitImageModel.imageName
                )
            )
        }
        
        if !appStateManager.isUnlocked {
            renderWatermark(in: context)
        }

        guard isImageReady, let image = context.makeImage() else { return nil }
        
        let nftImage = UIImage(cgImage: image)
        let nftJson = NftJson(name: appStateManager.collectionName, attributes: traitsInfo)
        
        return (image: nftImage, json: nftJson)
    }

    func renderWatermark(in context: CGContext) {
        let textLayer = CATextLayer()
        textLayer.font = UIFont.systemFont(ofSize: 24)
        textLayer.string = NSLocalizedString("watermark_text", comment: "")
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.backgroundColor = UIColor.black.cgColor
        textLayer.frame = CGRect(origin: .zero, size: CGSize(width: context.width, height: 54))
        textLayer.isGeometryFlipped = true // Adjust coordinate system for iOS
        textLayer.render(in: context)
    }
}
#endif

