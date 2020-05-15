//
//  Assets.swift
//  AssetCatalogConstants
//
//  Created on 5/14/20.
//
            

enum ImageAssets : String {

    case box
    case refresh
    case sidebar
}

enum ColorAssets : String {

    case darkBackground
    case darkGutter
    case darkLineNumbers
    case darkTextComment
    case darkTextIdentifier
    case darkTextKeyword
    case darkTextNumber
    case darkTextPlain
    case darkTextString
    case lightBackground
    case lightGutter
    case lightLineNumbers
    case lightTextComment
    case lightTextIdentifier
    case lightTextKeyword
    case lightTextNumber
    case lightTextPlain
    case lightTextString
}


import SwiftUI

extension Image {
    init(_ asset:ImageAssets) {
        self.init(asset.rawValue)
    }
}

import AppKit

extension NSImage {
    convenience init?(_ asset:ImageAssets) {
        self.init(named:asset.rawValue)
    }
}

extension NSColor {
    convenience init?(_ asset:ColorAssets) {
        self.init(named:asset.rawValue)
    }
}

