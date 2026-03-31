//
//  ContentView.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//
#if os(iOS)
import Photos
import SwiftUI
import RevenueCatUI
import UniformTypeIdentifiers

struct MainView: View {
    
    @Environment(AppStateManager.self) private var appStateManager: AppStateManager

    @State private var isMagnifyPopoverVisible = false
    @State private var isMorePopoverVisible = false
    @State private var isExportConfigurationVisible = false
    @State private var isConfirmationShown = false
    @State private var isUpsellBannerVisible = false
    
    @State private var isPaywallShown = false

    var body: some View {
        iOSLayout
            .onAppear {
                appStateManager.canvasViewModel.updateCanvas(frame: UIScreen.main.bounds)
                UserDefaults.standard.set(true, forKey: UserDefaults.OpenNftKey.didInstallMobileVersion.rawValue)
            }
            .sheet(isPresented: $isPaywallShown) {
                PaywallView(displayCloseButton: true)
                    .frame(height: UIScreen.main.bounds.height * (UIDevice.current.isIpad ? 0.7 : 0.9))
                    .onAppear { Analytics.track(event: .paywallShown) }
            }
    }
}

// MARK: - UI

private extension MainView {

    var iOSLayout: some View {
        NavigationStack {
            CanvasView()
                .background(Color.Palette.Background.primary)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbarBackground(Color.Palette.Background.primary, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    exportSettingsToolbarItem
                    zoomToolbarItem
                    addTraitToolbarItem
                    if let selectedTraitIndex = appStateManager.traitsViewModel.traits.firstIndex(where: { $0.isSelected }),
                       appStateManager.traitsViewModel.isTraitSelected {
                        moreToolbarItem(for: selectedTraitIndex)
                    }
                    shareToolbarItem
                    exportToolbarItem
                }
                .overlay {
                    TraitEditHUD()
                    if isUpsellBannerVisible && !appStateManager.isUnlocked {
                        upsellBanner
                    }
                }
        }
    }
    
    var upsellBanner: some View {
        VStack {
            Text("paywall_upsell_text_trait")
                .font(Font.Pallete.paywallText)
                .foregroundStyle(Color.Palette.Foreground.primary)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Rectangle().fill(Color.Palette.tertiary).shadow(radius: 3))
                .onTapGesture {
                    appStateManager.isPaywallShown = true
                }
            Spacer()
        }
    }
}

// MARK: - Toolbar

private extension MainView {

    var shareToolbarItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarTrailing) {
            ShareLink(item: AppSettings.Constants.shareFreeVersionURL, message: Text("share_dialog_title")) {
                Image.SFSymbols.share
                    .font(.Pallete.Icon.toolbar)
                    .foregroundStyle(Color.Palette.primary)
                    .frame(width: 23, height: 30)
            }
            .simultaneousGesture(TapGesture().onEnded {
                Analytics.track(event: .shareButtonPressed)
            })
        }
    }

    // ready for SocialLogin feature
//    var accountToolbarItem: ToolbarItem<(), some View> {
//        ToolbarItem(placement: .topBarLeading) {
//            Image.SFSymbols.account
//                .font(.system(size: 20, weight: .heavy))
//                .foregroundStyle(Color.Palette.primary)
//                .padding(8)
//                .onTapGesture {
//                    appStateManager.isLoginShown = true
//                }
//        }
//    }

    var exportSettingsToolbarItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarLeading) {
            Image.SFSymbols.Edit.settings
                .font(.system(size: 20, weight: .heavy))
                .foregroundStyle(Color.Palette.primary)
                .padding(8)
                .onTapGesture {
                    isExportConfigurationVisible.toggle()
                }
                .popover(isPresented: $isExportConfigurationVisible, attachmentAnchor: .point(.top), content: {
                    SettingsMenu()
                        .presentationBackground(Color.Palette.Background.light)
                        .presentationCompactAdaptation(horizontal: .sheet, vertical: .popover)
                })
        }
    }
    
    var zoomToolbarItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarLeading) {
            Image.SFSymbols.Canvas.magnify
                .font(.Pallete.Icon.toolbar)
                .foregroundStyle(Color.Palette.primary)
                .padding(8)
                .onTapGesture {
                    isMagnifyPopoverVisible.toggle()
                }
                .popover(isPresented: $isMagnifyPopoverVisible, attachmentAnchor: .point(.top), content: {
                    @Bindable var model = appStateManager
                    MagnifyMenuView(zoom: $model.canvasViewModel.zoomFactor)
                        .frame(width: 300, height: 90)
                        .background(Color.Palette.Background.light)
                        .presentationCompactAdaptation(.popover)
                })
        }
    }
    
    var addTraitToolbarItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarLeading) {
            Image.SFSymbols.addTraitImages
                .font(.Pallete.Icon.toolbar)
                .foregroundStyle(Color.Palette.primary)
                .padding(8)
                .onTapGesture {
                    guard appStateManager.traitsViewModel.traits.count < AppSettings.Feature.traitLimit || appStateManager.isUnlocked else {
                        isUpsellBannerVisible = true
                        return
                    }
                    isUpsellBannerVisible = false

                    let trait = TraitModel(images: [], zIndex: 0)
                    appStateManager.traitsViewModel.traits.insert(trait, at: 0)
                }
        }
    }
    
    func moreToolbarItem(for traitIndex: Int) -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarLeading) {
            Image.SFSymbols.Edit.more
                .font(.Pallete.Icon.toolbar)
                .foregroundStyle(Color.Palette.primary)
                .padding(8)
                .foregroundStyle(Color.Palette.Foreground.primary)
                .onTapGesture {
                    isMorePopoverVisible = true
                }
                .popover(isPresented: $isMorePopoverVisible, attachmentAnchor: .point(.top), content: {
                    @Bindable var model = appStateManager
                    TraitSettingsMenu(trait: $model.traitsViewModel.traits[traitIndex])
                        .frame(width: 250, height: 100)
                        .background(Color.Palette.Background.light)
                        .presentationCompactAdaptation(.popover)
                })
        }
    }
    
    var exportToolbarItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarTrailing) {
            Text("button_title_export")
                .font(Font.Pallete.infoText)
                .foregroundStyle(Color.Palette.primary)
                .padding(8)
                .onTapGesture {
                    if appStateManager.isUnlocked {
                        isConfirmationShown = true
                    } else {
                        isPaywallShown = true
                    }
                }
                .confirmationDialog(confirmationMessage, isPresented: $isConfirmationShown, titleVisibility: .visible) {
                    if appStateManager.numberOfItems > AppSettings.Constants.exportWarningThreshold {
                        Button("button_title_export", role: .destructive) {
                            withAnimation {
                                NftRenderer.shared.export(shouldMint: false)
                            }
                        }
                        Button("generic_cancel", role: .cancel) {
                            isConfirmationShown = false
                        }
                    } else {
                        Button("button_title_export") {
                            withAnimation {
                                NftRenderer.shared.export(shouldMint: false)
                            }
                        }
                    }
                }
                .disabled(!appStateManager.traitsViewModel.hasValidData)
                .opacity(appStateManager.traitsViewModel.hasValidData ? 1 : 0.4)
        }
    }

    var confirmationMessage: String {
        if appStateManager.numberOfItems > AppSettings.Constants.exportWarningThreshold {
            String(localized: LocalizedStringResource(stringLiteral: "export_confirmation_message_warning"))
        } else {
            String(localized: LocalizedStringResource(stringLiteral: "export_confirmation_message"))
        }
    }
}
#endif
