//
//  ContentView.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//
#if os(macOS)
import Photos
import SwiftUI
import UniformTypeIdentifiers

struct MainView: View {

    @EnvironmentObject private var appStateManager: AppStateManager
    @State private var isSharePickerVisible = false

    var body: some View {
        macOSLayout
    }
}

// MARK: - Mac

private extension MainView {
    
    var macOSLayout: some View {
        HStack {
            TraitsPanelView().frame(width: 350)

            ZStack {
                HStack {
                    centerView
                    SettingsPanelView().frame(width: 250)
                }
                topRightContainer(content: HStack(spacing: 16) {
                    shareView
                    rateView
                })
            }
        }.padding(.all, 8)
    }
    
    func topRightContainer(content: some View) -> some View {
        VStack() { // top
            HStack(spacing: 16) { // right
                Spacer() // push to right edge
                content
            }.padding(.trailing, 16)
            Spacer()
        }
        .padding(.top, 10)
        .padding(.trailing, 250)
    }

    var shareView: some View {
        let url = if AppSettings.Version.isPro {
            AppSettings.Constants.shareProVersionURL
        } else {
            AppSettings.Constants.shareFreeVersionURL
        }
        
        let message = if AppSettings.Version.isPro {
            NSLocalizedString("share_dialog_title", comment: "")
            + NSLocalizedString("\n", comment: "")
            + NSLocalizedString("share_dialog_message", comment: "")
        } else {
            NSLocalizedString("share_dialog_title", comment: "")
            + NSLocalizedString("\n", comment: "")
            + NSLocalizedString("share_dialog_message", comment: "")
        }

        return ShareLink(item: url, message: Text(message)) {
            Image.SFSymbols.share
                .scaledToFit()
                .frame(height: 30)
                .foregroundStyle(Color.Palette.Foreground.primary)
        }.buttonStyle(.plain)
    }
    
    var rateView: some View {
        Image.SFSymbols.star
            .frame(width: 30, height: 30)
            .foregroundColor(Color.Palette.Foreground.primary)
            .onTapGesture {
                Analytics.track(event: .rateButtonPressed)
                NSWorkspace.shared.open(AppSettings.Constants.productHuntReviewURL)
            }
    }
    
    var centerView: some View {
        VStack {
            HStack {
                if !UserDefaults.standard.bool(forKey: UserDefaults.OpenNftKey.didInstallMobileVersion.rawValue) {
                    PhoneButton()
                        .padding(.horizontal, 8)
                }
                Spacer()
                if !AppSettings.Version.isPro {
                    UpgradeButtonView()
                    Spacer()
                }
            }
            CanvasView()
        }
    }
}
#endif
