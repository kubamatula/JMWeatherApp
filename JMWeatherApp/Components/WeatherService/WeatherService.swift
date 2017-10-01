//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation

protocol WeatherService {
    func fetchWeather(forCity: String)
    func fetch12HourForecast(forCity: String)
    weak var delegate: WeatherServiceDelegate? { get set }
}

protocol WeatherServiceDelegate: AnyObject {
    func finishedFetching(weather: Weather)
    func finishedFetching(forecast: [Weather])
    func failedFetching(with error: WError)
}

extension WeatherServiceDelegate {
    func finishedFetching(weather: Weather){}
    func finishedFetching(forecast: [Weather]){}
    func failedFetching(with error: WError){}
}
