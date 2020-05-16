//
//  SelectableText.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/12/20.
//

import SwiftUI
import Sourceful

struct SelectableText : NSViewRepresentable {

    var text: String
    let selectable: Bool

    var del = SelectableTextSyntaxDelegate()
    
    @Environment(\.colorScheme) var colorScheme

    
    func makeNSView(context: Context) ->  SyntaxTextView {
        let out = NonEditableSyntaxTextView()
//        out.theme = colorScheme == .dark ? DarkTheme() : LightTheme()
        // I'd love to have the above, but I just can't get it to work...
        out.theme = DarkTheme()
        
        out.text = text
        
        out.delegate = del
                
        return out
    }
    
    func updateNSView(_ textView: SyntaxTextView, context: Context) {
        textView.text = ""
        textView.text = text
        
        // SyntaxTextView seems to sometimes lose its delegate
        // when its source changes
        // so reset it every chance we get
        textView.delegate = del
        
//        textView.theme = (colorScheme == .dark) ? DarkTheme() : LightTheme()
        textView.setNeedsDisplay(NSRect(x: 0, y: 0, width: 1000000, height: 1000000))
    }
}

class SelectableTextSyntaxDelegate : SyntaxTextViewDelegate {
    
    func lexerForSource(_ source: String) -> Lexer {
        SwiftLexer()
    }
}

