//
//  String+alpha.swift
//  JMWeatherApp
//
//  Created by Jakub Matuła on 02/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation

extension String {
    var isLatinOnly: Bool {
        return self.range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
}
