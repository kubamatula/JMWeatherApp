//
//  JMWeatherAppTests.swift
//  JMWeatherAppTests
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import XCTest
@testable import JMWeatherApp

class JMWeatherAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // helper method for testing parser
    func genericTestParserOn<T: Mappable>(_ expectedResult: [T], jsonFilename: String, predicate: ([T],[T]) -> Bool) where T: Equatable {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: jsonFilename, ofType: "json")!
        let fileURL = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: fileURL)
        let expect = expectation(description: "succesfulParse")
        parse(data: data) { (parseResult: Result<[T], WError>) in
            if case let .success(locations) = parseResult {
                if predicate(locations, expectedResult) {
                    expect.fulfill()
                }
            }
        }
        wait(for: [expect], timeout: 1)
    }
    
    func testParserLocation() {
        let warsawLocation = Location(locationKey: "2696858", locationName: "Warszawa")
        genericTestParserOn([warsawLocation], jsonFilename: "WarszawaLocation", predicate: ==)
        
        let incorrectWarsawLocation = Location(locationKey: "123456", locationName: "asd")
        genericTestParserOn([incorrectWarsawLocation], jsonFilename: "WarszawaLocation", predicate: !=)
    }
    
    func testParserWeather() {
        let sampleWeather = Weather(temprature: 9.1, pressure: 1030.8, weatherIcon: 7, weatherText: "Cloudy", dateTime: 1506871500, location: Location())
        genericTestParserOn([sampleWeather], jsonFilename: "SampleCurrentConditions", predicate: ==)
        
        let incorrecSampleWeather = Weather(temprature: 0, pressure: 0, weatherIcon: 0, weatherText: "", dateTime: 0, location: Location())
        genericTestParserOn([incorrecSampleWeather], jsonFilename: "SampleCurrentConditions", predicate: !=)
    }
}
