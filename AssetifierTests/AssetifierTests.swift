//
//  AssetifierTests.swift
//  AssetifierTests
//
//  Created by Joseph A. Wardell on 5/16/20.
//  Copyright © 2020 Joseph A. Wardell. All rights reserved.
//

import XCTest

@testable import Assetifier

/*
 
 Constant and variable names can’t contain whitespace characters, mathematical symbols, arrows, private-use Unicode scalar values, or line- and box-drawing characters. Nor can they begin with a number, although numbers may be included elsewhere within the name.

- https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html
 */

class AssetifierTests: XCTestCase {

    let sut = CodeGnerator(images: ["icon"], colors: ["brown"], url: URL(fileURLWithPath: "/Users/Desktop"), settings: CodeGenerationSettings())
    
    func testSimpleSafeVariableName() {
        XCTAssertEqual(sut.safeVariableName(for: "hello"), "hello")
    }
    
    func testSpacesInVariableName() {
        XCTAssertEqual(sut.safeVariableName(for: "hello there"), "hellothere = \"hello there\"")
        XCTAssertEqual(sut.safeVariableName(for: "hello\there"), "hellohere = \"hello\there\"")
        // NOTE: I don't believe there could be an asset with a newline in its name...
    }
    
    func testMathSymbolsInVariableName() {
        XCTAssertEqual(sut.safeVariableName(for: "one+two"), "onetwo = \"one+two\"")
    }
    
    func testArrowInVariableName() {
        XCTAssertEqual(sut.safeVariableName(for: "one☞two"), "onetwo = \"one☞two\"")
    }
    
    func testEmojiInVariableName() {
        XCTAssertEqual(sut.safeVariableName(for: "one😀two"), "onetwo = \"one😀two\"")
    }

    func testNumberAtStartOfVariableName() {
        XCTAssertEqual(sut.safeVariableName(for: "1two"), "_1two = \"1two\"")
    }
        
    func testVariableNameIsAllSymbols() {
        XCTAssertEqual(sut.safeVariableName(for: "😀♔☺️"), "symbol = \"😀♔☺️\"")
    }
    
    func testBullet() {
        XCTAssertEqual(sut.safeVariableName(for: "•"), "symbol = \"•\"")
    }

    func testCurrencyInVariableName() {
        XCTAssertEqual(sut.safeVariableName(for: "one$two"), "onetwo = \"one$two\"")
    }
    
    func testMultipleAssetsWithMultipleEmojiAssetNames() {
        let sut1 = CodeGnerator(images: ["icon"], colors: ["😀", "😆", "😛"], url: URL(fileURLWithPath: "/Users/Desktop"), settings: CodeGenerationSettings())
        
        let lines = sut1.source.split(separator: "\n")
        
        XCTAssert(lines.contains("    case symbol = \"😀\""))
        XCTAssert(lines.contains("    case symbol1 = \"😆\""))
        XCTAssert(lines.contains("    case symbol2 = \"😛\""))
    }
    
    func testMultipleAssetsWithMathSymbolsInNames() {
        let sut1 = CodeGnerator(images: ["icon"], colors: ["one+two", "one*two", "one=two"], url: URL(fileURLWithPath: "/Users/Desktop"), settings: CodeGenerationSettings())

        let lines = sut1.source.split(separator: "\n")
        
        print(lines.joined(separator: "\n"))
        XCTAssert(lines.contains("    case onetwo = \"one*two\""))
        XCTAssert(lines.contains("    case onetwo1 = \"one+two\""))
        XCTAssert(lines.contains("    case onetwo2 = \"one=two\""))

    }
}
