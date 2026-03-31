//
//  CanvasViewModel.swift
//  LootBox
//
//  Created by Matej on 09/10/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI
import SwiftData

@Model
class CanvasViewModel {

    static let zoomMax: CGFloat = 2
    static let zoomMin: CGFloat = 0.1
    static let zoomStep: CGFloat = 0.1

    // MARK: - Properties

    var width: CGFloat = 768 * 3
    var height: CGFloat = 1024 * 2
    var zoomFactor: CGFloat = 1.0

    @Attribute(.transformable(by: UIColorValueTransformer.self)) var backgroundUiColor = UIColor.clear {
        didSet {
            backgroundColor = Color(uiColor: newValue)
        }
    }
    
    @Transient var backgroundColor: Color {
        get {
            Color(uiColor: backgroundUiColor)
        }
        set {
            backgroundUiColor = UIColor(newValue)
        }
    }
    
    // MARK: - Init
    
    init() {}
    
    // MARK: - Interface

    func updateCanvas(frame: CGRect) {
        width = frame.width
        height = frame.height
    }
}

extension CanvasViewModel {
    
    var canvasSize: CGSize {
        CGSize(width: width, height: height)
    }
}
#endif
