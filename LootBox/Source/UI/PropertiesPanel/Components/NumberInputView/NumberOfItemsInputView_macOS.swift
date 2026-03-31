//
//  NumberInputView.swift
//  LootBox
//
//  Created by Matej on 23/10/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI

struct NumberOfItemsInputView: View {

    @EnvironmentObject private var appStateManager: AppStateManager
    
    private var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximum = NSNumber(integerLiteral: AppSettings.Feature.exportLimit)
        formatter.allowsFloats = false
        return formatter
    }

    var body: some View {
        Stepper {
            HStack {
                Text("settings_number_of_nfts")
                TextField("", value: $appStateManager.settingsModel.numberOfItems, formatter: formatter)
            }
        } onIncrement: {
            incrementStep()
        } onDecrement: {
            decrementStep()
        }
    }
    
    private func incrementStep() {
        Analytics.track(event: .numberOfNftMore)

        guard $appStateManager.settingsModel.numberOfItems.wrappedValue < AppSettings.Feature.exportLimit else {
            appStateManager.uiModel.shouldShowPaywall = true
            return
        }

        $appStateManager.settingsModel.numberOfItems.wrappedValue += 1
    }

    private func decrementStep() {
        Analytics.track(event: .numberOfNftLess)

        guard $appStateManager.settingsModel.numberOfItems.wrappedValue > 0 else { return }
        $appStateManager.settingsModel.numberOfItems.wrappedValue -= 1
    }
}

struct NumberInputView_Previews: PreviewProvider {
    static var previews: some View {
        NumberOfItemsInputView().environmentObject(AppStateManager())
    }
}
#endif
