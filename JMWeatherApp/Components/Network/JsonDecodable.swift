//
//  JsonDecodable.swift
//  JMWeatherApp
//
//  Created by Jakub Matuła on 05/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JsonDecodable {
    associatedtype A
    static func parse(json: JSON) -> A?
}

extension JsonDecodable {
    static func arrayParse(json: JSON) -> [A]? {
        return json.flatMap { (_, json) in
            return parse(json: json)
        }
    }
}
