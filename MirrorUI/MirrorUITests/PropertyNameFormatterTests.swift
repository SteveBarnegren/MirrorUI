//
//  PropertyNameFormatterTests.swift
//  MirrorUITests
//
//  Created by Steve Barnegren on 28/02/2021.
//

import XCTest
@testable import MirrorUI

class PropertyNameFormatterTests: XCTestCase {

    func testPropertyNameFormatter() {

        func test(_ input: String, _ expected: String, file: StaticString = #file, line: UInt = #line) {
            let output = PropertyNameFormatter.displayName(forPropertyName: input)
            XCTAssertEqual(output, expected, file: file, line: line)
        }

        test("name", "Name")
        test("_name", "Name")
        test("myProperty", "My Property")
        test("my_property", "My Property")
        test("my_property2", "My Property 2")
        test("my_property24", "My Property 24")
    }
}
