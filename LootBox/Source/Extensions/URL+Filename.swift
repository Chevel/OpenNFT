//
//  URL+Filename.swift
//  LootBox
//
//  Created by Matej on 21. 10. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import Foundation

extension URL {
    
    var filenameWithoutFileTypeExtension: String {
        if let filenameSubsequence = self.lastPathComponent.split(separator: ".").first {
            String(filenameSubsequence)
        } else {
            self.lastPathComponent
        }
    }
}
