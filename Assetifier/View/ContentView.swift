//
//  ContentView.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/11/20.
//  Copyright © 2020 Joseph A. Wardell. All rights reserved.
//

import SwiftUI
import AppKit

struct ContentView: View {
    
    @ObservedObject var assets : AssetCatalog
    
    let showSidebar : Bool
    
    var body: some View {
        HStack {
            List {
                GeneratedCodeSidebar(settings: assets.codeGenerationSettings, assetCatalog: assets)
            }
            .listStyle(SidebarListStyle())
            .frame(width: showSidebar ? 233 : 0)

            VStack {
                SelectableText(text:assets.source, selectable: true)

                ButtonBar()
            }
            .frame(minWidth: 377, minHeight: 377)
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    
    @State static var showSidebar = true
    
    static var previews: some View {
        ContentView(assets: AssetCatalog(imageNames: ["barbell"], colorNames: ["turquoise"]), showSidebar: showSidebar)
    }
}
