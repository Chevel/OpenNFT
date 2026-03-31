//
//  View+NSWindow.swift
//  LootBox
//
//  Created by Matej on 23/10/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

#if os(macOS)
extension View {

    private func newWindowInternal(with title: String, delegate: NSWindowDelegate?) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 20, y: 20, width: 680, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false)
        window.center()
        window.isReleasedWhenClosed = false
        window.title = title
        window.makeKeyAndOrderFront(nil)
        window.delegate = delegate
        return window
    }
    
    func openNewWindow(with title: String, delegate: NSWindowDelegate?) {
        self.newWindowInternal(with: title, delegate: delegate).contentView = NSHostingView(rootView: self)
    }
}
#endif
