//
//  Weather.swift
//  WeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation
import SwiftyJSON

///Basic struct holding weather data throughout the app
struct Weather {
    var temprature: Double
    var weatherIcon: Int
    var weatherText: String
    var dateTime: Int
    var location: Location
}

extension Weather: CustomStringConvertible {
    var description: String {
        return "temp: \(temprature), weatherIcon: \(weatherIcon), weatherText: \(weatherText), dateTime: \(dateTime)"
    }
}

extension Weather: Mappable {
    
    // this optional chaingin json mapping looks super bad,
    // but I found out that accuweather api is designed this way too late
    // to make it more elegant
    static func mapToModel(_ object: Any) -> Result<Weather, WError> {
        let json = JSON(object)
        guard let temprature = json["Temperature"]["Metric"]["Value"].double ?? json["Temperature"]["Value"].double,
            let weatherIcon = json["WeatherIcon"].int,
            let weatherText = json["WeatherText"].string ?? json["IconPhrase"].string,
            let dateTime = json["EpochTime"].int ?? json["EpochDateTime"].int
            else {
                return .failure(.parser)
        }
        return .success(Weather(temprature: temprature, weatherIcon: weatherIcon, weatherText: weatherText, dateTime: dateTime, location: Location()))
    }
}

extension Weather: Equatable {
    static func ==(lhs: Weather, rhs: Weather) -> Bool {
        return lhs.temprature == rhs.temprature && lhs.weatherIcon == rhs.weatherIcon && lhs.weatherText == rhs.weatherText && lhs.dateTime == rhs.dateTime && lhs.location == rhs.location
    }
}
