//
//  Constants.swift
//  WeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let AccuWeatherAPIKey = "ul4CyQv40CEWIsW7KjcpVUMtBHGQDYTY"
    static let AccuWeatherBaseURL = "http://dataservice.accuweather.com"
}

struct AppColors {
    static let blue = UIColor.blue
    static let black = UIColor.black
    static let red = UIColor.red
}

enum Segues: String {
    case toWeather = "ToWeather"
    
    var identifier: String {
        return self.rawValue
    }
}

enum Cells: String {
    case city = "CityTableViewCell"
    case forecast = "HourlyForecastCell"
    
    var identifier: String {
        return self.rawValue
    }
}
