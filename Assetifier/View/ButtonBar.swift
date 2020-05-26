//
//  ButtonBar.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/15/20.
//

import SwiftUI

struct ButtonBar: View {
    
    let showRefreshButton : Bool
    
    var body: some View {
        HStack {
            Button(action: toggleSidebar) {
                Image(.sidebar)
                    .resizable()
                    .frame(width: 21, height: 21)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer().frame(width: 21)
            
            if showRefreshButton {
            Button(action: reload) {
                Image(.refresh)
                .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 21)
            }
            .buttonStyle(BorderlessButtonStyle())
            }

            Spacer()

            Button(action: copy) {
                Text("Copy")
                    .frame(minWidth:55)
            }
            .buttonStyle(BorderlessButtonStyle())

            Button(action: save) {
                Text("Save…")
                .frame(minWidth:55)
            }
            .buttonStyle(BorderlessButtonStyle())

        }
        .padding([.leading, .bottom, .trailing], 5)
        .frame(height: 34)
    }
    
      private func reload() {
          NSApp.sendAction(#selector(DocumentWindowController.reload), to: nil, from: self)
      }

      private func toggleSidebar() {
          NSApp.sendAction(#selector(DocumentWindowController.toggleSidebar(_:)), to: nil, from: self)
      }
      
      private func copy() {
          NSApp.sendAction(#selector(Document.copy(_:)), to: nil, from: self)
      }
      
      private func save() {
          NSApp.sendAction(#selector(NSDocument.save(_:)), to: nil, from: self)
      }

}

struct ButtonBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ButtonBar(showRefreshButton: true)
            ButtonBar(showRefreshButton: false)

        }
    }
}
