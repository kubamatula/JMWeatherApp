//
//  ForecastDataSource.swift
//  JMWeatherApp
//
//  Created by Jakub Matuła on 05/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation
import UIKit

class ForecastDataSourceAndDelegate: NSObject {
    
    private var forecast: [Weather]?
    var weather: Weather
    private let weatherService: WeatherService!
    weak private var tableView: UITableView!
    
    init(tableView: UITableView, weather: Weather, weatherService: WeatherService) {
        self.tableView = tableView
        self.weather = weather
        self.weatherService = weatherService
        super.init()
        
        weatherService.fetch12HourForecast(forLocation: weather.location) { [weak self] forecast in
            self?.forecast = forecast
            guard forecast != nil else { print("error wetching weather"); return }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

//MARK:- UITableViewDataSource
extension ForecastDataSourceAndDelegate: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.forecast.identifier, for: indexPath) as! HourlyForecastTableViewCell
        let cellViewModel = SimpleWeatherViewModel(weather: forecast![indexPath.row],
                                                   tempratureColorProvider: BasicTemperatureColorProvider(),
                                                   dateFormatter: DateFormatter.shortDateFormatter)
        cell.viewModel = cellViewModel
        return cell
    }
}

//MARK:- UITableViewDelegate
extension ForecastDataSourceAndDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? HourlyForecastTableViewCell
            else { return }
        
        weatherService.fetchWeatherIcon(weather: forecast?[indexPath.row]) { [weak cell] iconImage in
            DispatchQueue.main.async {
                cell?.icon = iconImage
            }
        }
    }
}
