//
//  Result.swift
//  WeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

enum Result<T,E: Error> {
    case succes(T)
    case failure(E)
}
