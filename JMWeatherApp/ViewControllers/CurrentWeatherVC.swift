//
//  CurrentWeatherVC.swift
//  WeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import UIKit

class CurrentWeatherVC: UIViewController {
    
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
    
    var forecast: [Weather]?
    
    var currentWeather: Weather? {
        didSet {
            if let weather = currentWeather {
                currentWeatherView?.weather = weather
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentWeatherView.weather = currentWeather
        if let weatherIcon = currentWeather?.weatherIcon {
            fetchWeatherIcon(forId: weatherIcon) { [weak self] iconImage in
                DispatchQueue.main.async {
                    self?.currentWeatherView.icon = iconImage
                }
            }
        }
        weatherService.delegate = self
        weatherService.fetch12HourForecast(forCity: currentWeather!.location.locationName)
    }

    private func fetchWeatherIcon(forId id: Int, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let iconURLString = "https://developer.accuweather.com/sites/default/files/\(String(format: "%02d", id))-s.png"
            guard let iconURL = URL(string: iconURLString) else { print("wrong icon url"); return }
            guard let imageData = try? Data(contentsOf: iconURL) else { print("couldnt fetch weather icon data"); return }
            let image = UIImage(data: imageData)
            completion(image)
        }
    }
}

extension CurrentWeatherVC: UITableViewDataSource {
    
    private var forecastCellId: String {
        return "HourlyForecastCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: forecastCellId, for: indexPath) as! HourlyForecastTableViewCell
        cell.temprature = forecast?[indexPath.row].temprature
        return cell
    }
}

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

extension CurrentWeatherVC: WeatherServiceDelegate {
    func finishedFetching(forecast: [Weather]) {
        self.forecast = forecast
        forecastTableView.reloadData()
    }
    
    func failedFetching(with error: WError) {
        print("Failure \(error.localizedDescription)")
    }
}


