//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation

protocol WeatherService: AnyObject {
    
    func fetchWeather(forCity: String)
    func fetch12HourForecast(forCity: String)
    
    func fetchWeather(forLocation: Location)
    func fetch12HourForecast(forLocation: Location)
    
    weak var delegate: WeatherServiceDelegate? { get set }
}

extension WeatherService {
    func fetchWeather(forLocation: Location) {
        fatalError(#function + " not implemented!")
    }
    func fetch12HourForecast(forLocation: Location) {
        fatalError(#function + " not implemented!")
    }
}

protocol WeatherServiceDelegate: AnyObject {
    func finishedFetching(weather: Weather)
    func finishedFetching(forecast: [Weather])
    func failedFetching(with error: WError)
    func finishedFetching(location: Location)
}

extension WeatherServiceDelegate {
    func finishedFetching(weather: Weather){}
    func finishedFetching(forecast: [Weather]){}
    func failedFetching(with error: WError){}
    func finishedFetching(location: Location){}
}
