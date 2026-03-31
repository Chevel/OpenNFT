//
//  ReorderButton.swift
//  OpenNFT-Pro
//
//  Created by Matej on 19/03/2023.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

struct ReorderButtonView: View {
    
    static let size = CGSize(width: 35, height: 20)
    
    var body: some View {
        Rectangle()
            .frame(width: Self.size.width, height: Self.size.height)
            .foregroundColor(.clear)
            .overlay {
                Image.SFSymbols.reorder
                    .foregroundColor(Color.white)
                    .padding(.all, 4)
            }
    }
}

struct ReorderButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ReorderButtonView()
    }
}
