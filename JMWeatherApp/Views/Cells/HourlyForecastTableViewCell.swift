//
//  HourlyForecastTableViewCell.swift
//  JMWeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import UIKit

class HourlyForecastTableViewCell: UITableViewCell {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var tempratureLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    var temprature: Double? {
        get {
            return Double(tempratureLabel?.text ?? "0")
        }
        set {
            if let temp = newValue {
                tempratureLabel?.text = String(describing: temp)
            }
        }
    }
    
    var date: String? {
        get {
            return dateLabel?.text
        }
        set {
            dateLabel?.text = newValue
        }
    }
    
    var icon: UIImage? {
        get {
            return iconImageView?.image
        }
        set {
            iconImageView?.image = newValue
            if newValue != nil {
                spinner.stopAnimating()
            }
        }
    }
    
    override func prepareForReuse() {
        icon = nil
        spinner.startAnimating()
    }
}
