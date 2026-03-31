//
//  TraitImageView.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI

// https://sarunw.com/posts/move-view-around-with-drag-gesture-in-swiftui/
struct CanvasTraitImageView: View {
    
    // MARK: - Private

    @EnvironmentObject private var appStateManager: AppStateManager
    @GestureState private var startLocation: CGPoint?
    @State private var isSelected = false

    // MARK: - Properties

    @Binding var traitModel: TraitModel
    @Binding var model: ImageViewModel
    
    // MARK: - View

    var body: some View {
        traitIcon
            .zIndex(traitModel.zIndex)
            .frame(width: traitModel.frame.width, height: traitModel.frame.height)
            .rotationEffect(.degrees(traitModel.rotationAngle))
            .overlay { editMenu }
            .position(traitModel.center)
            .gesture(simpleDrag)
            .gesture(rotationGesture)
            .gesture(pinchToZoom)
            .gesture(simpleTouch)
            .onChange(of: traitModel.center) { _ , newCenterPoint in
                let originPoint = CGPoint(x: newCenterPoint.x - traitModel.frame.width/2, y: newCenterPoint.y - traitModel.frame.height/2)
                traitModel.frame = CGRect(origin: originPoint, size: traitModel.frame.size)
            }
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

    var pinchToZoom: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                traitModel.resize(scale: value.magnification)
            }
            .onEnded { _ in
                traitModel.completeEdit()
            }
    }
    
    var simpleTouch: some Gesture {
        TapGesture(count: 1)
            .onEnded {
                isSelected.toggle()
                traitModel.isFrameVisible = isSelected
            }
    }
    
    var rotationGesture: some Gesture {
        RotateGesture()
            .onChanged { value in
                traitModel.rotate(angle: value.rotation.degrees)
            }
            .onEnded { _ in
                traitModel.completeEdit()
            }
    }
}

// MARK: - Body

private extension CanvasTraitImageView {
    
    var traitIcon: some View {
        model.image
            .resizable()
            .border(traitModel.frameColorValue, width: $traitModel.isFrameVisible.wrappedValue ? 2 : 0)
    }
}

// MARK: - UI

private extension CanvasTraitImageView {

    var editMenu: some View {
        if isSelected {
            return AnyView(
                VStack {
                    HStack {
                        ResetRotationButton()
                            .onTapGesture {
                                Analytics.track(event: .removeCanvasTraitButtonPressed)
                                traitModel.resetRotation()
                            }
                        Spacer()
                        CloseButtonView()
                            .onTapGesture {
                                Analytics.track(event: .removeCanvasTraitButtonPressed)
                                $appStateManager.traitsViewModel.traits.wrappedValue.remove(trait: traitModel)
                            }
                    }
                    Spacer()
                })
        } else {
            return AnyView(EmptyView())
        }
    }
}
#endif
