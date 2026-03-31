//
//  FeatureFlagManager.swift
//  LootBox
//
//  Created by Matej on 25/05/2023.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import Foundation
//import LaunchDarkly

class FeatureFlagObserver: ObservableObject {
    
    private let featureFlagKey = "OpenNFT-mint-flag"
    private var isObserving = false
    
    @Published var isMintingEnabled = false

//    func startObserving() {
//        guard !isObserving else { return }
//        isObserving = true
//        
//        checkFeatureValue()
//        
//        // Observe the LDClient for any feature flag updates.
//        LDClient.get()!.observe(key: featureFlagKey, owner: self) { [weak self] changedFlag in
//            self?.featureFlagDidUpdate(changedFlag.key)
//        }
//    }
//
//    // Create a function to call LaunchDarkly with the feature flag key you want to evaluate and print its value.
//    private func checkFeatureValue() {
//        if let featureFlagValue = LDClient.get() {
//            let boolVal = featureFlagValue.boolVariation(forKey: featureFlagKey, defaultValue: false)
//            isMintingEnabled = boolVal
//        }
//    }
//    
//    // Create a function to respond to flag updates.
//    func featureFlagDidUpdate(_ key: LDFlagKey) {
//        if key == featureFlagKey {
//            checkFeatureValue()
//        }
//    }
}
