//
//  TypicodeEndpoints.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 03/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation

enum AccuWeatherEndpoints: String {
    case currentConditions = "/currentconditions/v1/"
    case forecast12Hours = "/forecasts/v1/hourly/12hour/"
    case locations = "/locations/v1/cities/search"
    
    var apiKey: String { return Constants.AccuWeatherAPIKey }
    
    func url(parameters: [String: String] = [:]) -> URL {
        var parameters = parameters
        parameters["apikey"] = apiKey
        let url = URL(string: Constants.AccuWeatherBaseURL + rawValue)!
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        return urlComponents.url!
    }
}
