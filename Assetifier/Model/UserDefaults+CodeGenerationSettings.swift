//
//  UserDefaults+CodeGenerationSettings.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/14/20.
//  Copyright © 2020 Joseph A. Wardell. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func codeGenerationSettings(for url:URL) -> CodeGenerationSettings? {
        
        guard let data = value(forKey: "settings"+String(url.hashValue)) as? Data else { return nil }
        do {
        return try JSONDecoder().decode(CodeGenerationSettings.self, from: data)
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func set(codeGenerationSettings:CodeGenerationSettings, for url:URL) {
        
        if let data = try? JSONEncoder().encode(codeGenerationSettings) {
            setValue(data, forKey: "settings"+String(url.hashValue))
        }
    }
    
}
