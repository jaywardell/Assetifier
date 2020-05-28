//
//  DocumentWindow.swift
//  Assetifier
//
//  Created by Joseph A. Wardell on 5/26/20.
//

import AppKit

class DocumentWindow : NSWindow {
    override var representedURL: URL? {
        didSet {
            standardWindowButton(.documentIconButton)?.image = NSImage(.box)
        }
    }
}
