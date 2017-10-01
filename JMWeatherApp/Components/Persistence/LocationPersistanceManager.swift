//
//  CityPersistanceManager.swift
//  JMWeatherApp
//
//  Created by Jakub Matuła on 02/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation

protocol LocationPersistanceManager {
    func saveLocations(_ locations: [Location])
    func loadLocations() -> [Location]?
    func clearLocations()
}
