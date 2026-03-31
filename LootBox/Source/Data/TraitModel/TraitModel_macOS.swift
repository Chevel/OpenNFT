//
//  TraitModel.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI
import SwiftData

@Model
final class TraitModel: Identifiable {

    static let defaultFrameSize = CGSize(width: 100, height: 100)

    private static var temporaryFrame: CGRect?
    private static var lastFrameSize: CGSize = defaultFrameSize
    private static var temporaryRotationAngle: CGFloat?

    // MARK: - Properties

    var name: String = String(localized: LocalizedStringResource(stringLiteral: "generic_untitled"))
    @Attribute(.transformable(by: CGPointValueTransformer.self)) var center: CGPoint
    @Attribute(.transformable(by: CGRectValueTransformer.self)) var frame: CGRect
    @Attribute(.transformable(by: NSColorValueTransformer.self)) var frameColor: NSColor
    @Transient var frameColorValue: Color {
        Color(cgColor: frameColor.cgColor)
    }

    var rotationAngle: CGFloat = 0
    var zIndex: Double = 0

    // MARK: - Dynamic
    
    var isSelected: Bool

    private var _selectedImageUuid = ""
    var selectedImageUuid: String {
        get { _selectedImageUuid }
        set {
            _selectedImageUuid = newValue
            imagesData.forEach {
                $0.isSelected = $0.id == selectedImageUuid
            }
        }
    }

    var isFrameVisible: Bool
    var imagesData: [ImageViewModel] = [] {
        didSet {
            updateImagesDataZindex()
            imagesDataSetter()
        }
    }

    // MARK: - Identifiable
    
    @Attribute(.unique) private(set) var id = UUID().uuidString
    
    // MARK: - Init

    init(images: [ImageViewModel] = [], zIndex: Double, isFrameVisible: Bool = false) {
        if let cgColor = Color.random().cgColor, let nsColor = NSColor(cgColor: cgColor) {
            self.frameColor = nsColor
        } else {
            self.frameColor = NSColor.green
        }

        self.imagesData = images

        self.zIndex = zIndex

        let initialFrame = CGRect(origin: .zero, size: Self.defaultFrameSize)
        self.frame = initialFrame
        self.center = CGPoint(x: Self.defaultFrameSize.width/2, y: Self.defaultFrameSize.height/2)

        self.isFrameVisible = isFrameVisible
        self.isSelected = false
    }
}

// MARK: - Edit

extension TraitModel {
    
    func resize(scale: Double) {
        if Self.temporaryFrame == nil {
            Self.temporaryFrame = frame
        }
        guard let temporaryFrame = Self.temporaryFrame else { return }

        frame = CGRect(
            origin: frame.origin,
            size: CGSize(
                width: temporaryFrame.width * scale,
                height: temporaryFrame.height * scale
            )
        )
    }
    
    func rotate(angle: CGFloat) {
        if Self.temporaryRotationAngle == nil {
            Self.temporaryRotationAngle = angle
        }
        guard let temporaryRotationAngle = Self.temporaryRotationAngle else { return }
        
        if angle > temporaryRotationAngle {
            rotationAngle += abs(angle/5)
        } else if angle < temporaryRotationAngle {
            rotationAngle -= abs(angle/5)
        }
        
        Self.temporaryRotationAngle = angle
    }
    
    func resetRotation() {
        Self.temporaryRotationAngle = nil
        rotationAngle = 0
    }
    
    func completeEdit() {
        Self.temporaryFrame = nil
        Self.temporaryRotationAngle = nil
    }
}

// MARK: - Interface

extension TraitModel {

    /// Calls each of the property setters logic that would usually happen
    func respondToArrayUpdate() {
        // imagesData
        imagesDataSetter()
        
        // selectedImageUuid
        selectedImageUuidSetter()
    }
}

// MARK: - Helper

private extension TraitModel {

    func updateFrameBasedOnImageSelection() {
        frame = frameAdjustedToSelectedImage() ?? frame
        Self.temporaryFrame = frame
    }
    
    func calculateAspectRatioFit(imageSize: CGSize) -> CGSize {
        let ratio = min(Self.lastFrameSize.width / imageSize.width, Self.lastFrameSize.height / imageSize.height)
        return .init(width: imageSize.width * ratio, height: imageSize.height * ratio)
     }
        
    func frameAdjustedToSelectedImage() -> CGRect? {
        if let firstAvailableImage = imagesData.first(where: { $0.isSelected }) {
            CGRect(origin: frame.origin, size: calculateAspectRatioFit(imageSize: firstAvailableImage.nsImage.size))
        } else {
            nil
        }
    }
    
    func selectedImageUuidSetter() {
        imagesData.forEach {
            $0.isSelected = $0.id == selectedImageUuid
        }
        updateFrameBasedOnImageSelection()
    }
    
    func imagesDataSetter() {
        if let firstAvailableImage = imagesData.first {
            selectedImageUuid = firstAvailableImage.id
        }
    }
}

// MARK: - Computed

extension TraitModel {

    var radians: Float { Float(rotationAngle * 0.01745329) }
}

// MARK: - Hashable

extension TraitModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TraitModel, rhs: TraitModel) -> Bool {
        lhs.id == rhs.id
    }
}

#endif
