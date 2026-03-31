//
//  MagnifyMenuView.swift
//  OpenNFT
//
//  Created by Matej on 2. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI

struct MagnifyMenuView: View {
    
    @Binding var zoom: CGFloat

    var body: some View {
        zoomSlider
    }
}

// MARK: - UI

private extension MagnifyMenuView {
    
    var zoomAmount: Int { Int(zoom * 100) }

    var zoomSlider: some View {
        VStack(spacing: 0) {
            Text("\(zoomAmount)%")
                .font(Font.Pallete.infoText)
                .foregroundColor(Color.Palette.Foreground.primary)
            
            HStack {
                Button(action: {
                    if zoom > CanvasViewModel.zoomMin {
                        zoom -= 0.1
                    }
                }, label: {
                    Image.SFSymbols.Canvas.magnifyLess
                        .font(Font.Pallete.Button.small)
                        .foregroundColor(Color.Palette.Foreground.primary)
                }).padding(8)

                Slider(value: $zoom, in: CanvasViewModel.zoomMin...CanvasViewModel.zoomMax, step: CanvasViewModel.zoomStep).tint(Color.Palette.primary)

                Button(action: {
                    if zoom < CanvasViewModel.zoomMax {
                        zoom += 0.1
                    }
                }, label: {
                    Image.SFSymbols.Canvas.magnifyMore
                        .font(Font.Pallete.Button.small)
                        .foregroundColor(Color.Palette.Foreground.primary)
                }).padding(8)
            }
        }.padding(8)
    }
}

// MARK: - Preview

#Preview {
    MagnifyMenuView(zoom: .constant(2))
}
#endif
