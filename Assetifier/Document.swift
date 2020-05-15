//
//  Document.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/11/20.
//  Copyright © 2020 Joseph A. Wardell. All rights reserved.
//

import Cocoa
import SwiftUI

class DocumentWindow : NSWindow {
    override var representedURL: URL? {
        didSet {
            standardWindowButton(.documentIconButton)?.image = NSImage(.box)
        }
    }
}

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


class Document: NSDocument {
        
    override class var autosavesInPlace: Bool {
        return false
    }
    
    var assets : AssetCatalog? {
        didSet {
            let contentView = ContentView(assets: assets!, showSidebar: showSidebar)
            windowControllers.first?.window?.contentView = NSHostingView(rootView: contentView)
        }
    }
    
    override var displayName: String! {
        get {
            if let last = fileURL?.lastPathComponent,
                let penultimate = fileURL?.deletingLastPathComponent().lastPathComponent,
                let new = fileURL?.deletingPathExtension().lastPathComponent.appending(".swift") {
                return "\(penultimate) : \(last) to \(new)"
            }
            
            
            return super.displayName
        }
        set {}
    }
    
    var showSidebar = true {
        didSet {
            let contentView = ContentView(assets: assets!, showSidebar: showSidebar)
            windowControllers.first?.window?.contentView = NSHostingView(rootView: contentView)
        }
    }
    
    override func makeWindowControllers() {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(assets: assets!, showSidebar: showSidebar)
        
        // Create the window and set the content view.
        let window = DocumentWindow(
            contentRect: NSRect(x: 0, y: 0, width: 610 + 233, height: 610),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isMovableByWindowBackground = true
        
        if let fileURL = fileURL,
            let frame = UserDefaults.standard.frameForWindow(representing: fileURL) {
            window.setFrame(frame, display: true)
        }
        else {
            window.center()
        }
                
        window.contentView = NSHostingView(rootView: contentView)
        let windowController = DocumentWindowController(window: window)
        self.addWindowController(windowController)
        
        window.delegate = self
        
        // dont' let the Open panel show if we have a document window open
        if let openPanel = NSApp.windows.first(where: { $0 is NSOpenPanel }) as? NSOpenPanel {
            openPanel.cancel(self)
        }
    }
            
    override func read(from url: URL, ofType typeName: String) throws {
        assets = AssetCatalog(url)
            }
    
    override func save(_ sender: Any?) {
        guard let window = windowControllers.first?.window else { return }
        
        let panel = NSSavePanel()
        panel.nameFieldStringValue = fileURL?.deletingPathExtension().lastPathComponent ?? "Assets"
        panel.allowedFileTypes = ["swift"]
        panel.beginSheetModal(for: window) { response in
            if response == .OK {
                guard let destination = panel.url else { return }
                do {
                    try self.assets?.source.write(to: destination, atomically: true, encoding: .utf8)
//                    NSWorkspace.shared.activateFileViewerSelecting([destination])
                }
                catch {
                    Swift.print("error writing generated file to \(destination): \(error)")
                }
            }
        }
    }
        
    @IBAction
    func copy(_ sender:Any?) {
        guard let assets = assets else { return }
        
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(assets.source, forType: .string)
    }
    
    override func canClose(withDelegate delegate: Any, shouldClose shouldCloseSelector: Selector?, contextInfo: UnsafeMutableRawPointer?) {
        
        if let window = windowControllers.first?.window,
            let fileURL = fileURL {
            UserDefaults.standard.set(frame: window.frame, forWindowRepresenting: fileURL)
            UserDefaults.standard.synchronize()
        }
        
        return super.canClose(withDelegate: delegate, shouldClose: shouldCloseSelector, contextInfo: contextInfo)
    }
    
}

extension Document : NSWindowDelegate {
    
    func window(_ window: NSWindow, shouldDragDocumentWith event: NSEvent, from dragImageLocation: NSPoint, with pasteboard: NSPasteboard) -> Bool {
                
        guard let stringToDrag = assets?.source else { return false }
        
        var copiedSource = false
        if let data = stringToDrag.data(using: .utf8) {

            let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(),
                                            isDirectory: true)
            let dragFileURL = temporaryDirectoryURL.appendingPathComponent("Assets.swift")
            
            if nil != (try? data.write(to: dragFileURL)) {
                pasteboard.declareTypes([.string, .fileURL], owner: self)
                pasteboard.setString(stringToDrag, forType: .string)
                pasteboard.setString(dragFileURL.absoluteString, forType: .fileURL)
                copiedSource = true
            }
        }
        
        if !copiedSource {
            // couldn't drag the temp file,
            // just offer the text
            pasteboard.declareTypes([.string], owner: self)
            pasteboard.setString(stringToDrag , forType: .string)
        }
        return true
    }
}
