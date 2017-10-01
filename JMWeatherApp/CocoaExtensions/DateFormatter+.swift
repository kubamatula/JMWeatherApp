//
//  DateFormatter+.swift
//  JMWeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation

extension DateFormatter {
    static var shortDateFormatter: DateFormatter {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            return dateFormatter
        }
    }
}
