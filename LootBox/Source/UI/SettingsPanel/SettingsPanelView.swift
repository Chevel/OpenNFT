//
//  DimensionSettingsView.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI
//import LaunchDarkly

struct SettingsPanelView: View {
    
    @EnvironmentObject private var appStateManager: AppStateManager

    var body: some View {
        HStack {
            separator
                .frame(width: 1)
            VStack(spacing: 40) {
                ScrollView {
                    exportSettingsSection
                    separator.frame(height: 1)
                    canvasSizeSection
                    separator.frame(height: 1)
                    backgroundColorSection
                    separator.frame(height: 1)
                    mintSection
                        .onTapGesture {
                            Analytics.track(event: .mintButtonPressed)
                            if !AppSettings.Version.isPro {
                                appStateManager.uiModel.shouldShowPaywall = true
                            }
                        }
                }
            }.padding([.trailing], 8)
        }
        .onAppear {
//            appStateManager.featureFlagObserver.startObserving()
        }
    }

    // MARK: - UI
    
    private var mintSection: some View {
        VStack(alignment: .center) {
//            VStack(alignment: .leading) {
//                Text("settings_wallet_address")
//                TextField("E.g. 0x33bffae2f3474ebec0d1ecf2a6055208be209217", text: $appStateManager.walletAddress)
////                    .border($appStateManager.isWalletAddresValid.wrappedValue == true ? .green : .red, width: 2)
//                Text("settings_mint_address_warning")
//                Image("polygon-logo")
//                    .resizable()
//                    .scaledToFit()
//                    .onTapGesture {
//                        NSWorkspace.shared.open(AppSettings.Constants.polygonscanForWalletURL(wallet: appStateManager.walletAddress))
//                    }
//            }
            Button {
//                if appStateManager.featureFlagObserver.isMintingEnabled {
//                    Analytics.track(event: .mintButtonPressed)
                    NftRenderer.shared.export(shouldMint: false)
//                } else {
//                    appStateManager.shouldShowMintUnavailable = true
//                }
            } label: {
                Text("button_title_export")
                    .foregroundColor(Color.Palette.Foreground.secondary)
            }
            .buttonStyle(MintButtonStyle())
            .opacity(appStateManager.isExportDisabled ? 0.3 : 1)
            .disabled(appStateManager.isExportDisabled)

            
            // wallet address is not empty
//            .opacity((appStateManager.isWalletAddresValid && !appStateManager.isExportDisabled) ? 1 : 0.3)
//            .disabled(!appStateManager.isWalletAddresValid || appStateManager.isExportDisabled)
//            .disabled(!AppSettings.Version.isPro)
//            .opacity(AppSettings.Version.isPro ? 1 : 0.3)


            // TODO: wallet address validation
//            .opacity($appStateManager.isWalletAddresValid.wrappedValue == true ? 1 : 0.3)
//            .disabled($appStateManager.isWalletAddresValid.wrappedValue == true)

        }.padding(.vertical, 8)
    }
    
    private var exportSettingsSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("settings_nft_name")
                TextField("", text: $appStateManager.settingsModel.collectionName)
            }
            NumberOfItemsInputView()
        }.frame(height: 80)
    }

    private var canvasSizeSection: some View {
        HStack(alignment: .center) {
            Text("settings_size")
            VStack(alignment: .center, spacing: 0) {
                TextField("", value: $appStateManager.canvasViewModel.canvasWidth, formatter: NumberFormatter())
                    .frame(width: 50)
                Text("settings_width")
            }
            Text("x")
            VStack(alignment: .center, spacing: 0) {
                TextField("", value: $appStateManager.canvasViewModel.canvasHeight, formatter: NumberFormatter())
                    .frame(width: 50)
                Text("settings_height")
            }
            Spacer()
        }.frame(height: 80)
    }
    
    private var separator: some View {
        Rectangle()
            .foregroundColor(.Palette.separator)
    }
    
    private var backgroundColorSection: some View {
        HStack {
            VStack(alignment: .leading) {
                ColorPicker("settings_background_color", selection: .init(get: {
                    Color(cgColor: appStateManager.canvasViewModel.backgroundColor.cgColor)
                }, set: {
                    if let cgColor = $0.cgColor, let nsColor = NSColor(cgColor: cgColor) {
                        appStateManager.canvasViewModel.backgroundColor = nsColor
                    }
                }))
            }.frame(height: 80)
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPanelView().environmentObject(AppStateManager())
    }
}
#endif
