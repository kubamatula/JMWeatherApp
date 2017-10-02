//
//  JMWeatherAppTests.swift
//  JMWeatherAppTests
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import XCTest
@testable import JMWeatherApp

class ParserTests: XCTestCase {
    
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
        let warsawLocation = Location(name: "Warszawa", key: "2696858")
        genericTestParserOn([warsawLocation], jsonFilename: "WarszawaLocation", predicate: ==)
        
        let incorrectWarsawLocation = Location(name: "asd", key: "123456")
        genericTestParserOn([incorrectWarsawLocation], jsonFilename: "WarszawaLocation", predicate: !=)
    }
    
    func testParserWeather() {
        let sampleWeather = Weather(temprature: 9.1, weatherIcon: 7, weatherText: "Cloudy", dateTime: 1506871500, location: Location())
        genericTestParserOn([sampleWeather], jsonFilename: "SampleCurrentConditions", predicate: ==)
        
        let incorrecSampleWeather = Weather(temprature: 0, weatherIcon: 0, weatherText: "", dateTime: 0, location: Location())
        genericTestParserOn([incorrecSampleWeather], jsonFilename: "SampleCurrentConditions", predicate: !=)
    }
}
