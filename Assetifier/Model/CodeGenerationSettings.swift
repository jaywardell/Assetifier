//
//  CodeGenerationSettings.swift
//  AssetCatalogConstants
//
//  Created by Joseph A. Wardell on 5/14/20.
//

import Foundation
import Combine

final class CodeGenerationSettings : ObservableObject, Codable {
    
    @Published var createSwiftUIImageExtension = false
    @Published var createSwiftUIColorExtension = false

    @Published var createUIImageExtension = false
    @Published var createUIColorExtension = false

    @Published var createNSImageExtension = false
    @Published var createNSColorExtension = false

    @Published var createSKSpriteNodeExtension = false
    @Published var createSKTextureExtension = false

    init() {
        self.createSwiftUIImageExtension = false
        self.createSwiftUIColorExtension = false

        self.createUIImageExtension = false
        self.createUIColorExtension = false

        self.createNSImageExtension = false
        self.createNSColorExtension = false

        self.createSKSpriteNodeExtension = false
        self.createSKTextureExtension = false
    }
    
    enum CodingKeys: CodingKey {
        case createSwiftUIImageExtension
        case createSwiftUIColorExtension

        case createUIImageExtension
        case createUIColorExtension

        case createNSImageExtension
        case createNSColorExtension

        case createSKSpriteNodeExtension
        case createSKTextureExtension
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(createSwiftUIImageExtension, forKey: .createSwiftUIImageExtension)
        try container.encode(createSwiftUIColorExtension, forKey: .createSwiftUIColorExtension)

        try container.encode(createUIImageExtension, forKey: .createUIImageExtension)
        try container.encode(createUIColorExtension, forKey: .createUIColorExtension)

        try container.encode(createNSImageExtension, forKey: .createNSImageExtension)
        try container.encode(createNSColorExtension, forKey: .createNSColorExtension)

        try container.encode(createSKSpriteNodeExtension, forKey: .createSKSpriteNodeExtension)
        try container.encode(createSKTextureExtension, forKey: .createSKTextureExtension)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        createSwiftUIImageExtension = try container.decode(Bool.self, forKey: .createSwiftUIImageExtension)
        createSwiftUIColorExtension = try container.decode(Bool.self, forKey: .createSwiftUIColorExtension)

        createUIImageExtension = try container.decode(Bool.self, forKey: .createUIImageExtension)
        createUIColorExtension = try container.decode(Bool.self, forKey: .createUIColorExtension)

        createNSImageExtension = try container.decode(Bool.self, forKey: .createNSImageExtension)
        createNSColorExtension = try container.decode(Bool.self, forKey: .createNSColorExtension)

        createSKSpriteNodeExtension = try container.decode(Bool.self, forKey: .createSKSpriteNodeExtension)
        createSKTextureExtension = try container.decode(Bool.self, forKey: .createSKTextureExtension)
    }
}
