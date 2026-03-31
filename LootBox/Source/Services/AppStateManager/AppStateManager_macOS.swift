//
//  AppStateManager.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI
import SwiftData

class AppStateManager: NSObject, ObservableObject {
    
    // MARK: - SwiftData
    
    private var container: ModelContainer?
    
    override init() {

        CGPointValueTransformer.register()
        NSColorValueTransformer.register()
        NSImageValueTransformer.register()
        CGRectValueTransformer.register()
    
        container = try? ModelContainer(for: TraitsViewModel.self, CanvasViewModel.self, SettingsModel.self, configurations: ModelConfiguration())
    }
    
    // MARK: - Data

    @Published private(set) var isWalletAddresValid = false
    @Published var walletAddress: String = ""
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

    // MARK: - UI

    @Published var uiModel = AppUiModel()

    // MARK: - LaunchDarkly
    
    @Published var featureFlagObserver = FeatureFlagObserver()
    
    // MARK: - Trait
    
    // Note: This does not need to be @StateObject because AppStateManager is already.
    // This is just one of its properties that we want to access and be notified when it or one of its properties changes.
    @Published var traitsViewModel = TraitsViewModel()
   
    // MARK: - Canvas

    // Note: This does not need to be @StateObject because AppStateManager is already.
    // This is just one of its properties that we want to access and be notified when it or one of its properties changes.
    @Published var canvasViewModel = CanvasViewModel()
    
    // MARK: - Settings
    
    @Published var settingsModel = SettingsModel()
}

// MARK: - Computed

extension AppStateManager {
    
    var isExportDisabled: Bool {
        traitsViewModel.traits.isEmpty || traitsViewModel.traits.contains(where: { $0.imagesData.isEmpty })
    }
}

// MARK: - NSWindowDelegate

extension AppStateManager: NSWindowDelegate {
    
    func windowWillClose(_ notification: Notification) {
        uiModel.isExporting = false
        NftRenderer.shared.cancelExport()
    }
}

// MARK: - Workspace

extension AppStateManager {
    
    var hasWorkspaceSaveFile: Bool {
        UserDefaults.standard.object(forKey: UserDefaults.OpenNftMacOSKey.workspace.rawValue) != nil
    }
    
    @MainActor
    func loadWorkspace() {
        guard let container else { return }
        Analytics.track(event: .workspaceLoad)

        uiModel.isLoadingWorkspace = true
        defer { uiModel.isLoadingWorkspace = false }

        let context = container.mainContext
        let traitsDescriptor = FetchDescriptor<TraitsViewModel>(
            predicate: #Predicate { _ in true },
            sortBy: []
        )
        let canvasDescriptor = FetchDescriptor<CanvasViewModel>(
            predicate: #Predicate { _ in true },
            sortBy: []
        )
        let settingsDescriptor = FetchDescriptor<SettingsModel>(
            predicate: #Predicate { _ in true },
            sortBy: []
        )

        do {
            if
                let settingsModel = try context.fetch(settingsDescriptor).first,
                let traitsViewModel = try context.fetch(traitsDescriptor).first,
                let canvasViewModel = try context.fetch(canvasDescriptor).first {
                self.traitsViewModel = traitsViewModel
                self.canvasViewModel = canvasViewModel
                self.settingsModel = settingsModel
                uiModel.alert = .success
            }
        } catch {
            uiModel.error = AppError.workspaceLoad
        }
    }
    
    @MainActor
    func saveWorkspace() {
        guard let container else { return }
        Analytics.track(event: .workspaceSave)
        
        uiModel.isSavingWorkspace = true
        defer { uiModel.isSavingWorkspace = false }

        do {
            container.mainContext.insert(traitsViewModel)
            try container.mainContext.save()

            container.mainContext.insert(canvasViewModel)
            container.mainContext.insert(settingsModel)
            try container.mainContext.save()
            
            UserDefaults.standard.set(true, forKey: UserDefaults.OpenNftMacOSKey.workspace.rawValue)
            uiModel.alert = .success
        } catch {
            uiModel.error = AppError.workspaceSave
        }
    }
}
#endif
