//
//  ChooseCityVC.swift
//  WeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import UIKit

class ChooseCityVC: UIViewController {
    // MARK:- Properties
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBOutlet private weak var cityTextField: UITextField! {
        didSet {
            cityTextField.delegate = self
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var city: String {
        return cityTextField.text ?? ""
    }
    
    lazy var storedLocations: [Location] = locationPersistanceManager.loadLocations() ?? []
    
    private let locationPersistanceManager: LocationPersistanceManager = DiskCityPersistanceManager.sharedInstance
    private var fetchedWeather: Weather?
    
    private lazy var weatherService: WeatherService = {
        let accuWeatherConnection = Connection(session: URLSession.shared)
        let accuWeatherURL = URL(string: Constants.AccuWeatherBaseURL)!
        return AccuWeatherService(connection: accuWeatherConnection, baseURL: accuWeatherURL, APIKey: Constants.AccuWeatherAPIKey)
    }()
    
    // MARK:- VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherService.delegate = self
        navigationItem.title = "Choose city"
    }
    
    // MARK:- User Interaction
    @IBAction func checkWeather(_ sender: UIButton) {
        checkWeather(city: city)
    }
    
    private func checkWeather(city: String){
        guard !city.isEmpty else { alert(message: "Make sure city name is typed in"); return }
        spinner.startAnimating()
        weatherService.fetchWeather(forCity: city)
    }

    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case Segues.toWeather.identifier:
            let currentWeatherVC = segue.destination as! CurrentWeatherVC
            currentWeatherVC.currentWeather = fetchedWeather
        default:
            break
        }
    }

}

//MARK:- TextFieldDelegate
extension ChooseCityVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == cityTextField {
            checkWeather(city: city)
            return true
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cityTextField {
            return string.isLatinOnly
        }
        return true
    }
}

//MARK:- WeatherServiceDelegate
extension ChooseCityVC: WeatherServiceDelegate {
    func finishedFetching(weather: [Weather]) {
        spinner.stopAnimating()
        fetchedWeather = weather.first
        if fetchedWeather != nil {
            performSegue(withIdentifier: Segues.toWeather.identifier, sender: self)
        }
    }
    
    func failedFetching(with error: WError) {
        print("Failure \(error.localizedDescription)")
        alert(message: "Something went wrong. Make sure You are connected to the internet, and have entered a correct city name", title: "Error")
        spinner.stopAnimating()
    }
    
    func finishedFetching(location: Location) {
        if !storedLocations.contains(location) {
            storedLocations.append(location)
        }
        locationPersistanceManager.saveLocations(storedLocations)
        tableView.reloadData()
    }
    
}

//MARK:- TableViewDataSource
extension ChooseCityVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.city.identifier, for: indexPath)
        let city = storedLocations[indexPath.row].name
        cell.textLabel?.text = city
        return cell
    }
}

//MARK:- TableViewDelegate
extension ChooseCityVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = storedLocations[indexPath.row]
        spinner.startAnimating()
        weatherService.fetchWeather(forLocation: location)
    }
}
