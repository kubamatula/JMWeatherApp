//
//  NSCodingCityPersistanceManager.swift
//  JMWeatherApp
//
//  Created by Jakub Matuła on 02/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation

class DiskLocationPersistanceManager {

    private let url: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    static let sharedInstance = DiskLocationPersistanceManager(path: "locationStorage.json")
    
    private static func documentsURL() -> URL {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            else { fatalError("Could not retrieve documents url") }
        return url
    }
    
    init(path: String) {
        url = DiskLocationPersistanceManager.documentsURL().appendingPathComponent(path)
    }
}

extension DiskLocationPersistanceManager: LocationPersistanceManager {
    
    func saveLocations(_ locations: [Location]) {
        do {
            let data = try encoder.encode(locations)
            try data.write(to: url, options: [])
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func loadLocations() -> [Location]? {
        do {
            let data = try Data(contentsOf: url, options: [])
            let locations = try decoder.decode([Location].self, from: data)
            return locations
        } catch {
            print("error reading locations from disk")
            return nil
        }
    }
    
    func clearLocations(){
        try? FileManager.default.removeItem(at: url)
    }
}
