//
//  TraitModel.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI
import SwiftData

@Model
final class TraitModel: Identifiable {
    
    static let defaultFrameSize = CGSize(width: 200, height: 160)

    // needed to support cancel option on edit slider
    private static var temporaryFrame: CGRect?
    private static var lastFrameSize: CGSize = defaultFrameSize
    
    // MARK: - Properties

    var name: String = String(localized: LocalizedStringResource(stringLiteral: "generic_untitled"))
    @Attribute(.transformable(by: CGPointValueTransformer.self)) var center: CGPoint
    @Attribute(.transformable(by: CGRectValueTransformer.self)) var frame: CGRect
    @Attribute(.transformable(by: UIColorValueTransformer.self)) var frameColor: UIColor
    
    var rotationAngle: CGFloat = 0
    var zIndex: CGFloat = 0

    // MARK: - Dynamic
    
    var isSelected: Bool

    @Transient @Published private var _selectedImageName = ""
    var selectedImageName: String {
        get { _selectedImageName }
        set {
            _selectedImageName = newValue
            selectedImageNameSetter()
        }
    }
    
    @Transient @Published private var _selectedImageUuid = ""
    var selectedImageUuid: String {
        get { _selectedImageUuid }
        set {
            _selectedImageUuid = newValue
            selectedImageUuidSetter()
        }
    }

    var isFrameVisible: Bool
    var imagesData: [ImageViewModel] = [] {
        didSet {
            if imagesData != oldValue {
                // pre-select the first image from user selected images
                imagesDataSetter()
            }
        }
    }

    // MARK: - Identifiable

    @Attribute(.unique) private(set) var id = UUID().uuidString
    
    // MARK: - Init

    init(
        images: [ImageViewModel] = [],
        zIndex: Double,
        isFrameVisible: Bool = false
    ) {
        self.frameColor = UIColor(Color.random())
        self.imagesData = images
        
        self.zIndex = zIndex
        
        let initialFrame = CGRect(origin: CGPoint(x: Self.defaultFrameSize.width/2, y: Self.defaultFrameSize.height/2), size: Self.defaultFrameSize)
        self.frame = initialFrame
        self.center = CGPoint(x: initialFrame.midX/2, y: initialFrame.midY/2)
        
        self.isFrameVisible = isFrameVisible
        self.isSelected = false
    }

    // MARK: - Edit

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
        Self.lastFrameSize = frame.size
    }

    func completeEdit() {
        Self.temporaryFrame = nil
    }

    func resetRotate() {
        rotationAngle = 0
    }

    func resetScale() {
        frame = Self.temporaryFrame ?? CGRect(origin: frame.origin, size: TraitModel.defaultFrameSize)
        Self.temporaryFrame = nil
    }

    private func renameSelectedTrait(newName: String) {
        if let selectedImage = imagesData.first(where: { $0.isSelected }) {
            selectedImage.customName = newName
        }
    }

    private func updateSelectedTraitName() {
        if let customName = imagesData.first(where: { $0.isSelected })?.customName {
            selectedImageName = customName
        }
    }
}

// MARK: - Workaround

/// Workaround for Apple bugs
extension TraitModel {

    /// Calls each of the property setters logic that would usually happen
    func respondToArrayUpdate() {
        // imagesData
        imagesDataSetter()
        
        // selectedImageUuid
        selectedImageUuidSetter()
        
        // selectedImageName
        selectedImageNameSetter()
    }

    func selectedImageNameSetter() {
        renameSelectedTrait(newName: selectedImageName)
    }
    
    func selectedImageUuidSetter() {
        imagesData.forEach {
            $0.isSelected = $0.id == selectedImageUuid
        }
        updateFrameBasedOnImageSelection()
        updateSelectedTraitName()
    }

    func imagesDataSetter() {
        if let firstAvailableImage = imagesData.first {
            selectedImageUuid = firstAvailableImage.id
        }
        updateFrameBasedOnImageSelection()
    }
}

// MARK: - Computed

extension TraitModel {

    var radians: Float { Float(rotationAngle * 0.01745329) }
    
    var selectedImage: ImageViewModel? {
        imagesData.first { $0.id == selectedImageUuid }
    }
}

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
            CGRect(origin: frame.origin, size: calculateAspectRatioFit(imageSize: firstAvailableImage.image.size))
        } else {
            nil
        }
    }
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
