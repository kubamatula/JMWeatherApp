//
//  DiskCityPersistanceManagerTests.swift
//  JMWeatherAppTests
//
//  Created by Jakub Matuła on 02/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import XCTest
@testable import JMWeatherApp

class DiskCityPersistanceManagerTests: XCTestCase {
    
    let sampleLocations = [
        Location(locationKey: "1", locationName: "1"),
        Location(locationKey: "2", locationName: "3"),
        Location(locationKey: "4", locationName: "5"),
    ]
    
    func testLoadLocationsDoesntCrash(){
        let persistanceManager = DiskCityPersistanceManager(path: "nonexistendpath")
        _ = persistanceManager.loadLocations()
    }
    
    func testSavedEqualsLoaded() {
        let persistanceManager = DiskCityPersistanceManager(path: "locations.json")
        persistanceManager.saveLocations(sampleLocations)
        let locations = persistanceManager.loadLocations()!
        XCTAssertEqual(sampleLocations, locations)
        persistanceManager.clearLocations()
    }
    
    func testClear(){
        let persistanceManager = DiskCityPersistanceManager(path: "locations.json")
        persistanceManager.saveLocations(sampleLocations)
        persistanceManager.clearLocations()
        let locations = persistanceManager.loadLocations()
        XCTAssertNil(locations)
    }
}
