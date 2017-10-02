//
//  SimpleWeatherViewModel.swift
//  JMWeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation

struct SimpleWeatherViewModel {
    private let weather: Weather
    private let tempratureColorProvider: TemperatureColorProvider
    private let dateFormatter: DateFormatter
    
    init(weather: Weather, tempratureColorProvider: TemperatureColorProvider, dateFormatter: DateFormatter) {
        self.weather = weather
        self.tempratureColorProvider = tempratureColorProvider
        self.dateFormatter = dateFormatter
    }
    
    var coloredTemperature: NSAttributedString {
        get {
            let fontColor = tempratureColorProvider.fontColor(forTemperature: weather.temprature)
            let range = (temperature as NSString).range(of: temperatureValue)
            
            let text = NSMutableAttributedString.init(string: temperature)
            text.addAttribute(.foregroundColor, value: fontColor, range: range)
            return text
        }
    }
    
    var temperature: String {
        return "temp: " + temperatureValue
    }
    
    private var temperatureValue: String {
        return String(describing: weather.temprature) + " °C"
    }
    
    var weatherDescirption: String {
        return weather.weatherText
    }
    
    var date: String {
        let date = Date(timeIntervalSince1970: TimeInterval(weather.dateTime))
        return dateFormatter.string(from: date)
    }
    
    var city: String {
        return weather.location.name
    }
    
}
