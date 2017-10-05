//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation

protocol WeatherService: AnyObject {
    func fetchLocation(forCity city: String, completion: @escaping ([Location]?) -> Void)
    func fetchWeather(forLocation location: Location, completion: @escaping ([Weather]?) -> Void)
    func fetch12HourForecast(forLocation location: Location, completion: @escaping ([Weather]?) -> Void)
    
    var webService: WebSerivce { get }
}

