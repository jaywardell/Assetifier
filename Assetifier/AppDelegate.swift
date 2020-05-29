//
//  AppDelegate.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/11/20.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
  
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        
        let url = URL(fileURLWithPath: filename)
        
        if let existing = NSDocumentController.shared.document(for: url) {
            // it's an existing document
            // bring its window to the front
            //and reload the asset catalog in case there are changes
            existing.showWindows()
            try? existing.read(from: url, ofType: "xcassets")
            return true
        }
        
        
        return false
    }
    
    
    func applicationDidBecomeActive(_ notification: Notification) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if NSApp.windows.isEmpty {
                NSDocumentController.shared.beginOpenPanel { urls in
                    if let url = urls?.first {
                        NSDocumentController.shared.openDocument(withContentsOf: url, display: true) { _, _, _ in
                            
                        }
                    }
                }
            }
        }
    }
    
    func applicationDidResignActive(_ notification: Notification) {

        if let openPanel = NSApp.windows.first(where: { $0 is NSOpenPanel }) as? NSOpenPanel {
            openPanel.cancel(self)
            
        }
    }

}

