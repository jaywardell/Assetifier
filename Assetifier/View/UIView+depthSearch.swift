//
//  NSView+depthSearch.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/14/20.
//  Copyright © 2020 Joseph A. Wardell. All rights reserved.
//

import AppKit

extension NSView {
    
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
