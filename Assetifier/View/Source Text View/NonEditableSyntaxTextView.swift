//
//  NonEditableSyntaxTextView.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/14/20.
//

import AppKit
import Sourceful

/// A SyntaxTextView that isn't editable,
/// We use it to just display source code
class NonEditableSyntaxTextView: SyntaxTextView {
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        
        contentTextView.isEditable = false
    }
}
