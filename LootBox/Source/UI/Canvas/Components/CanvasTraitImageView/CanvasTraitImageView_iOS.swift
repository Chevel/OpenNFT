//
//  TraitImageView.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI

// https://sarunw.com/posts/move-view-around-with-drag-gesture-in-swiftui/
struct CanvasTraitImageView: View {
    
    // MARK: - Private

    @GestureState private var startLocation: CGPoint?
    @Environment(AppStateManager.self) private var appStateManager: AppStateManager

    // MARK: - Properties
    
    @Binding var traitModel: TraitModel
    
    // MARK: - View
    
    var body: some View {
        traitIcon
            .overlay {
                if appStateManager.isLoadingPhotos && traitModel.isSelected {
                    Color.black.opacity(0.5).overlay {
                        ProgressView()
                            .controlSize(.large)
                            .tint(Color.Palette.primary)
                    }
                }
            }
            .border(Color(uiColor: traitModel.frameColor), width: traitModel.isSelected ? 2 : 0)
            .frame(width: traitModel.frame.width, height: traitModel.frame.height)
            .rotationEffect(.degrees(traitModel.rotationAngle))
            .position(traitModel.center)
            .zIndex(traitModel.zIndex)
            .if(traitModel.isSelected) {
                $0.gesture(simpleDrag)
            }
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: traitModel.center) { _ , newCenterPoint in
                            let originPoint = CGPoint(x: newCenterPoint.x - traitModel.frame.width/2,
                                                      y: newCenterPoint.y - traitModel.frame.height/2)
                            traitModel.frame = CGRect(origin: originPoint, size: traitModel.frame.size)
                        }
                }
            )
    }
}

// MARK: - Gestures

private extension CanvasTraitImageView {

    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? traitModel.center

                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                
                traitModel.center = newLocation
            }
            .updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? traitModel.center
            }
    }
}

// MARK: - Body

private extension CanvasTraitImageView {
    
    var model: ImageViewModel? {
        if traitModel.imagesData.isEmpty {
            nil
        } else {
            traitModel.imagesData.first(where: { $0.isSelected })
        }
    }
}

// MARK: - UI

private extension CanvasTraitImageView {

    @ViewBuilder
    var traitIcon: some View {
        if let model {
            model.uiImage.resizable()
        } else {
            Image.SFSymbols.imagePlaceholder.resizable()
        }
    }
}
#endif

//    private static var imageHandlerSize: CGSize { CGSize(width: 10, height: 10) }

// logic for resizing image via corner handlers
//    var imageCornerHandle: some View {
//        Circle()
//            .foregroundStyle(Color.Palette.primary)
//            .frame(width: Self.imageHandlerSize.width, height: Self.imageHandlerSize.height)
//    }
//    var resizeGestureTR: some Gesture {
//        DragGesture()
//            .onChanged { value in
//                isResizePositive = value.location.x > value.startLocation.x && value.location.y < value.startLocation.y
//                resizeAmount = sqrt(pow(value.velocity.width, 2) + pow(value.velocity.height, 2))
//            }
//    }
//    func scaleFactor(forViewSize viewSize: CGSize) -> Double {
//        let viewDiagonal = sqrt(pow(viewSize.width, 2) + pow(viewSize.height, 2))
//        guard !viewDiagonal.isZero else {
//            return 1
//        }
//
//        let scaleFactor = if isResizePositive {
//            1 + (resizeAmount / viewDiagonal)
//        } else {
//            1 - (resizeAmount / viewDiagonal)
//        }
//
//        guard scaleFactor > 0 else {
//            return 1
//        }
//        return scaleFactor
//    }

// logic for having resizable handles on image corners
//            .if(isSelected) {
//                $0
//                    .overlay(alignment: .topLeading) {
//                        imageCornerHandle
//                            .offset(x: -Self.imageHandlerSize.width/2, y: -Self.imageHandlerSize.height/2)
//                    }
//                    .overlay(alignment: .topTrailing) {
//                        imageCornerHandle
//                            .offset(x: Self.imageHandlerSize.width/2, y: -Self.imageHandlerSize.height/2)
//                    }
//                    .overlay(alignment: .bottomLeading) {
//                        imageCornerHandle
//                            .offset(x: -Self.imageHandlerSize.width/2, y: Self.imageHandlerSize.height/2)
//                    }
//                    .overlay(alignment: .bottomTrailing) {
//                        imageCornerHandle
//                            .offset(x: Self.imageHandlerSize.width/2, y: Self.imageHandlerSize.height/2)
//                    }
//            }
//            .overlay(
//                GeometryReader { geo in
//                    Color.clear
//                        .onChange(of: resizeAmount) { _, newValue in
//                            traitModel.frame = geo.frame(in: .named(CanvasView.coordinateSpace))
//                        }
//                }
//            )
