//
//  CurrentWeatherVC.swift
//  WeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import UIKit

class CurrentWeatherVC: UIViewController {
    
    // MARK:- Properties
    var forecast: [Weather]?
    var currentWeather: Weather?
    var weatherService: WeatherService!
    
    @IBOutlet weak var currentWeatherView: WeatherDetailsView!
    @IBOutlet weak var forecastTableView: UITableView!
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastTableView.dataSource = self
        forecastTableView.delegate = self
        
        navigationItem.title = "Weather"
        
        let weatherViewModel = SimpleWeatherViewModel(weather: currentWeather!,
                                                      tempratureColorProvider: BasicTemperatureColorProvider(),
                                                      dateFormatter: DateFormatter.shortDateFormatter)
        currentWeatherView.viewModel = weatherViewModel
        fetchWeatherIcon(weather: currentWeather) { [weak self] iconImage in
            DispatchQueue.main.async {
                self?.currentWeatherView.icon = iconImage
            }
        }
        
        weatherService.fetch12HourForecast(forLocation: currentWeather!.location) { [weak self] forecast in
            self?.forecast = forecast
            DispatchQueue.main.async {
                self?.forecastTableView.reloadData()
            }
        }
    }

    private func fetchWeatherIcon(weather: Weather?, completion: @escaping (UIImage?) -> Void) {
        guard let weather = weather else { return }
        weatherService.webService.load(resource: weather.iconResource, completion: completion)
    }
}

//MARK:- UITableViewDataSource
extension CurrentWeatherVC: UITableViewDataSource {
    
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
extension CurrentWeatherVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? HourlyForecastTableViewCell
            else { return }
        
        fetchWeatherIcon(weather: forecast?[indexPath.row]) { [weak cell] iconImage in
            DispatchQueue.main.async {
                cell?.icon = iconImage
            }
        }
    }
}


