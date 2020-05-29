//
//  Document.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/11/20.
//

import Cocoa
import SwiftUI
import Combine

class Document: NSDocument {
        
    override class var autosavesInPlace: Bool {
        return false
    }
    
    var assets : AssetCatalog? {
        didSet {
            updateContentView()
        }
    }
    
    var showSidebar = true {
        didSet {
            updateContentView()
        }
    }

    var hasUpdate = false {
        didSet {
            updateContentView()
        }
    }
    
    private func updateContentView() {
        let contentView = ContentView(assets: assets!, showSidebar: showSidebar, assetsHaveBeenUpdated: hasUpdate)
        windowControllers.first?.window?.contentView = NSHostingView(rootView: contentView)
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
    
    
    override func makeWindowControllers() {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(assets: assets!, showSidebar: showSidebar, assetsHaveBeenUpdated: false)
        
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
            
    private var directoryWatcher : DirectoryChangeWatcher?
    private var subscribers = Set<AnyCancellable>()
    
    override func read(from url: URL, ofType typeName: String) throws {
        assets = AssetCatalog(url)
        
        directoryWatcher = DirectoryChangeWatcher(directoryURL: url)
        let sub = directoryWatcher?.didChange.sink { _ in
            self.hasUpdate = true
        }
        subscribers.insert(sub!)

        hasUpdate = false
    }
    
    override func save(_ sender: Any?) {
        guard let window = windowControllers.first?.window else { return }
        
        let panel = NSSavePanel()
        panel.nameFieldStringValue = fileURL?.deletingPathExtension().lastPathComponent ?? "Assets"
        panel.allowedFileTypes = ["swift"]
        panel.beginSheetModal(for: window) { [weak self]  in guard let self = self else { return }

            if $0 == .OK {
                guard let destination = panel.url else { return }
                do {
                    try self.assets?.source.write(to: destination, atomically: true, encoding: .utf8)
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
