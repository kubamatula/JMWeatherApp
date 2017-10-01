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
