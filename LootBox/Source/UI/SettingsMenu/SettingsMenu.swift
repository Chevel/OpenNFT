//
//  ExportConfigurationMenu.swift
//  OpenNFT
//
//  Created by Matej on 2. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI
import RevenueCatUI

struct SettingsMenu: View {

    @Environment(AppStateManager.self) private var appStateManager: AppStateManager
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusField: Field?
    @State private var isPaywallShown = false
    
    var body: some View {
        if UIDevice.current.isIpad {
            contentView
                .frame(width: 400, height: 450)
        } else {
            contentView
        }
    }
}

extension SettingsMenu {
    
    enum Field: Hashable {
        case collectionName
        case numberOfNft
    }
}
// MARK: - UI

private extension SettingsMenu {
    
    var contentView: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack(spacing: 36) {
                    workspaceSection
                    collectionNameSection
                    NumberOfItemsInputView(focusField: $focusField)
                    backgroundColorSection
                }
                .padding(16)
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                if focusField == .numberOfNft {
                    ToolbarItem(placement: .keyboard) {
                        Button("generic_ok") {
                            focusField = nil
                        }
                        .bold()
                        .foregroundStyle(Color.Palette.Background.primary)
                    }
                }
                if !UIDevice.current.isIpad {
                    ToolbarItem(placement: .topBarTrailing) {
                        closeButton
                    }
                }
            }
        }
        .sheet(isPresented: $isPaywallShown) {
            PaywallView(displayCloseButton: true)
                .frame(height: UIScreen.main.bounds.height * (UIDevice.current.isIpad ? 0.7 : 0.9))
                .onAppear { Analytics.track(event: .paywallShown) }
        }
    }
    
    var collectionNameSection: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("settings_nft_name")
                    .font(Font.Pallete.infoText)
                    .foregroundStyle(Color.Palette.Foreground.primary)

                @Bindable var model = appStateManager
                TextField("", text: $model.collectionName)
                    .focused($focusField, equals: .collectionName)
                    .font(Font.Pallete.text)
                    .foregroundStyle(Color.Palette.Foreground.primary)
                    .padding(8)
                    .background(Color.Palette.Background.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .submitLabel(.done)
            }
        }.frame(height: 80)
    }

    var workspaceSection: some View {
        VStack(alignment: .leading) {
            Text("workspace_section_title")
                .font(Font.Pallete.infoText)
                .foregroundStyle(Color.Palette.Foreground.primary)
            HStack(spacing: 8) {
                @Bindable var model = appStateManager

                BasicButton(isLoading: $model.isLoadingWorkspace, title: "workspace_load", height: 50) {
                    appStateManager.loadWorkspace()
                }
                .disabled(!appStateManager.hasWorkspaceSaveFile)
                .opacity(appStateManager.hasWorkspaceSaveFile ? 1 : 0.6)

                BasicButton(isLoading: $model.isSavingWorkspace, title: "workspace_save", height: 50) {
                    appStateManager.saveWorkspace()
                }
            }
        }
        .padding(8)
        .disabled(!appStateManager.isUnlocked)
        .overlay {
            if !appStateManager.isUnlocked {
                Color.black
                    .opacity(0.5)
                    .overlay {
                        Image.SFSymbols.lock
                            .resizable()
                            .scaledToFit()
                            .padding(16)
                            .foregroundStyle(Color.Palette.tertiary)
                    }
                    .onTapGesture {
                        isPaywallShown = true
                    }
            }
        }
    }

    var backgroundColorSection: some View {
        @Bindable var model = appStateManager
        return ColorPicker("settings_background_color", selection: $model.canvasViewModel.backgroundColor)
            .font(Font.Pallete.infoText)
            .foregroundStyle(Color.Palette.Foreground.primary)
    }
    
    var closeButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image.SFSymbols.Button.close
                .scaledToFit()
                .foregroundStyle(Color.Palette.Foreground.primary)
        })
        .frame(width: 35, height: 35)
    }
}

#Preview {
    SettingsMenu()
}
#endif
