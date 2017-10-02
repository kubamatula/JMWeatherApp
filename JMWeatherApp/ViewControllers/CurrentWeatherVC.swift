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
    
    @IBOutlet weak var currentWeatherView: WeatherDetailsView!
    @IBOutlet weak var forecastTableView: UITableView! {
        didSet {
            forecastTableView.dataSource = self
            forecastTableView.delegate = self
        }
    }
    
    private lazy var weatherService: WeatherService = {
        let accuWeatherConnection = Connection(session: URLSession.shared)
        let accuWeatherURL = URL(string: Constants.AccuWeatherBaseURL)!
        return AccuWeatherService(connection: accuWeatherConnection, baseURL: accuWeatherURL, APIKey: Constants.AccuWeatherAPIKey)
    }()
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Weather"
        
        let weatherViewModel = SimpleWeatherViewModel(weather: currentWeather!,
                                                      tempratureColorProvider: BasicTemperatureColorProvider(),
                                                      dateFormatter: DateFormatter.shortDateFormatter)
        currentWeatherView.viewModel = weatherViewModel
        fetchWeatherIcon(forId: currentWeather?.weatherIcon) { [weak self] iconImage in
            DispatchQueue.main.async {
                self?.currentWeatherView.icon = iconImage
            }
        }
        
        weatherService.delegate = self
        weatherService.fetch12HourForecast(forCity: currentWeather!.location.name)
    }

    private func fetchWeatherIcon(forId id: Int?, completion: @escaping (UIImage?) -> Void) {
        guard let id = id else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            let iconURLString = "https://developer.accuweather.com/sites/default/files/\(String(format: "%02d", id))-s.png"
            guard let iconURL = URL(string: iconURLString) else { print("wrong icon url"); return }
            guard let imageData = try? Data(contentsOf: iconURL) else { print("couldnt fetch weather icon data"); return }
            let image = UIImage(data: imageData)
            completion(image)
        }
    }
}

//MARK:- UITableViewDataSource
extension CurrentWeatherVC: UITableViewDataSource {
    
    private var forecastCellId: String {
        return "HourlyForecastCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: forecastCellId, for: indexPath) as! HourlyForecastTableViewCell
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
        
        guard let cell = cell as? HourlyForecastTableViewCell,
            let weatherIcon = forecast?[indexPath.row].weatherIcon
        else { return }
        
        fetchWeatherIcon(forId: weatherIcon) { [weak cell] iconImage in
            DispatchQueue.main.async {
                cell?.icon = iconImage
            }
        }
    }
}

//MARK:- WeatherServiceDelegate
extension CurrentWeatherVC: WeatherServiceDelegate {
    func finishedFetching(forecast: [Weather]) {
        self.forecast = forecast
        forecastTableView.reloadData()
    }
    
    func failedFetching(with error: WError) {
        print("Failure \(error.localizedDescription)")
        alert(message: "Something went wrong. Make sure You are connected to the internet", title: "Error")
    }
}


