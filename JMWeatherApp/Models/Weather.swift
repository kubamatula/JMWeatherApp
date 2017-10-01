//
//  Weather.swift
//  WeatherApp
//
//  Created by Jakub Matuła on 1/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation

///Basic struct holding weather data throughout the app
struct Weather {
    var temprature: Double
    var pressure: Double
    var weatherIcon: Int
    var weatherText: String
    var dateTime: Int
    var city: String
}

extension Weather: CustomStringConvertible {
    var description: String {
        return "temp: \(temprature), pressure: \(pressure), weatherIcon: \(weatherIcon), weatherText: \(weatherText), dateTime: \(dateTime)"
    }
}
