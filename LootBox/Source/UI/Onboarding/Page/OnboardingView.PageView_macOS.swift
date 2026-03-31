//
//  OnboardingImagesView.swift
//  LootBox
//
//  Created by Matej on 22. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)
import SwiftUI

extension OnboardingView {

    struct PageView: View {
        let page: OnboardingView.Page.Data

        var body: some View {
            HStack {
                Spacer()
                VStack(alignment: .center, spacing: 16) {
                    Text(page.title)
                        .multilineTextAlignment(.center)
                        .font(Font.Pallete.Onboarding.title)
                        .foregroundStyle(Color.Palette.Foreground.primary)
                        .padding(.top, 90)
                        .shadow(color: .black, radius: 4, x: 4, y: 4)
                    if page.description != nil {
                        Spacer()
                        descriptionSection
                    }
                    Spacer()
                    if let subTitle = page.subTitle {
                        Text(subTitle)
                            .multilineTextAlignment(.center)
                            .font(Font.Pallete.Onboarding.subtitle)
                            .foregroundStyle(Color.Palette.Foreground.primary)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 190)
            .background {
                page.image
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .ignoresSafeArea(.all)
                    .overlay { LinearGradient.Pallete.clearToBlack(start: 0.45, stop: 0.9, endOpacity: 0.8).ignoresSafeArea(.all) }

            }
        }
    }
}

extension OnboardingView.PageView {

    var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(page.description ?? [], id: \.self) { description in
                HStack(alignment: .center) {
                    Image.SFSymbols.checkmarkSeal
                        .scaledToFit()
                        .frame(width: 30, height: 30, alignment: .center)
                        .foregroundStyle(Color.Palette.primary)

                    Text(description)
                        .font(Font.Pallete.infoText)
                        .foregroundStyle(Color.Palette.primary)
                        .shadow(color: .black, radius: 5, x: 3, y: 3)
                }
            }
        }
    }
}
#endif
