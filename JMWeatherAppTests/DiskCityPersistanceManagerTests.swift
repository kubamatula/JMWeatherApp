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
        Location(name: "1", key: "1"),
        Location(name: "2", key: "3"),
        Location(name: "4", key: "5"),
    ]
    
    func testLoadLocationsDoesntCrash(){
        let persistanceManager = DiskLocationPersistanceManager(path: "nonexistendpath")
        _ = persistanceManager.loadLocations()
    }
    
    func testSavedEqualsLoaded() {
        let persistanceManager = DiskLocationPersistanceManager(path: "locations.json")
        persistanceManager.saveLocations(sampleLocations)
        let locations = persistanceManager.loadLocations()!
        XCTAssertEqual(sampleLocations, locations)
        persistanceManager.clearLocations()
    }
    
    func testClear(){
        let persistanceManager = DiskLocationPersistanceManager(path: "locations.json")
        persistanceManager.saveLocations(sampleLocations)
        persistanceManager.clearLocations()
        let locations = persistanceManager.loadLocations()
        XCTAssertNil(locations)
    }
}
