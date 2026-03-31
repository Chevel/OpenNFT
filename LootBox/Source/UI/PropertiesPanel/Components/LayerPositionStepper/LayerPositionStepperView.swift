//
//  PositionSettingsView.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

// Cool feature, not used currently
struct LayerPositionStepperView: View {
    
    @Binding var zIndex: Double

    var body: some View {
        Stepper {
            Text("settings_layer_position" + " " + String(format: "%.0f", zIndex))
        } onIncrement: {
            incrementStep()
        } onDecrement: {
            decrementStep()
        }
        .padding(5)
    }
    
    // MARK: - Helper
    
    private func incrementStep() {
        guard zIndex < Double.greatestFiniteMagnitude else { return }
        Analytics.track(event: .layerPositionChange)
        zIndex += 1
    }
    
    private func decrementStep() {
        guard zIndex > 0 else { return }
        Analytics.track(event: .layerPositionChange)
        zIndex -= 1
    }
    
}

struct PositionSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LayerPositionStepperView(zIndex: .constant(0))
    }
}
