//
//  SubscriptionService.swift
//  LootBox
//
//  Created by Matej on 25. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import Foundation
import RevenueCat

@Observable
final class SubscriptionService: NSObject {
    
    // MARK: - Init
    
    static let shared: SubscriptionService = SubscriptionService()
    private override init() {}
    
#if DEBUG
    private var cachedIsUnlocked = true
#else
    private var cachedIsUnlocked = false
#endif
    
    // MARK: - Properties

    var appStateManager: AppStateManager? {
        didSet {
            if appStateManager != nil {
                appStateManager?.isUnlocked = cachedIsUnlocked
            }
        }
    }

    func checkSubscriptionStatus() async {
#if DEBUG
        cachedIsUnlocked = true
#else
        Task {
            let customerInfo = try await Purchases.shared.customerInfo()
            if let appStateManager {
                appStateManager.isUnlocked = customerInfo.entitlements.all["pro"]?.isActive ?? false
            } else {
                cachedIsUnlocked = customerInfo.entitlements.all["pro"]?.isActive ?? false
            }
        }
#endif
        
    }
}

// MARK: - PurchasesDelegate

extension SubscriptionService: PurchasesDelegate {

    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
#if DEBUG
        cachedIsUnlocked = true
#else
        if let appStateManager {
            appStateManager.isUnlocked = customerInfo.entitlements.all["pro"]?.isActive ?? false
        } else {
            cachedIsUnlocked = customerInfo.entitlements.all["pro"]?.isActive ?? false
        }
#endif
    }
}
#endif
