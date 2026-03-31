//
//  Data.swift
//  LootBox
//
//  Created by Matej on 29. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

extension OnboardingView {
    
    enum Page {
        case info(Data)
        
        var data: Data {

            switch self {
            case .info(let data): return data
            }
        }
    }
}

extension OnboardingView.Page {
    
    struct Data {
        let image: Image
        let title: String
        let description: [String]?
        let subTitle: String?
        let isLast: Bool
    }
}
