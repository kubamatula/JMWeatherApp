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
    
    var iconResource: Resource<UIImage> {
        return Resource(url: URL(string: "https://developer.accuweather.com/sites/default/files/\(String(format: "%02d", weatherIcon))-s.png")!, parse: { return UIImage(data: $0) })
    }
}

extension Weather {
    static func currentConditions(locationKey: String) -> Resource<[Weather]> {
        let parameters = ["details": "false"]
        return resource(locationKey: locationKey, url: AccuWeatherEndpoints.currentConditions.url(parameters: parameters))
    }
    
    static func forecast12Hours(locationKey: String) -> Resource<[Weather]> {
        let parameters = ["details": "false", "metric": "true"]
        return resource(locationKey: locationKey, url: AccuWeatherEndpoints.forecast12Hours.url(parameters: parameters))
    }
    
    private static func resource(locationKey: String, url: URL) -> Resource<[Weather]> {
        var url = url
        url.appendPathComponent(locationKey)
        return Resource(url: url, parseJSON: Weather.arrayParse(json:))
    }
}

extension Weather: JsonDecodable {
    static func parse(json: JSON) -> Weather? {
        guard let temprature = json["Temperature"]["Metric"]["Value"].double ?? json["Temperature"]["Value"].double,
            let weatherIcon = json["WeatherIcon"].int,
            let weatherText = json["WeatherText"].string ?? json["IconPhrase"].string,
            let dateTime = json["EpochTime"].int ?? json["EpochDateTime"].int
            else {
                return nil
        }
        return Weather(temprature: temprature, weatherIcon: weatherIcon, weatherText: weatherText, dateTime: dateTime, location: Location())
    }
}

extension Weather: Equatable {
    static func ==(lhs: Weather, rhs: Weather) -> Bool {
        return lhs.temprature == rhs.temprature && lhs.weatherIcon == rhs.weatherIcon && lhs.weatherText == rhs.weatherText && lhs.dateTime == rhs.dateTime && lhs.location == rhs.location
    }
}

extension Weather: CustomStringConvertible {
    var description: String {
        return "temp: \(temprature), weatherIcon: \(weatherIcon), weatherText: \(weatherText), dateTime: \(dateTime)|"
    }
}
