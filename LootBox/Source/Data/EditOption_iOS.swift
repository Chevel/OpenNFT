//
//  EditOption.swift
//  LootBox
//
//  Created by Matej on 27. 10. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI

enum EditOption: Identifiable {
    case addImages
    case rotate
    case resize
    case delete
    case settings
    
    var icon: some View {
        switch self {
        case .addImages: Image.SFSymbols.Edit.add.resizable()
        case .rotate: Image.SFSymbols.Edit.rotate.resizable()
        case .resize: Image.SFSymbols.Edit.resize.resizable()
        case .delete: Image.SFSymbols.Edit.delete.resizable()
        case .settings: Image.SFSymbols.Edit.settings.resizable()
        }
    }
    
    // MARK: - Identifiable
    
    var id: Self { self }
}
#endif
