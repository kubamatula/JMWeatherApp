//
//  OpenWeatherService.swift
//  WeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation
import SwiftyJSON

class AccuWeatherService: WeatherService {
    //accuweather
    private let APIKey: String
    private let baseURL: URL
    private let connection: Connectable
    var delegate: WeatherServiceDelegate?

    init(connection: Connectable, baseURL: URL, APIKey: String) {
        self.connection = connection
        self.baseURL = baseURL
        self.APIKey = APIKey
    }
    
    func fetchLocationKey(forCity city: String, completion: @escaping (Result<[Location], WError>) -> Void) {
        let locationResource = self.locationResource(city: city)
        let resourceRequest = locationResource.toRequest(baseURL: baseURL)
        connection.makeRequest(with: resourceRequest) { result in
            switch result {
            case .success(let data):
                parse(data: data, completion: completion)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.failedFetching(with: error)
                }
            }
        }
    }
    
    func fetchWeather(forLocation location: Location) {
        let currentConditionsResource = self.currentConditionsResource(locationKey: location.locationKey)
        let currentConditionRequest = currentConditionsResource.toRequest(baseURL: self.baseURL)
        connection.makeRequest(with: currentConditionRequest) { weatherDataResult in
            switch weatherDataResult {
            case .success(let data):
                parse(data: data){ (result: Result<[Weather], WError>) in
                    switch result {
                    case .success(let weatherArray):
                        self.delegate?.finishedFetching(weather: weatherArray.first!)
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.delegate?.failedFetching(with: error)
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.failedFetching(with: error)
                }
            }
        }
    }
    
    func fetchWeather(forCity city: String) {
        fetchLocationKey(forCity: city) { result in
            switch result {
            case .success(let locations):
                guard let location = locations.first else { self.delegate?.failedFetching(with: .parser); return;}
                self.fetchWeather(forLocation: location)
            case.failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.failedFetching(with: error)
                }
            }
        }
    }
    
    func fetch12HourForecast(forCity city: String) {
        return
    }
    
    private func locationResource(city: String) -> Resource<Location> {
        let locationPath = "/locations/v1/cities/search"
        let parameters = ["apikey": APIKey, "q": city]
        let locationResource = Resource<Location>(path: locationPath, parameters: parameters, method: .GET)
        return locationResource
    }
    
    private func currentConditionsResource(locationKey: String) -> Resource<Weather> {
        let conditionsPath = "/currentconditions/v1/" + locationKey
        let parameters = ["apikey": APIKey, "details": "true"]
        let conditionsResource = Resource<Weather>(path: conditionsPath, parameters: parameters, method: .GET)
        return conditionsResource
    }
    
    private func forecast12HoursResource(locationKey: String) -> Resource<[Weather]> {
        let forecast12HourPath = "/forecasts/v1/hourly/12hour/" + locationKey
        let parameters = ["apikey": APIKey, "details": "true", "metric": "true"]
        let forecastResource = Resource<[Weather]>(path: forecast12HourPath, parameters: parameters, method: .GET)
        return forecastResource
    }
}
