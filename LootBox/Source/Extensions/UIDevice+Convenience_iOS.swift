//
//  UIDevice+Convenience.swift
//  LootBox
//
//  Created by Matej on 30. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import UIKit

extension UIDevice {

    var isIpad: Bool {
        userInterfaceIdiom == .pad
    }
}
#endif
