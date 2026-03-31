//
//  ImageSaver.swift
//  LootBox
//
//  Created by Matej on 01/10/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import AppKit
import Combine
import SwiftUI
import Foundation

final class NftRenderer {
        
    // MARK: - Init

    static let shared = NftRenderer()
    private init() {}
    
    // MARK: - Properties
    
    var appStateManager: AppStateManager!

    private var exportingTask: Task<Void, Error>?
    private var subscriberTokens = Set<AnyCancellable>()
    private var folderDirURL: URL?
    private var wasWarningShow = false

    // MARK: - Interface
    
    func export(shouldMint: Bool) {
        Analytics.track(event: .exportStartPressed, data: [
            "Number of NFT": appStateManager.settingsModel.numberOfItems,
            "Canvas width": Int(appStateManager.canvasViewModel.canvasWidth),
            "Canvas height": Int(appStateManager.canvasViewModel.canvasHeight)
        ])
        Analytics.startStopwatchFor(event: .exportFinished)
        
        wasWarningShow = false
        
        // save dialog
        let panel = NSOpenPanel()
        panel.nameFieldLabel = "dialog_save_to"
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.canChooseFiles = false
        panel.begin { response in
            if response == NSApplication.ModalResponse.OK, let destinationUrl = panel.url {
                self.folderDirURL = destinationUrl
                self.generate(shouldMint: shouldMint)
            }
        }
    }
    
    func cancelExport() {
        Analytics.track(event: .exportCancelPressed)
        Analytics.track(event: .exportFinished)
        exportingTask?.cancel()

        Task(priority: .userInitiated) {
            await MainActor.run {
                appStateManager.uiModel.exportedIndex = 0
                appStateManager.uiModel.isExporting = false
            }
        }
    }
}

// MARK: - Save to directory

private extension NftRenderer {
    
    func generate(shouldMint: Bool) {
        appStateManager.uiModel.isExporting = true
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        exportingTask = Task(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            for index in 1...self.appStateManager.settingsModel.numberOfItems {
                guard
                    self.exportingTask?.isCancelled == false,
                    index < AppSettings.Feature.exportLimit,
                    let context = CGContext(
                    data: nil,
                    width: Int(self.appStateManager.canvasViewModel.canvasWidth),
                    height: Int(self.appStateManager.canvasViewModel.canvasHeight),
                    bitsPerComponent: 8,
                    bytesPerRow: 0,
                    space: colorSpace,
                    bitmapInfo: bitmapInfo.rawValue)
                else { break}
                await self.generateNft(in: context, number: index, shouldMint: shouldMint)
            }
            await MainActor.run {
                Analytics.track(event: .exportSuccess)
                Analytics.track(event: .exportFinished)
                if self.appStateManager.uiModel.error == nil {
                    self.appStateManager.uiModel.shouldShowSuccessAlert = true
                }
                self.cancelExport()
            }
        }
    }
    
    func generateNft(in context: CGContext, number: Int, shouldMint: Bool) async {
        let fileName = "\(appStateManager.settingsModel.collectionName) #\(number).png"
        guard
            let nftData = renderCg(traits: appStateManager.traitsViewModel.traits, inContext: context),
            let pngImage = nftData.image.pngData,
            let imageFilePath = filePath(forImageName: fileName),
            let jsonFilePath = filePath(forImageName: "\(appStateManager.settingsModel.collectionName) #\(number).json")
        else {
            return
        }
        
        // create NFT data
        do {
            // save image
            try pngImage.write(to: imageFilePath, options: .withoutOverwriting)
            
            // json
            try saveJson(data: nftData.json, to: jsonFilePath)
            
            // mint
            if AppSettings.Version.isPro && shouldMint {
                if appStateManager.featureFlagObserver.isMintingEnabled {
                    let metadata = NFTMetadata(name: nftData.json.name,
                                               description: nftData.json.description,
                                               localImageFileURL: imageFilePath,
                                               fileName: fileName)
                    try await NftMinter.mint(nft: metadata, for: appStateManager.walletAddress)
                } else {
                    if !wasWarningShow {
                        appStateManager.uiModel.shouldShowMintUnavailable = true
                    }
                    wasWarningShow = true
                }
            }
        }
        catch AppError.mintFailed {
            CustomLogger.log(type: .export, message: "Saving image resulted in error: \(AppError.mintFailed.localizedDescription)", error: AppError.mintFailed)
            appStateManager.uiModel.error = AppError.mintFailed
            cancelExport()
        }
        catch {
            CustomLogger.log(type: .export, message: "Saving image resulted in error: \(error.localizedDescription)", error: error)
            appStateManager.uiModel.error = AppError.export(localizedMessage: error.localizedDescription)
            cancelExport()
        }

        await MainActor.run {
            appStateManager.uiModel.exportedIndex = number
        }
    }
    
    func filePath(forImageName imageName: String) -> URL? {
        return folderDirURL?.appendingPathComponent(imageName)
    }

}

// MARK: - Render

private extension NftRenderer {
    
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
    
    func saveJson(data: NftJson, to filePath: URL) throws {
        do {
            try JSONEncoder().encode(data).write(to: filePath)
        } catch {
            CustomLogger.log(
                type: .export,
                message: "Error writing to JSON file: \(error.localizedDescription)",
                error: AppError.export(localizedMessage: error.localizedDescription)
            )
            appStateManager.uiModel.error = AppError.export(localizedMessage: error.localizedDescription)
            cancelExport()
        }
    }
    
}

// MARK: - Render

private extension NftRenderer {
    
    // MARK: - CGContext
    
    func renderCg(traits: [TraitModel], inContext context: CGContext) -> (image: NSImage, json: NftJson)? {
        // paint background color
        context.setFillColor(appStateManager.canvasViewModel.backgroundColor.cgColor)
        context.fill(CGRect(origin: .zero, size: appStateManager.canvasViewModel.canvasSize))
        
        // build NFT from traits
        var isImageReady = true
        var traitsInfo = [NftJson.TraitInfo]()
        let sortedTraits = traits.sorted(by: { $0.zIndex < $1.zIndex })
        for trait in sortedTraits {
            // get trait image based on odds
            guard let traitImageModel = TraitGenerator.getRandomImageModel(for: trait) else {
                isImageReady = false
                break
            }
                  
            // rotate/redraw image
            let traitImage: CGImage? = if trait.rotationAngle == 0 {
                traitImageModel.nsImage.cgImage
            } else {
                traitImageModel.nsImage.rotate(angle: .degrees(trait.rotationAngle))?.cgImage
            }

            guard let traitImage else {
                isImageReady = false
                break
            }

            // Bounding box after rotation
            let imageBoundingBoxSize: CGSize = if trait.rotationAngle == 0 {
                traitImageModel.nsImage.boundingBoxForRotatedRectangle(givenSize: trait.frame.size, angle: trait.rotationAngle)
            } else {
                trait.frame.size
            }
            
            // Due to rotation the diff between original frame and new one is missing in position. I don't know why.
            // We need to adjust the destination drawing frame by the diff amount.
            let adjustmentX = (trait.rotationAngle == 0 ? 0 : (imageBoundingBoxSize.width - trait.frame.width)/2)
            let adjustmentY = (trait.rotationAngle == 0 ? 0 : (imageBoundingBoxSize.height - trait.frame.height)/2)

            // draw trait
            // transforms the Y drawing orientation
            let transformedFrame = CGRect(
                origin: CGPoint(
                    x: trait.frame.origin.x - adjustmentX,
                    y: abs(trait.frame.origin.y - (appStateManager.canvasViewModel.canvasHeight - imageBoundingBoxSize.height) - adjustmentY)
                ),
                size: imageBoundingBoxSize
            )
            context.draw(traitImage, in: transformedFrame)
            traitsInfo.append(NftJson.TraitInfo(trait_type: trait.name, value: traitImageModel.name))
        }
        
        if !AppSettings.Version.isPro {
            renderWatermark(in: context)
        }

        guard isImageReady, let image = context.makeImage() else { return nil }
        
        let nftImage = NSImage(cgImage: image, size: appStateManager.canvasViewModel.canvasSize)
        let nftJson = NftJson(name: appStateManager.settingsModel.collectionName, attributes: traitsInfo)
        
        return (image: nftImage, json: nftJson)
    }
    
    func renderWatermark(in context: CGContext) {
        let textLayer = CATextLayer()
        textLayer.font = NSFont.systemFont(ofSize: 24)
        textLayer.string = NSLocalizedString("watermark_text", comment: "")
        textLayer.foregroundColor = NSColor.white.cgColor
        textLayer.backgroundColor = NSColor.black.cgColor
        textLayer.frame = CGRect(origin: .zero, size: CGSize(width: context.width, height: 54))
        textLayer.render(in: context)
    }
}
#endif
