//
//  HourlyForecastTableViewCell.swift
//  JMWeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import UIKit

class HourlyForecastTableViewCell: UITableViewCell {

    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var temperature: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    var viewModel: SimpleWeatherViewModel? {
        didSet {
            guard let viewModel = viewModel else { return}
            temperature?.attributedText = viewModel.coloredTemperature
            date?.text = viewModel.date
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
