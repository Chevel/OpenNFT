//
//  LootBoxApp.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI
import StoreKit

@main
struct LootBoxApp: App {

#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var delegate

#elseif os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var navigationManager = NavigationManager()
    @State private var subscriptionService = SubscriptionService.shared
    @State private var isSuccessDialogShown = false
#endif
    @State private var appStateManager = AppStateManager()
    @Environment(\.openURL) private var openURL
    
    var body: some Scene {
#if os(iOS)
        iOSLayout
#elseif os(macOS)
        macOSLayout
#endif
    }
}

#if os(iOS)
extension LootBoxApp {
    
    var iOSLayout: some Scene {
        WindowGroup {
            ContentView()
                .environment(appStateManager)
                .environment(subscriptionService)
                .environmentObject(navigationManager)
                .disabled(appStateManager.isExporting)
                .overlay {
                    if appStateManager.isExporting {
                        exportingPopup
                            .ignoresSafeArea(edges: .all)
                    }
                }
                .onAppear(perform: {
                    NftRenderer.shared.appStateManager = appStateManager
                    subscriptionService.appStateManager = appStateManager
                    Task { await subscriptionService.checkSubscriptionStatus() }
                })
                .alert(appStateManager.alert?.localizedMessage ?? "", isPresented: $appStateManager.shouldShowAlert) {
                    Button("generic_ok", role: .cancel) { }
                }
                .alert(appStateManager.error?.localizedMessage ?? "generic_error_title", isPresented: $appStateManager.shouldShowErrorAlert) {
                    Button("generic_ok", role: .cancel) { }
                }
                .alert("alert_message_mint_unavailable", isPresented: $appStateManager.shouldShowMintUnavailable) {
                    Button("generic_ok", role: .cancel) { }
                }
                .fileExporter(
                    isPresented: $appStateManager.shouldShowSuccessAlert,
                    document: MetadataExporter.output,
                    contentType: .zip,
                    defaultFilename: appStateManager.collectionName
                ) { result in
                    switch result {
                    case .success:
                        if let scene = UIApplication.shared.firstActiveScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    case .failure:
                        appStateManager.shouldShowErrorAlert = true
                    }
                }
        }
        .modelContainer(for: [
            TraitsViewModel.self,
            TraitModel.self,
            ImageViewModel.self,
            CanvasViewModel.self
        ], isAutosaveEnabled: false)
    }
}

private extension LootBoxApp {
    
    var exportingPopup: some View {
        ZStack {
            Color.black.opacity(0.5)
            
            VStack(spacing: 8) {
                Text("message_exporting" + " \(appStateManager.exportedIndex) / \(appStateManager.numberOfItems)")
                    .font(Font.Pallete.infoText)
                    .foregroundStyle(Color.Palette.Foreground.primary)
                CancelExportButton()
            }
        }
    }
}
#elseif os(macOS)

extension LootBoxApp {

    var macOSLayout: some Scene {
        WindowGroup(id: "main_window") {
            rootView
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "*"))
        .commands {
            commands
        }
        .modelContainer(for: [
            TraitsViewModel.self,
            SettingsModel.self,
            CanvasViewModel.self
        ], isAutosaveEnabled: false)
    }
}

// MARK: - UI

private extension LootBoxApp {

    var rootView: some View {
        ContentView()
            .disabled(appStateManager.uiModel.isExporting)
            .overlay(content: {
                if appStateManager.uiModel.isExporting {
                    ZStack {
                        Color.black.opacity(0.5)
                        
                        VStack(spacing: 8) {
                            Text(NSLocalizedString("message_exporting", comment: "") + " \(appStateManager.uiModel.exportedIndex) / \(appStateManager.settingsModel.numberOfItems)")
                            CancelExportButton()
                        }
                    }
                }
            })
            .onAppear(perform: {
                NftRenderer.shared.appStateManager = appStateManager
            })
            .environmentObject(appStateManager)
            .alert(appStateManager.uiModel.alert?.localizedMessage ?? "", isPresented: $appStateManager.uiModel.shouldShowAlert) {
                Button("generic_ok", role: .cancel) { }
            }
            .alert(appStateManager.uiModel.error?.localizedMessage ?? "generic_error_title", isPresented: $appStateManager.uiModel.shouldShowErrorAlert) {
                Button("generic_ok", role: .cancel) { }
            }
            .alert(AppSettings.Version.isPro ? "alert_title_succes_pro" : "alert_title_succes", isPresented: $appStateManager.uiModel.shouldShowSuccessAlert) {
                Button("generic_ok", role: .cancel) {
                    SKStoreReviewController.requestReview()
                }
            }
            .alert("alert_paywall_title", isPresented: $appStateManager.uiModel.shouldShowPaywall) {
                HStack {
                    Button("generic_cancel", role: .cancel) { }
                    Button("generic_upgrade", role: .none) {
                        NSWorkspace.shared.open(AppSettings.Constants.appStoreProVersionURL)
                    }
                }
            }
            .alert("alert_message_mint_unavailable", isPresented: $appStateManager.uiModel.shouldShowMintUnavailable) {
                Button("generic_ok", role: .cancel) { }
            }
    }

    @CommandsBuilder
    var commands: some Commands {
        CommandGroup(replacing: .saveItem) {
            Button("workspace_save") {
                Analytics.track(event: .workspaceSave)
                appStateManager.saveWorkspace()
            }
            .keyboardShortcut("S", modifiers: .command)
        }
        CommandGroup(replacing: .newItem) {
            Button("workspace_load") {
                Analytics.track(event: .workspaceLoad)
                appStateManager.loadWorkspace()
            }
            .keyboardShortcut("L", modifiers: .command)
            .disabled(!appStateManager.hasWorkspaceSaveFile)
        }
        CommandGroup(replacing: .importExport) {
            Button("button_title_export") {
                Analytics.track(event: .exportMenuOptionPressed)
#if PRO
                NftRenderer.shared.export(shouldMint: false)
#else
                NSWorkspace.shared.open(AppSettings.Constants.appStoreProVersionURL)
#endif
            }
            .keyboardShortcut("E", modifiers: .command)
            .disabled(appStateManager.isExportDisabled)
        }
        CommandGroup(after: .windowList) {
            Button("toolbar_window_reopen_title") {
                // this guard prevents opening multiple windows when main window is already active.
                // sadly there is no id, title or anything I can find to identify the main window... except this:
                guard !NSApplication.shared.windows.contains(where: { $0.description.contains("SwiftUIWindow") }) else { return }
                if AppSettings.Version.isPro {
                    openURL(URL(string: "OpenNFTPRO://main_window")!)
                } else {
                    openURL(URL(string: "OpenNFT://main_window")!)
                }
            }
        }
    }
}

#endif

// MARK: - Mixpanel requirement

#if os(iOS)

import RevenueCat

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Analytics.setup()
//        if AppSettings.isDevEnvironment {
//            Purchases.logLevel = .debug
//        }

//        Purchases.configure(withAPIKey: Bundle.revenueCatApiKey)
//        Purchases.shared.delegate = SubscriptionService.shared

        return true
    }
}

#elseif os(macOS)

class AppDelegate: NSObject, NSApplicationDelegate {
  
    func applicationWillFinishLaunching(_ notification: Notification) {
        setUpLDClient()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {

        // Warning: NSApplicationCrashOnExceptions is not set. This will result in poor top-level uncaught exception reporting.
        //
        // The reason is that on macOS, AppKit catches the exceptions thrown on the main thread to prevent the application from crashing.
        // But this also prevents Crashlytics from catching them.
        // To disable this behavior we have to set a special user default before initializing Crashlytics:
//        UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions" : true])
        
        Analytics.setup()
    }
    
    // Create a function to initialize the LDClient with your mobile-specific
    // SDK key, context, and optional configurations.
    private func setUpLDClient() {
//        guard case .success(let context) = LDContextBuilder().build() else { return }
//        
//        var config = LDConfig(mobileKey: AppSettings.Constants.LaunchDarkly)
//        config.flagPollingInterval = 30.0
//        config.enableBackgroundUpdates = true
//        config.eventFlushInterval = 30.0
//        
//        LDClient.start(config: config, context: context)
    }
    
}
// end Firebase requirement
#endif
