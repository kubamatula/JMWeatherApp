//
//  File.swift
//  WeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Location: Codable {
    let name: String
    let key: String?
    
    init(name: String = "", key: String? = nil) {
        self.name = name
        self.key = key
    }
}

extension Location: Mappable {
    
    static func mapToModel(_ object: Any) -> Result<Location, WError> {
        let json = JSON(object)
        guard let key = json["Key"].string,
            let name = json["EnglishName"].string
            else {
                return .failure(.parser)
        }
        return .success(Location(name: name, key: key))
    }
}

extension Location: Equatable {
    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.key == rhs.key && lhs.name == rhs.name
    }
}
