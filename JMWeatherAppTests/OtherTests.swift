//
//  OtherTests.swift
//  JMWeatherAppTests
//
//  Created by Jakub Matuła on 02/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import XCTest
@testable import JMWeatherApp

class OtherTests: XCTestCase {
    
    func testStringIsLatinOnly() {
        let s = "abcdefAASDX"
        XCTAssert(s.isLatinOnly)
        let s2 = ""
        XCTAssert(s2.isLatinOnly)
        let s3 = "asdbasdf1"
        XCTAssertFalse(s3.isLatinOnly)
        let s4 = "ń"
        XCTAssertFalse(s4.isLatinOnly)
    }
    
    func testTemperatureProvider() {
        let c1 = UIColor(red: 0.1, green: 0, blue: 0, alpha: 0)
        let c2 = UIColor(red: 0.2, green: 0, blue: 0, alpha: 0)
        let c3 = UIColor(red: 0.3, green: 0, blue: 0, alpha: 0)
        let tempProvider = BasicTemperatureColorProvider(lowColor: c1, mediumColor: c2, highColor: c3)
        XCTAssertEqual(c1, tempProvider.fontColor(forTemperature: 5))
        XCTAssertEqual(c2, tempProvider.fontColor(forTemperature: 15))
        XCTAssertEqual(c3, tempProvider.fontColor(forTemperature: 25))
    }

    
}
