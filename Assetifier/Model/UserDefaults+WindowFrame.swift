//
//  UserDefaults+WindowFrame.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/14/20.
//

import Foundation

extension UserDefaults {
    
    func frameForWindow(representing url:URL) -> NSRect? {
        
        guard let data = value(forKey: "frame"+String(url.hashValue)) as? Data else { return nil }
        return try? JSONDecoder().decode(NSRect.self, from: data)
    }
    
    func set(frame:NSRect, forWindowRepresenting url:URL) {
        
        if let data = try? JSONEncoder().encode(frame) {
            setValue(data, forKey: "frame"+String(url.hashValue))
        }
    }
    
}
