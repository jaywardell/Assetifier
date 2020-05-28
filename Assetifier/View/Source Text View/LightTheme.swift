//
//  DarkTheme.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/14/20.
//

import Foundation

import Sourceful


/// meant to be shown when the system is in light mode
/// for some reason, the text view's background and plain text color won't change from the dark mode
/// so for now this is unused
public struct LightTheme: SourceCodeTheme {
    
    public init() {
        
    }
    
    private static var lineNumbersColor: Color {
        return Color(.lightLineNumbers)
    }
    
    public let lineNumbersStyle: LineNumbersStyle? = LineNumbersStyle(font: Font(name: "Menlo", size: 16)!, textColor: lineNumbersColor)
    
    public let gutterStyle: GutterStyle = GutterStyle(backgroundColor: Color(.lightGutter), minimumWidth: 32)
    
    public let font = Font(name: "Menlo", size: 15)!
    
    public let backgroundColor = Color(.lightBackground)
    
    public func color(for syntaxColorType: SourceCodeTokenType) -> Color {
        
        switch syntaxColorType {
        case .plain:
            return Color(.lightTextPlain)
            
        case .number:
            return Color(.lightTextNumber)
            
        case .string:
            return Color(.lightTextString)
            
        case .identifier:
            return Color(.lightTextIdentifier)
            
        case .keyword:
            return Color(.lightTextKeyword)
            
        case .comment:
            return Color(.lightTextComment)
            
        case .editorPlaceholder:
            return backgroundColor
        }
        
    }
    
}
