//
//  ColorTests.swift
//  MeditateTests
//
//  Created by Duff Neubauer on 1/24/21.
//

import XCTest
@testable import Meditate

class ColorTests: XCTestCase {

    func testInitWithHex() throws {
        var sut = Topic.Color(hex: "#DFD7E9")
        XCTAssertEqual(223, sut.red)
        XCTAssertEqual(215, sut.green)
        XCTAssertEqual(233, sut.blue)
        
        sut = Topic.Color(hex: "#B1E2E2")
        XCTAssertEqual(177, sut.red)
        XCTAssertEqual(226, sut.green)
        XCTAssertEqual(226, sut.blue)
        
        sut = Topic.Color(hex: "#CCE5CE")
        XCTAssertEqual(204, sut.red)
        XCTAssertEqual(229, sut.green)
        XCTAssertEqual(206, sut.blue)
    }
    
    func testInitWithHex_withBadString_shouldBeBlack() {
        let sut = Topic.Color(hex: "ZZZZZ")
        XCTAssertEqual(0, sut.red)
        XCTAssertEqual(0, sut.green)
        XCTAssertEqual(0, sut.blue)
    }
    
    func testInitWithHex_withBigHexadecimalNumber_shouldBeBlack() {
        let sut = Topic.Color(hex: "#1111111")
        XCTAssertEqual(0, sut.red)
        XCTAssertEqual(0, sut.green)
        XCTAssertEqual(0, sut.blue)
    }

}
