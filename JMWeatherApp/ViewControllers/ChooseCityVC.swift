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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var cityTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var city: String {
        return cityTextField.text ?? ""
    }
    
    lazy var locations: [Location] = locationPersistanceManager.loadLocations() ?? []
    private let locationPersistanceManager: LocationPersistanceManager = DiskLocationPersistanceManager.sharedInstance
    private var fetchedWeather: Weather?
    
    private let weatherService: WeatherService = AccuWeatherService()
    
    // MARK:- VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        cityTextField.delegate = self
        navigationItem.title = "Choose city"
    }
    
    // MARK:- User Interaction
    @IBAction func checkWeather(_ sender: UIButton) {
        checkWeather(forLocation: Location(name: city))
    }
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case Segues.toWeather.identifier:
            let currentWeatherVC = segue.destination as! CurrentWeatherVC
            currentWeatherVC.currentWeather = fetchedWeather
            currentWeatherVC.weatherService = weatherService
        default:
            break
        }
    }
    
    //MARK:- Implementation details
    private func checkWeather(forLocation location: Location){
        guard !location.name.isEmpty else { alert(message: "Make sure city name is typed in"); return }
        spinner.startAnimating()
        weatherService.fetchWeather(forLocation:location){ [weak self] weather in
            self?.fetchedWeather = weather?.first
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                guard weather?.first != nil else { self?.alert(message: "Error fetching weather"); return }
                self?.storeLocation(location)
                self?.tableView.reloadData()
                self?.performSegue(withIdentifier: Segues.toWeather.identifier, sender: self)
            }
        }
    }
    
    private func storeLocation(_ location: Location){
        if !locations.contains(location) {
            locations.append(location)
            locationPersistanceManager.saveLocations(locations)
        }
    }
}

//MARK:- TextFieldDelegate
extension ChooseCityVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == cityTextField {
            checkWeather(forLocation: Location(name: city))
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

//MARK:- TableViewDataSource
extension ChooseCityVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.city.identifier, for: indexPath)
        let city = locations[indexPath.row].name
        cell.textLabel?.text = city
        return cell
    }
}

//MARK:- TableViewDelegate
extension ChooseCityVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        checkWeather(forLocation: location)
    }
}
