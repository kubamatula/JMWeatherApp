//
//  TemperatureColorProvider.swift
//  JMWeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation
import UIKit

protocol TemperatureColorProvider {
    func fontColor(forTemperature: Double) -> UIColor
}

struct BasicTemperatureColorProvider: TemperatureColorProvider {
    
    let lowColor: UIColor
    let mediumColor: UIColor
    let highColor: UIColor
    
    //Default values impede reusability, but refactoring this would take time I dont have
    init(lowColor: UIColor = AppColors.blue, mediumColor: UIColor = AppColors.black, highColor: UIColor = AppColors.red) {
        self.lowColor = lowColor
        self.mediumColor = mediumColor
        self.highColor = highColor
    }
    
    //Those built in magic numbers also impede reausability
    func fontColor(forTemperature temprature: Double) -> UIColor {
        switch temprature {
        case ..<10:
            return lowColor
        case 10...20:
            return mediumColor
        case 20...:
            return highColor
        default:
            return mediumColor
        }
    }
}
