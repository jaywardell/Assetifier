//
//  AssetCatalog.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/11/20.
//

import Foundation
import Combine
import SwiftUI


class AssetCatalog : ObservableObject {
        
    let images : [String]
    let colors : [String]

    let url : URL?

    var hasColors: Bool { !colors.isEmpty }
    var hasImages: Bool { !images.isEmpty }

    @ObservedObject var codeGenerationSettings : CodeGenerationSettings
            
    private var sink : AnyCancellable!
    
    init(imageNames:[String], colorNames:[String], url:URL? = nil) {
        self.images = imageNames
        self.colors = colorNames
        self.url = url
        
        /// use a default set of settings
        self.codeGenerationSettings = CodeGenerationSettings()
        
        // unless we've saved one before...
        if let url = url {
            if let savedSettings = UserDefaults.standard.codeGenerationSettings(for: url) {
                self.codeGenerationSettings = savedSettings
            }
        }
        
        // any changes in the code generation settings
        // should propogate up
        // because they represent a change in our source property
        self.sink = codeGenerationSettings.objectWillChange.sink { [weak self] in
            self?.objectWillChange.send()
            
            if let url = self?.url,
                let settings = self?.codeGenerationSettings {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    UserDefaults.standard.set(codeGenerationSettings: settings, for: url)
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    
    var source : String {
        CodeGnerator(images: images, colors: colors, url: url, settings: codeGenerationSettings).source
    }
}

extension AssetCatalog {
    convenience init(_ url:URL) {
                
        let fm = FileManager()
        let ims = fm.children(of: url, withExtension: "imageset")
            .map {
                $0.deletingPathExtension().lastPathComponent
            }
        
        let cls = fm.children(of: url, withExtension: "colorset")

            .map {
                $0.deletingPathExtension().lastPathComponent
            }
        self.init(imageNames: ims, colorNames: cls, url:url)
    }
}


