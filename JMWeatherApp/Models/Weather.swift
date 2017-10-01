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
    var pressure: Double
    var weatherIcon: Int
    var weatherText: String
    var dateTime: Int
    var location: Location
}

extension Weather: CustomStringConvertible {
    var description: String {
        return "temp: \(temprature), pressure: \(pressure), weatherIcon: \(weatherIcon), weatherText: \(weatherText), dateTime: \(dateTime)"
    }
}

extension Weather: Mappable {
    
    static func mapToModel(_ object: Any) -> Result<Weather, WError> {
        let json = JSON(object)
        guard let temprature = json["Temperature"]["Metric"]["Value"].double,
            let pressure = json["Pressure"]["Metric"]["Value"].double,
            let weatherIcon = json["WeatherIcon"].int,
            let weatherText = json["WeatherText"].string,
            let dateTime = json["EpochTime"].int
            else {
                return .failure(.parser)
        }
        return .success(Weather(temprature: temprature, pressure: pressure, weatherIcon: weatherIcon, weatherText: weatherText, dateTime: dateTime, location: Location()))
    }
}

extension Weather: Equatable {
    static func ==(lhs: Weather, rhs: Weather) -> Bool {
        return lhs.temprature == rhs.temprature && lhs.pressure == rhs.pressure && lhs.weatherIcon == rhs.weatherIcon && lhs.weatherText == rhs.weatherText && lhs.dateTime == rhs.dateTime && lhs.location == rhs.location
    }
}
