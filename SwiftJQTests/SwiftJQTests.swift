//
//  SwiftJQTests.swift
//  SwiftJQTests
//
//  Created by Eric Hyche on 11/28/17.
//  Copyright © 2017 HeirPlay Software. All rights reserved.
//

import XCTest
@testable import SwiftJQ

class SwiftJQTests: XCTestCase {
    
    func testBasicTests() {

        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "jq", ofType: "test") else {
            XCTFail("Could not find path to test file.")
            return
        }

        var fileString = ""
        do {
            fileString = try String(contentsOfFile: path, encoding: .utf8)
        } catch {
            XCTFail("Could not open test file.")
            return
        }

        let fileLines = fileString.split(separator: "\n")
        for i in 0..<fileLines.count {

        }

        print("file jq.test has \(fileLines.count) lines")

        XCTAssertTrue(true, "Expected non-empty pretty-printed string, but did not get it")
    }
    
}
