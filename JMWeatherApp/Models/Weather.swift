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
    var city: String
}

extension Weather: CustomStringConvertible {
    var description: String {
        return "temp: \(temprature), pressure: \(pressure), weatherIcon: \(weatherIcon), weatherText: \(weatherText), dateTime: \(dateTime)"
    }
}

extension Weather {
    init?(from data: Data){
        let json = JSON(data: data)
        guard let temprature = json[0]["Temperature"]["Metric"]["Value"].double,
            let pressure = json[0]["Pressure"]["Metric"]["Value"].double,
            let weatherIcon = json[0]["WeatherIcon"].int,
            let weatherText = json[0]["WeatherText"].string,
            let dateTime = json[0]["EpochTime"].int
            else {
                return nil
        }
        self.init(temprature: temprature, pressure: pressure, weatherIcon: weatherIcon, weatherText: weatherText, dateTime: dateTime, city: "")
    }
}
