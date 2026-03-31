//
//  Font+Pallete.swift
//  LootBox
//
//  Created by Matej on 30/09/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

extension Font {

    enum Pallete {
        static let headline = Font.title
        static let headerTitle = Font.system(size: 36, weight: .heavy)
        static let headerSubTitle = Font.system(size: 16, weight: .heavy)
        static let infoText = Font.system(size: 18, weight: .bold)
        static let paywallText = Font.system(size: 14, weight: .bold)
        static let text = Font.system(size: 18)
    }
}

extension Font.Pallete {
    
    enum Icon {
        static let small = Font.system(size: 16, weight: .heavy)
        static let medium = Font.system(size: 24, weight: .heavy)
        static let large = Font.system(size: 50, weight: .heavy)
        
        static let toolbar = Font.system(size: 20, weight: .heavy)
    }
}

extension Font.Pallete {
    
    enum Onboarding {
        static let title = Font.system(size: 48, weight: .heavy)
        static let subtitle = Font.system(size: 24, weight: .bold)
    }
}

extension Font.Pallete {
    
    enum Social {
        static let googleSignIn = Font.custom("Roboto-Medium", size: 20)
        static let appleSignIn = Font.system(size: 19, weight: .bold)
        static let redditSignIn = Font.custom("RedditSans-Bold", size: 20)
    }
}

extension Font.Pallete {
    
    static let termsOfService = Font.system(size: 10)
}

extension Font.Pallete {
    
    enum Button {
        static let small = Font.system(size: 22, weight: .heavy)
        static let medium = Font.system(size: 24, weight: .heavy)
        static let mediumPlus = Font.system(size: 38, weight: .heavy)
        static let big = Font.system(size: 52, weight: .heavy)
        static let bigXXL = Font.system(size: 72, weight: .heavy)
    }
}
