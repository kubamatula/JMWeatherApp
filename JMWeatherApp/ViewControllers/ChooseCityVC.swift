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
        didSet { tableView.dataSource = self; tableView.delegate = self }
    }
    
    var city: String {
        return cityTextField.text ?? ""
    }
    
    lazy var storedLocations: [Location] = locationPersistanceManager.loadLocations() ?? []
    
    private let locationPersistanceManager: LocationPersistanceManager = DiskCityPersistanceManager.sharedInstance
    private var fetchedWeather: Weather?
    
    @IBOutlet private weak var cityTextField: UITextField! {
        didSet {
            cityTextField.delegate = self
        }
    }
    
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
        guard !city.isEmpty else { print("Uzupelnij miasto"); return }
        weatherService.fetchWeather(forCity: city)
    }

    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "toWeather":
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
        checkWeather(city: city)
        return true
    }
}

//MARK:- WeatherServiceDelegate
extension ChooseCityVC: WeatherServiceDelegate {
    func finishedFetching(weather: Weather) {
        fetchedWeather = weather
        print("Weather: \(weather)")
        performSegue(withIdentifier: "toWeather", sender: self)
    }
    
    func finishedFetching(location: Location) {
        storedLocations.append(location)
        locationPersistanceManager.saveLocations(storedLocations)
        tableView.reloadData()
    }
    
}

//MARK:- TableViewDataSource
extension ChooseCityVC: UITableViewDataSource {
    
    private var cityCellIdentifier: String {
        return "CityTableViewCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cityCellIdentifier, for: indexPath)
        let city = storedLocations[indexPath.row].name
        cell.textLabel?.text = city
        return cell
    }
}

//MARK:- TableViewDelegate
extension ChooseCityVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = storedLocations[indexPath.row]
        weatherService.fetchWeather(forLocation: location)
    }
}
