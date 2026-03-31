//
//  SettingsModel.swift
//  LootBox
//
//  Created by Matej on 27. 12. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(macOS)

import SwiftData
import Foundation

@Model
final class SettingsModel {

    var numberOfItems: Int = 1
    var collectionName: String = NSLocalizedString("collection_name_placeholder", comment: "")

    // Required by @Model
    init() {}
}
#endif
