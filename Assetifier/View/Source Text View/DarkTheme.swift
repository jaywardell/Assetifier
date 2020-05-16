//
//  DarkTheme.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/14/20.
//

import Foundation

import Sourceful


/// A source code theme very much like the default
/// but with a gray comment color
/// I had to do this to demonstrate the use of Assetifier
public struct DarkTheme: SourceCodeTheme {
    
    public init() {
        
    }
    
    private static var lineNumbersColor: Color {
        return Color(.darkLineNumbers)!
    }
    
    public let lineNumbersStyle: LineNumbersStyle? = LineNumbersStyle(font: Font(name: "Menlo", size: 16)!, textColor: lineNumbersColor)
    
    public let gutterStyle: GutterStyle = GutterStyle(backgroundColor: Color(.darkGutter)!, minimumWidth: 32)
    
    public let font = Font(name: "Menlo", size: 15)!
    
    public let backgroundColor = Color(.darkBackground)!
    
    public func color(for syntaxColorType: SourceCodeTokenType) -> Color {
        
        switch syntaxColorType {
        case .plain:
            return Color(.darkTextPlain)!
            
        case .number:
            return Color(.darkTextNumber)!
            
        case .string:
            return Color(.darkTextString)!
            
        case .identifier:
            return Color(.darkTextIdentifier)!
            
        case .keyword:
            return Color(.darkTextKeyword)!
            
        case .comment:
            return Color(.darkTextComment)!
            
        case .editorPlaceholder:
            return backgroundColor
        }
        
    }
    
}
