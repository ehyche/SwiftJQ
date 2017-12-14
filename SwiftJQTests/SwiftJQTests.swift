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
    
    func testExample() {
        let json = """
        {"text": "This is the message text","num":4,"silly":false}
        """

        // Just pretty-print it
        let jsonPP = json.jqFilter(".", sortKeys: true) ?? ""

        print("pretty-printed = \n\(jsonPP)")

        XCTAssert(!jsonPP.isEmpty, "Expected non-empty pretty-printed string, but did not get it")
    }
    
}
