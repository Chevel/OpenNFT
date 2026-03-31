//
//  ImageData.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI
import SwiftData
import UIKit.UIColor

@Model
final class ImageViewModel {
    
    @Attribute(.unique) private(set) var id = UUID().uuidString
    @Attribute(.transformable(by: UIImageValueTransformer.self)) private(set) var image: UIImage
    private(set) var imageName: String
    
    var odds: Double
    var customName: String?
    var isSelected = false
    var zIndex: Double = 0.0
    
    init(nsImage: UIImage, name: String) {
        self.image = nsImage
        self.odds = 82.0
        self.imageName = name
    }
}

// MARK: - Computed

extension ImageViewModel {
    
    enum Orientation {
        case landscape
        case portrait
        case square
    }
    var orientation: Orientation {
        if image.size.height > image.size.width {
            .portrait
        } else if image.size.height < image.size.width {
            .landscape
        } else {
            .square
        }
    }
}

// MARK: - Equatable

extension ImageViewModel: Equatable {
    
    static func == (lhs: ImageViewModel, rhs: ImageViewModel) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension ImageViewModel: Hashable {

    func hash(into hasher: inout Hasher) {
         hasher.combine(id)
     }
}

// MARK: - Convenience

extension ImageViewModel {

    var uiImage: Image { Image(uiImage: image) }
}
#endif
