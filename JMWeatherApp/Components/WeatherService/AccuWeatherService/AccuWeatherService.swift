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
        connection.makeRequest(with: resourceRequest) { [weak self] result in
            switch result {
            case .success(let data):
                parse(data: data, completion: completion)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.delegate?.failedFetching(with: error)
                }
            }
        }
    }
    
    func fetchWeather(forLocation location: Location) {
        let currentConditionsResource = self.currentConditionsResource(locationKey: location.key!)
        let currentConditionRequest = currentConditionsResource.toRequest(baseURL: self.baseURL)
        connection.makeRequest(with: currentConditionRequest) { [weak self] weatherDataResult in
            switch weatherDataResult {
            case .success(let data):
                parse(data: data){ (result: Result<[Weather], WError>) in
                    switch result {
                    case .success(var weatherArray):
                        DispatchQueue.main.async {
                            weatherArray = weatherArray.map {
                                var weather = $0;
                                weather.location = location;
                                return weather
                            }
                            self?.delegate?.finishedFetching(weather: weatherArray.first!)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.delegate?.failedFetching(with: error)
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.delegate?.failedFetching(with: error)
                }
            }
        }
    }
    
    func fetchWeather(forCity city: String) {
        fetchLocationKey(forCity: city) { [weak self] result in
            switch result {
            case .success(let locations):
                guard let location = locations.first else { self?.delegate?.failedFetching(with: .parser); return;}
                DispatchQueue.main.async {
                    self?.delegate?.finishedFetching(location: location)
                }
                self?.fetchWeather(forLocation: location)
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.delegate?.failedFetching(with: error)
                }
            }
        }
    }
    
    func fetch12HourForecast(forCity city: String) {
        fetchLocationKey(forCity: city) { [weak self] result in
            switch result {
            case .success(let locations):
                guard let location = locations.first else { self?.delegate?.failedFetching(with: .parser); return;}
                self?.fetch12HourForecast(forLocation: location)
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.delegate?.failedFetching(with: error)
                }
            }
        }
    }
    
    func fetch12HourForecast(forLocation location: Location) {
        let forecastResource = self.forecast12HoursResource(locationKey: location.key!)
        let currentConditionRequest = forecastResource.toRequest(baseURL: self.baseURL)
        connection.makeRequest(with: currentConditionRequest) { [weak self] weatherDataResult in
            switch weatherDataResult {
            case .success(let data):
                parse(data: data){ (result: Result<[Weather], WError>) in
                    switch result {
                    case .success(var weatherArray):
                        DispatchQueue.main.async {
                            weatherArray = weatherArray.map {
                                var weather = $0;
                                weather.location = location;
                                return weather
                            }
                            self?.delegate?.finishedFetching(forecast: weatherArray)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.delegate?.failedFetching(with: error)
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.delegate?.failedFetching(with: error)
                }
            }
        }
    }
    
    private func locationResource(city: String) -> Resource {
        let locationPath = "/locations/v1/cities/search"
        let parameters = ["apikey": APIKey, "q": city]
        let locationResource = Resource(path: locationPath, parameters: parameters, method: .GET)
        return locationResource
    }
    
    private func currentConditionsResource(locationKey: String) -> Resource {
        let conditionsPath = "/currentconditions/v1/" + locationKey
        let parameters = ["apikey": APIKey, "details": "true"]
        let conditionsResource = Resource(path: conditionsPath, parameters: parameters, method: .GET)
        return conditionsResource
    }
    
    private func forecast12HoursResource(locationKey: String) -> Resource {
        let forecast12HourPath = "/forecasts/v1/hourly/12hour/" + locationKey
        let parameters = ["apikey": APIKey, "details": "true", "metric": "true"]
        let forecastResource = Resource(path: forecast12HourPath, parameters: parameters, method: .GET)
        return forecastResource
    }
}
