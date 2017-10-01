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
    func fontColor(forTemperature temprature: Double) -> UIColor {
        switch temprature {
        case ..<10:
            return AppColors.blue
        case 10...20:
            return AppColors.black
        case 20...:
            return AppColors.red
        default:
            return AppColors.black
        }
    }
}
