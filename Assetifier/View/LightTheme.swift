//
//  DarkTheme.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/14/20.
//  Copyright © 2020 Joseph A. Wardell. All rights reserved.
//

import Foundation

import Sourceful


public struct LightTheme: SourceCodeTheme {
    
    public init() {
        
    }
    
    private static var lineNumbersColor: Color {
        return Color(.lightLineNumbers)!
    }
    
    public let lineNumbersStyle: LineNumbersStyle? = LineNumbersStyle(font: Font(name: "Menlo", size: 16)!, textColor: lineNumbersColor)
    
    public let gutterStyle: GutterStyle = GutterStyle(backgroundColor: Color(.lightGutter)!, minimumWidth: 32)
    
    public let font = Font(name: "Menlo", size: 15)!
    
    public let backgroundColor = Color(.lightBackground)!
    
    public func color(for syntaxColorType: SourceCodeTokenType) -> Color {
        
        switch syntaxColorType {
        case .plain:
            return Color(.lightTextPlain)!
            
        case .number:
            return Color(.lightTextNumber)!
            
        case .string:
            return Color(.lightTextString)!
            
        case .identifier:
            return Color(.lightTextIdentifier)!
            
        case .keyword:
            return Color(.lightTextKeyword)!
            
        case .comment:
            return Color(.lightTextComment)!
            
        case .editorPlaceholder:
            return backgroundColor
        }
        
    }
    
}
