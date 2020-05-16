//
//  GeneratedCodeSidebar.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/14/20.
//


import SwiftUI


struct GeneratedCodeSidebar: View {
    
    @ObservedObject var settings : CodeGenerationSettings
    
    let assetCatalog : AssetCatalog
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(spacing:0) {
                Spacer()
                Text("Include Extensions for:").foregroundColor(.secondary).font(.headline).bold()
                Spacer()
            }
            .padding(.top)
            
            Rectangle().foregroundColor(.secondary).frame(height:1)
                .padding([.leading, .trailing], 8)
            
            VStack(alignment: .leading) {
                Toggle(isOn: $settings.createSwiftUIImageExtension) {
                    Text("SwiftUI Image")
                }
                .font(.callout)
                .disabled(!assetCatalog.hasImages)
                
                Toggle(isOn: $settings.createSwiftUIColorExtension) {
                    Text("SwiftUI Color")
                }
                .font(.callout)
                .disabled(!assetCatalog.hasColors)
            }
            .padding([.leading, .top, .bottom], 8)
            
            //                Spacer(minLength: 8)
            
            VStack(alignment: .leading) {
                Toggle(isOn: $settings.createNSImageExtension) {
                    Text("NSImage")
                }
                .font(.callout)
                .disabled(!assetCatalog.hasImages)
                
                Toggle(isOn: $settings.createNSColorExtension) {
                    Text("NSColor")
                }
                .font(.callout)
                .disabled(!assetCatalog.hasColors)
            }
            .padding([.leading, .bottom], 8)
                        
            VStack(alignment: .leading) {
                Toggle(isOn: $settings.createUIImageExtension) {
                    Text("UIImage")
                }
                .font(.callout)
                .disabled(!assetCatalog.hasImages)
                
                Toggle(isOn: $settings.createUIColorExtension) {
                    Text("UIColor")
                }
                .font(.callout)
                .disabled(!assetCatalog.hasColors)
            }
            .padding([.leading, .bottom], 8)
            

            VStack(alignment: .leading) {
                Toggle(isOn: $settings.createSKSpriteNodeExtension) {
                    Text("SKSpriteNode")
                }
                .font(.callout)
                .disabled(!assetCatalog.hasImages)
            }
            .padding([.leading, .bottom], 8)
            
            Spacer()
                        }    }
}

struct GeneratedCodeSidebar_Previews: PreviewProvider {
        
    static let MockCatalog = AssetCatalog(imageNames: ["barbell"], colorNames: ["turquoise"])
    
    static var previews: some View {
        GeneratedCodeSidebar(settings: MockCatalog.codeGenerationSettings, assetCatalog: MockCatalog)
            .previewLayout(.sizeThatFits)
    }
}
