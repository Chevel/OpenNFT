//
//  AppStateManager.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI
import SwiftData

@Observable
class AppStateManager: NSObject {

    // MARK: - SwiftData
    
    private var container: ModelContainer?
    
    override init() {
        UIColorValueTransformer.register()
        UIImageValueTransformer.register()
        CGPointValueTransformer.register()
        CGRectValueTransformer.register()
    
        container = try? ModelContainer(
            for: TraitsViewModel.self, CanvasViewModel.self,
            configurations: ModelConfiguration()
        )
    }
    
    // MARK: - Data

    private(set) var isWalletAddresValid = false
    var walletAddress: String = ""
    {
        didSet {
            guard !walletAddress.isEmpty else {
                isWalletAddresValid = false
                return
            }
            isWalletAddresValid = walletAddress.hasPrefix("0x") && walletAddress.count == 42
            
            // TODO: integrate ether.js address validation
            // isWalletAddresValid = Web3Utils.shared.isValidEtherAddress(address: walletAddress)
        }
    }
    var collectionName: String = NSLocalizedString("collection_name_placeholder", comment: "")
    var isExporting = false
    {
        didSet {
            // reset on export start
            if isExporting {
                error = nil
                shouldShowSuccessAlert = false
            }
        }
    }
    var exportedIndex: Int = 0
    
    var isMaxExportLimitReached = false

    var numberOfItems: Int = 1
    {
        didSet {
            if numberOfItems > AppSettings.Feature.exportLimit && !isUnlocked {
                numberOfItems = AppSettings.Feature.exportLimit
                isMaxExportLimitReached = true
            }
            if numberOfItems >= Int.max {
                numberOfItems = Int.max
            }
            if numberOfItems < 0 {
                numberOfItems = 0
            }
        }
    }

    // MARK: - Screen
    
    var currentScreen: AppStateManager.ScreenType = {
        if UserDefaults.standard.bool(forKey: UserDefaults.OpenNftKey.wasOnboardingShown.rawValue) {
            .main
        } else {
            .onboarding
        }
    }()

    // MARK: - Subscription
    
    var isUnlocked = false
    {
        didSet {
            isPaywallShown = !isUnlocked
        }
    }
    var isPaywallShown = false
    {
        didSet {
            Analytics.track(event: .paywallShown)
        }
    }

    // MARK: - UI

    var isSavingWorkspace = false
    var isLoadingWorkspace = false

    var isLoadingPhotos = false
    var shouldShowMintUnavailable = false
    var isMoreMenuVisible = false
    var shouldShowMetadataExportPrompt = false
    var shouldShowSuccessAlert = false
    
    var shouldShowErrorAlert = false
    var error: DisplayableError?
    {
        didSet {
            Task {
                await MainActor.run { shouldShowErrorAlert = error != nil }
            }
        }
    }
    
    var shouldShowAlert = false
    var alert: AppAlert?
    {
        didSet {
            Task {
                await MainActor.run { shouldShowAlert = alert != nil }
            }
        }
    }

    // MARK: - LaunchDarkly
    
    var featureFlagObserver = FeatureFlagObserver()
    
    // MARK: - Trait
    
    // Note: This does not need to be @StateObject because AppStateManager is already.
    // This is just one of its properties that we want to access and be notified when it or one of its properties changes.
    var traitsViewModel = TraitsViewModel()
   
    // MARK: - Canvas

    // Note: This does not need to be @StateObject because AppStateManager is already.
    // This is just one of its properties that we want to access and be notified when it or one of its properties changes.
    var canvasViewModel = CanvasViewModel()

    private(set) var selectedOption: EditOption? {
        didSet {
            guard let selectedOption else { return }
            switch selectedOption {
            case .delete: traitsViewModel.removeSelectedTrait()
            default: break
            }
        }
    }

    func select(option: EditOption?) {
        guard let selectedOption else {
            selectedOption = option
            return
        }
        
        // toggle selection
        if selectedOption == option && selectedOption != .delete { // can't toggle delete
            self.selectedOption = nil
        } else {
            self.selectedOption = option
        }
    }
}

// MARK: - Workspace

extension AppStateManager {
    
    var hasWorkspaceSaveFile: Bool {
        UserDefaults.standard.object(forKey: UserDefaults.OpenNftKey.workspace.rawValue) != nil
    }
    
    @MainActor
    func loadWorkspace() {
        guard let container else { return }
        Analytics.track(event: .workspaceLoad)

        isLoadingWorkspace = true
        defer { isLoadingWorkspace = false }

        let context = container.mainContext
        let traitsDescriptor = FetchDescriptor<TraitsViewModel>(
            predicate: #Predicate { _ in true },
            sortBy: []
        )
        let canvasDescriptor = FetchDescriptor<CanvasViewModel>(
            predicate: #Predicate { _ in true },
            sortBy: []
        )

        do {
            if let traitsViewModel = try context.fetch(traitsDescriptor).first, let canvasViewModel = try context.fetch(canvasDescriptor).first {
                self.traitsViewModel = traitsViewModel
                self.canvasViewModel = canvasViewModel
                alert = .success
            }
        } catch {
            self.error = AppError.workspaceLoad
        }
    }
    
    @MainActor
    func saveWorkspace() {
        guard let container else { return }
        Analytics.track(event: .workspaceSave)
        
        isSavingWorkspace = true
        defer { isSavingWorkspace = false }

        do {
            container.mainContext.insert(traitsViewModel)
            container.mainContext.insert(canvasViewModel)
            try container.mainContext.save()
            UserDefaults.standard.set(true, forKey: UserDefaults.OpenNftKey.workspace.rawValue)
            alert = .success
        } catch {
            self.error = AppError.workspaceSave
        }
    }
}

// MARK: - Computed

extension AppStateManager {
    
    var isExportDisabled: Bool {
        traitsViewModel.traits.isEmpty || traitsViewModel.traits.contains(where: { $0.imagesData.isEmpty })
    }
}

#endif
