//
//  LinearGradient+Pallete.swift
//  OpenNFT
//
//  Created by Matej on 12/01/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

extension LinearGradient {
    
    enum Pallete {
        static let clearToBlack = LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .clear, location: 0.25),
                .init(color: Color.black, location: 0.95)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        static func clearToBlack(
            start: CGFloat,
            stop: CGFloat,
            endOpacity: Double,
            direction: Direction = .vertical,
            isInverse: Bool = false
        ) -> some View {
            LinearGradient(
               gradient: Gradient(stops: [
                   .init(color: .clear, location: start),
                   .init(color: Color.black.opacity(endOpacity), location: stop)
               ]),
               startPoint: isInverse ? direction.endPoint : direction.startPoint,
               endPoint: isInverse ? direction.startPoint : direction.endPoint
            )
        }
    }
}

extension LinearGradient.Pallete {

    enum Direction {
        case horizontal
        case vertical
        
        var startPoint: UnitPoint {
            switch self {
            case .horizontal: .leading
            case .vertical: .top
            }
        }
        var endPoint: UnitPoint {
            switch self {
            case .horizontal: .trailing
            case .vertical: .bottom
            }
        }
    }
}
