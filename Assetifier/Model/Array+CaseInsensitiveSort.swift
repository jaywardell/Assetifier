//
//  Array+CaseInsensitiveSort.swift
//  Assetifier
//
//  Created by Joseph A. Wardell on 6/3/20.
//

import Foundation

extension Array where Element == String {
    
    func caseInsensitiveSort() -> [Element] {
        sorted(by: {$0.localizedCompare($1) == .orderedAscending})
    }
}
