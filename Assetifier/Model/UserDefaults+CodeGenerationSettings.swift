//
//  UserDefaults+CodeGenerationSettings.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/14/20.
//

import Foundation

extension UserDefaults {
    
    private func key(for url:URL) -> String {
        "settings"+url.path
    }
    
    func codeGenerationSettings(for url:URL) -> CodeGenerationSettings? {
        
        guard let data = value(forKey: key(for: url)) as? Data else { return nil }
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
            setValue(data, forKey: key(for: url))
        }
    }
    
}
