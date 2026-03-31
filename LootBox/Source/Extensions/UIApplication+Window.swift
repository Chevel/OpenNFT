//
//  UIApplication+Window.swift
//  LootBox
//
//  Created by Matej on 19. 10. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UIApplication {

    func currentUIWindow() -> UIWindow? {
        return firstScene?
            .windows
            .first { $0.isKeyWindow }
    }
    
    var firstScene: UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first
    }
    
    var firstActiveScene: UIWindowScene? {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first
    }
}
#endif
