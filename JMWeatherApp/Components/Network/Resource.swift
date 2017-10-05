//
//  Resource.swift
//  JMWeatherApp
//
//  Created by Jakub Matuła on 04/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Resource<A>{
    let url: URL
    let parse: (Data) -> A?
}

extension Resource {
    init(url: URL, parseJSON: @escaping (JSON) -> A?) {
        let parse: (Data) -> A? = { data in
            let json = JSON(data)
            return parseJSON(json)
        }
        self.init(url: url, parse: parse)
    }
}

