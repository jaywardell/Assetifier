//
//  FileManager+DirectoryContentsFiltering.swift
//  Assetifier
//
//  Created by Joseph A. Wardell on 6/3/20.
//  Copyright © 2020 Joseph A. Wardell. All rights reserved.
//

import Foundation

extension FileManager {
    func children(of url:URL, withExtension pathExtension:String) -> [URL] {
        var out = [URL]()
        let children = (try? contentsOfDirectory(at: url, includingPropertiesForKeys: [], options: [.skipsHiddenFiles, .skipsPackageDescendants])) ?? []
        for child in children {
            var isDirectory: ObjCBool = false

            if child.pathExtension == pathExtension {
                out.append(child)
            }
            else if fileExists(atPath: child.path, isDirectory: &isDirectory),
                isDirectory.boolValue {
                out += self.children(of: child, withExtension: pathExtension)
            }
        }
        
        return out
    }
}
