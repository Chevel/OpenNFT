//
//  Onboarding.Dots.swift
//  LootBox
//
//  Created by Matej on 22. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

struct Fancy3DotsIndexView: View {
    
    // MARK: - Public Properties
    
    let numberOfPages: Int
    let currentIndex: Int

    // MARK: - Drawing Constants
    
    private let circleSize: CGFloat = 16
    private let circleSpacing: CGFloat = 12
    
    private let primaryColor = Color.Palette.primary
    private let secondaryColor = Color.white.opacity(0.6)
    
    private let smallScale: CGFloat = 0.6
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: circleSpacing) {
            ForEach(0..<numberOfPages) { index in
                if shouldShowIndex(index) {
                    Circle()
                        .fill(currentIndex == index ? primaryColor : secondaryColor)
                        .scaleEffect(currentIndex == index ? 1 : smallScale)
                        .frame(width: circleSize, height: circleSize)
                        .transition(AnyTransition.opacity.combined(with: .scale))
                        .id(index)
                }
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    func shouldShowIndex(_ index: Int) -> Bool {
        ((currentIndex - 1)...(currentIndex + 1)).contains(index)
    }
}
