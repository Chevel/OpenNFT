//
//  View+Navigation.swift
//  LootBox
//
//  Created by Matej on 21. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI

extension View {

    func hideNavigationView() -> some View {
        self.navigationTitle("")
            .navigationBarHidden(true)
    }
}
#endif
