//
//  CodeGenerator.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/14/20.
//

import Foundation


struct CodeGnerator {
    
    let images : [String]
    let colors : [String]
    
    let url : URL?
    
    let settings : CodeGenerationSettings
    
    var source : String {
            
            let imagesTemplate =
    """
    enum ImageAssets : String {

    imageAssetsReplace
    }

    """
            
            let imageTemplate =
    """
        case toreplace
    """
            
            let colorsTemplate =
    """
    enum ColorAssets : String {

    colorAssetsReplace
    }

    """
            
            let colorTemplate =
    """
        case toreplace
    """
                    
            let imageSources = images.sorted().map {
                imageTemplate.replacingOccurrences(of: "toreplace", with: $0)
            }
            
            let imagesSource = imagesTemplate.replacingOccurrences(of: "imageAssetsReplace", with: imageSources.joined(separator: "\n"))
            
            let colorSources = colors.sorted().map {
                colorTemplate.replacingOccurrences(of: "toreplace", with: $0)
            }
            
            let colorsSource = colorsTemplate.replacingOccurrences(of: "colorAssetsReplace", with: colorSources.joined(separator: "\n"))
            
            var swiftui = ""
            if settings.createSwiftUIImageExtension || settings.createSwiftUIColorExtension {
                swiftui = Self.importSwiftUI + "\n\n"
                if settings.createSwiftUIImageExtension {
                    swiftui += Self.swiftuiimageExtension
                }
                if settings.createSwiftUIImageExtension && settings.createSwiftUIColorExtension {
                    swiftui += "\n"
                }
                if settings.createSwiftUIColorExtension {
                    swiftui += Self.swiftuicolorExtension
                }
            }
            
            var uiKit = ""
            if settings.createUIImageExtension || settings.createUIColorExtension {
                uiKit = Self.importUIKit + "\n\n"
                if settings.createUIImageExtension {
                    uiKit += Self.uiimageExtension
                }
                if settings.createUIImageExtension && settings.createUIColorExtension {
                    uiKit += "\n"
                }
                if settings.createUIColorExtension {
                    uiKit += Self.uicolorExtension
                }
            }

            var appKit = ""
            if settings.createNSImageExtension || settings.createNSColorExtension {
                appKit = Self.importAppKit + "\n\n"
                if settings.createNSImageExtension {
                    appKit += Self.nsimageExtension
                }
                if settings.createNSImageExtension && settings.createNSColorExtension {
                    appKit += "\n"
                }
                if settings.createNSColorExtension {
                    appKit += Self.nscolorExtension
                }
              }
            
            var spriteKit = ""
            if settings.createSKSpriteNodeExtension {
                spriteKit = Self.importSpriteKit + "\n\n" + Self.skspritenodeExtension
            }
            
            func header(named name:String) -> String {
    """
    //
    //  \(name).swift
    //  \(url?.deletingLastPathComponent().lastPathComponent ?? "")
    //
    //  Created on \(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none))
    //
                
    """
            }
            
            let multiplatform = (!appKit.isEmpty && !uiKit.isEmpty)
            
            return header(named: "Assets") + "\n\n" +

                (images.isEmpty ? "" : imagesSource + "\n") +
                (colors.isEmpty ? "" : colorsSource + "\n") +

                (swiftui.isEmpty ? "" : "\n") +
                swiftui +
                
                (multiplatform  ? "\n#if os(macOS)" : "") +
                (appKit.isEmpty ? "" : "\n") +
                appKit +
                (appKit.isEmpty ? "" : "\n") +
                (multiplatform ? "\n#else" : "") +
                (uiKit.isEmpty ? "" : "\n") +
                uiKit +
                (uiKit.isEmpty ? "" : "\n") +
                (multiplatform ? "#endif" : "") +
                
                (spriteKit.isEmpty ? "" : "\n\n") +
                spriteKit
        }


        private static let importSwiftUI =
    """
    import SwiftUI
    """

        private static let swiftuiimageExtension : String =
    """
    extension Image {
        init(_ asset:ImageAssets) {
            self.init(asset.rawValue)
        }
    }

    """

        private static let swiftuicolorExtension : String =
    """
    extension Color {
        init(_ asset:ColorAssets) {
            self.init(asset.rawValue)
        }
    }

    """

        private static let importUIKit =
    """
    import UIKit
    """

        private static let uiimageExtension : String =
    """
    extension UIImage {
        convenience init?(_ asset:ImageAssets) {
            self.init(named:asset.rawValue)
        }
    }

    """

        private static let uicolorExtension : String =
    """
    extension UIColor {
        convenience init?(_ asset:ColorAssets) {
            self.init(named:asset.rawValue)
        }
    }

    """
        private static let importAppKit =
    """
    import AppKit
    """

        private static let nsimageExtension : String =
    """
    extension NSImage {
        convenience init?(_ asset:ImageAssets) {
            self.init(named:asset.rawValue)
        }
    }

    """
        
        private static let nscolorExtension : String =
    """
    extension NSColor {
        convenience init?(_ asset:ColorAssets) {
            self.init(named:asset.rawValue)
        }
    }

    """

        
            private static let importSpriteKit =
    """
    import SpriteKit
    """
            
            private static let skspritenodeExtension : String =
    """
    extension SKSpriteNode {
        convenience init(_ asset:ImageAssets) {
            self.init(named:asset.rawValue)
        }
    }
    """

}
