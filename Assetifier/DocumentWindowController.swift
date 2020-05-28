//
//  DocumentWindowController.swift
//  Assetifier
//
//  Created by Joseph A. Wardell on 5/26/20.
//

import AppKit

class DocumentWindowController : NSWindowController, NSMenuItemValidation {
    
    @objc
    func saveDocument(_ sender:Any) {
        if let doc = document as? Document {
            doc.save(self)
        }
    }
    
    @objc
    override func selectAll(_ sender: Any?) {
        
        if let textView = window?.contentView?.firstDeepSubview(where: {
            $0 is NSTextView
        }) {
            window?.makeFirstResponder(textView)
            textView.perform(#selector(selectAll(_:)), with: sender, afterDelay: 0)
        }
    }

    @objc
    func toggleSidebar(_ sender:Any?) {
        
        if let doc = document as? Document {
            doc.showSidebar = !doc.showSidebar
        }
    }
    
    @IBAction
    func reload(_ sender:Any?) {
        if let doc = document as? Document,
            let fileURL = doc.fileURL {
            try? doc.read(from: fileURL, ofType: "xcasset")
        }
    }
    
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem.action == #selector(toggleSidebar(_:)) {
            guard let doc = document as? Document else { return false }
            menuItem.title = doc.showSidebar ? "Hide Sidebar" : "Show Sidebar"
        }
        return true
    }
}
