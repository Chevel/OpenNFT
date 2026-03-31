//
//  OnboardingView.swift
//  LootBox
//
//  Created by Matej on 22. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI

struct OnboardingView: View {

    @EnvironmentObject private var appStateManager: AppStateManager
    @State private var currentIndex = 0

    private let pages: [OnboardingView.Page] = [
        .info(page1data),
        .info(page2data),
        .info(page3data)
    ]
    
    private static var page1data: OnboardingView.Page.Data {
        .init(
            image: Image("macos-onboarding-1"),
            title: NSLocalizedString("onboarding_page_images_title", comment: ""),
            description: nil,
            subTitle: NSLocalizedString("onboarding_page_images_subtitle", comment: ""),
            isLast: false
        )
    }
    
    private static var page2data: OnboardingView.Page.Data {
        .init(
            image: Image("macos-onboarding-2"),
            title: NSLocalizedString("onboarding_page_build_title", comment: ""),
            description: nil,
            subTitle: NSLocalizedString("onboarding_page_build_subtitle", comment: ""),
            isLast: false
        )
    }
    
    private static var page3data: OnboardingView.Page.Data {
        .init(
            image: Image("macos-onboarding-3"),
            title: NSLocalizedString("onboarding_page_export_title", comment: ""),
            description: [
                NSLocalizedString("onboarding_page_export_description_1", comment: ""),
                NSLocalizedString("onboarding_page_export_description_2", comment: ""),
                NSLocalizedString("onboarding_page_export_description_3", comment: "")
            ],
            subTitle: NSLocalizedString("onboarding_page_export_subtitle", comment: ""),
            isLast: true
        )
    }

    // MARK: - UI

    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .background(Color.Palette.Background.primary)
            .ignoresSafeArea(.all)
            .overlay {
                VStack(spacing: 24) {
                    Spacer()
                    Fancy3DotsIndexView(numberOfPages: pages.count, currentIndex: currentIndex)
                        .padding(.bottom, 16)
                    nextButton
                }.padding(.bottom, 24)
            }
    }
}

// MARK: - UI

private extension OnboardingView {

    @ViewBuilder
    var contentView: some View {
        TabView(selection: $currentIndex.animation()) {
            ForEach(0 ..< pages.count, id: \.self) { index in
                switch pages[index] {
                case .info(let data):
                    PageView(page: data)
                        .ignoresSafeArea(.all)
                        .tag(index)
                        .onAppear { Analytics.track(event: .onboardingStepCompleted, data: ["Step": "\(index)"]) }
                }
            }
        }
    }
}

// MARK: - UI

private extension OnboardingView {
    
    var nextButton: some View {
        Button(action: {
            nextPage()
        }, label: {
            HStack {
                Spacer()
                Text(ctaText)
                    .font(Font.Pallete.infoText)
                    .padding(.all, 16)
                    .foregroundColor(Color.Palette.Background.primary)
                Spacer()
            }
        }).buttonStyle(BigActionButtonStyle(color: isLastPage ? Color.Palette.primary : .white))
    }
    
    var ctaText: String {
        if isLastPage {
            NSLocalizedString("onboarding_button_start", comment: "")
        } else {
            NSLocalizedString("onboarding_button_next", comment: "")
        }
    }
}

// MARK: - Page Helper

private extension OnboardingView {
    
    func nextPage() {
        if isLastPage {
            withAnimation {
                Analytics.track(event: .onboardingDone)
                UserDefaults.standard.set(true, forKey: UserDefaults.OpenNftKey.wasOnboardingShown.rawValue)
                appStateManager.uiModel.currentScreen = .main
            }
            return
        }
        withAnimation {
            currentIndex += 1
        }
    }
    
    var isLastPage: Bool {
        currentIndex == pages.count-1
    }
}
#endif
