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
    var currentWeather: Weather?
    var weatherService: WeatherService!
    private var forecastDataSourceAndDelegate: (UITableViewDataSource & UITableViewDelegate)?
    
    @IBOutlet weak var currentWeatherView: WeatherDetailsView!
    @IBOutlet weak var forecastTableView: UITableView!
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentWeather = currentWeather else { return }
        forecastDataSourceAndDelegate = ForecastDataSourceAndDelegate(tableView: forecastTableView, weather: currentWeather, weatherService: weatherService)
        forecastTableView.dataSource = forecastDataSourceAndDelegate
        forecastTableView.delegate = forecastDataSourceAndDelegate
        navigationItem.title = "Weather"
        
        let weatherViewModel = SimpleWeatherViewModel(weather: currentWeather,
                                                      tempratureColorProvider: BasicTemperatureColorProvider(),
                                                      dateFormatter: DateFormatter.shortDateFormatter)
        currentWeatherView.viewModel = weatherViewModel
        weatherService.fetchWeatherIcon(weather: currentWeather) { [weak self] iconImage in
            DispatchQueue.main.async {
                self?.currentWeatherView.icon = iconImage
            }
        }
    }
}


