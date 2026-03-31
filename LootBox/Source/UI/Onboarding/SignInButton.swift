//
//  RoundedRectangleButton.swift
//  GameTime
//
//  Created by Matej on 04/03/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

struct SignInButton: View {
    
    enum Style {
        case plain
        case custom(
            backgroundColor: Color,
            textColor: Color = Color.Palette.Foreground.primary,
            font: Font = Font.Pallete.Button.big
        )
        
        var backgroundColor: Color {
            switch self {
            case .plain: return Color.Palette.Foreground.primary
            case .custom(let backgroundColor, _, _): return backgroundColor
            }
        }
        
        var textColor: Color {
            switch self {
            case .plain: return Color.black
            case .custom(_, let color, _): return color
            }
        }
        
        var font: Font {
            switch self {
            case .plain: return Font.Pallete.Button.big
            case .custom(_, _, let font): return font
            }
        }
    }
    
    struct Configuration {
        var title: String
        var leftIconView: AnyView
    }
    
    // MARK: - Properties
    
    var style: Style
    var configuration: Configuration
    var buttonPressedAction: EmptyClosure
    
    // MARK: - View
    
    var body: some View {
        Button(action: buttonPressedAction) {
            Spacer()
            Text(configuration.title)
                .font(style.font)
                .foregroundColor(style.textColor)
            Spacer()
        }
        .overlay(content: {
            HStack {
                configuration.leftIconView
                    .frame(width: 20, height: 20, alignment: .center)
                    .padding(.horizontal, 16)
                Spacer()
            }
        })
        .frame(height: 65)
        .background(style.backgroundColor)
        .cornerRadius(16)
    }
}
