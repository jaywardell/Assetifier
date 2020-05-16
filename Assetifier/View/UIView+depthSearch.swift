//
//  NSView+depthSearch.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/14/20.
//

import AppKit

extension NSView {
    
    /// Does a depth-first search through the view's subview hierarchy
    /// and returns the first view it finds that passes the condition passed in
    func firstDeepSubview(where condition: (NSView)->Bool) -> NSView? {
        if let foundHere = subviews.first(where: condition) {
            return foundHere
        }
        
        for subview in subviews {
            if let found = subview.firstDeepSubview(where: condition) {
                return found
            }
        }
        return nil
    }
    
}
