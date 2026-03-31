//
//  CanvasView.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

struct CanvasView: View {

    // MARK: - Properties

#if os(iOS)
    @Environment(AppStateManager.self) private var appStateManager: AppStateManager
#elseif os(macOS)
    @EnvironmentObject private var appStateManager: AppStateManager
#endif

    @State private var zoomFactor = 0.0
    @State private var zoomFactorFinalAmount = 1.5

    // MARK: - Content

    var body: some View {
#if os(macOS)
        macOSLayout
#elseif os(iOS)
        iOSLayout
#endif
    }
}

// MARK: - Coordinate namespace

extension CanvasView {
    
    static let coordinateSpace = "\(CanvasView.self)"
}

#if os(iOS)

private extension CanvasView {

    var iOSLayout: some View {
        GeometryReader { geo in
            ScrollView([.horizontal, .vertical]) {
                contentContainer
                    .coordinateSpace(name: CanvasView.coordinateSpace)
                    .overlay {
                        traitLayers
                            .clipped()
                    }
            }
            .ignoresSafeArea(edges: .bottom)
            .onTapGesture {
                if let selectedTrait = appStateManager.traitsViewModel.selectedTrait {
                    selectedTrait.completeEdit()
                }
                appStateManager.traitsViewModel.deselectAll()
            }
            .scrollIndicators(.visible)
            .scrollDisabled(appStateManager.traitsViewModel.isTraitSelected)
            .gesture(pinchToZoom)
        }
    }

    var traitLayers: some View {
        ZStack {
            ForEach(Array(appStateManager.traitsViewModel.traits.enumerated()), id:\.element) { index, _ in
                @Bindable var model = appStateManager

                CanvasTraitImageView(traitModel: $model.traitsViewModel.traits[index])
                    .onTapGesture {
                        appStateManager.traitsViewModel.toggleTraitSelection(traitId: appStateManager.traitsViewModel.traits[index].id)
                    }
            }
        }
        .scaleEffect(appStateManager.canvasViewModel.zoomFactor, anchor: .center)
    }
    
    var contentContainer: some View {
        backgroundColor
            .frame(width: appStateManager.canvasViewModel.width, height: appStateManager.canvasViewModel.height)
            .tile(Circle(), of: CGSize(width: 3, height: 3), spacing: .init(width: 80, height: 80))
            .scaleEffect(appStateManager.canvasViewModel.zoomFactor, anchor: .center)
            .foregroundStyle(Color.Palette.Background.light)
    }
    
    var backgroundColor: Color {
        if appStateManager.canvasViewModel.backgroundUiColor == .clear {
            Color.Palette.Background.primary
        } else {
            Color(uiColor: appStateManager.canvasViewModel.backgroundUiColor)
        }
    }
    
    // MARK: - Gesture

    var pinchToZoom: some Gesture {
        MagnificationGesture()
            .onChanged { amount in
                zoomFactor = amount - 1
                let normalizedZoom = normalizeZoom(zoomFactor: zoomFactorFinalAmount + zoomFactor)
                appStateManager.canvasViewModel.zoomFactor = normalizedZoom
            }
            .onEnded { amount in
                zoomFactorFinalAmount = normalizeZoom(zoomFactor: zoomFactorFinalAmount + zoomFactor)
                zoomFactor = 0
                let normalizedZoom = zoomFactorFinalAmount
                appStateManager.canvasViewModel.zoomFactor = normalizedZoom
            }
    }
    
    private func normalizeZoom(zoomFactor: CGFloat) -> CGFloat{
        return min(max(zoomFactor, CanvasViewModel.zoomMin), CanvasViewModel.zoomMax)
    }
}

#elseif os(macOS)

// MARK: - macOS

private extension CanvasView {
    
    var macOSLayout: some View {
        ScrollViewReader { proxy in
            ScrollView([.horizontal, .vertical]) {
                ZStack {
                    ForEach(Array(appStateManager.traitsViewModel.traits.enumerated()), id:\.element) { index, _ in
                        if let selectedImageData = $appStateManager
                            .traitsViewModel
                            .traits[index].imagesData
                            .first(where: { $0.isSelected.wrappedValue })
                         {
                            let traitModel = $appStateManager.traitsViewModel.traits[index]
                            CanvasTraitImageView(traitModel: traitModel, model: selectedImageData)
                        }
                    }
                }
                .frame(width: appStateManager.canvasViewModel.canvasWidth, height: appStateManager.canvasViewModel.canvasHeight)
                .border(.white)
                .clipped()
                .coordinateSpace(name: CanvasView.coordinateSpace)
                .background(appStateManager.canvasViewModel.backgroundColorValue)
            }
        }
    }
}
#endif
