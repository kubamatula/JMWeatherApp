//
//  File.swift
//  WeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Location {
    let locationKey: String
    let locationName: String
}

extension Location: Mappable {
    
    init() {
        locationKey = ""
        locationName = ""
    }
    
    static func mapToModel(_ object: Any) -> Result<Location, WError> {
        let json = JSON(object)
        guard let locationKey = json["Key"].string,
            let locationName = json["EnglishName"].string
            else {
                return .failure(.parser)
        }
        return .success(Location(locationKey: locationKey, locationName: locationName))
    }
}

extension Location: Equatable {
    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.locationKey == rhs.locationKey && lhs.locationName == rhs.locationName
    }
}
