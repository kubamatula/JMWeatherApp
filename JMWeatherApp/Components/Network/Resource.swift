//
//  Resource.swift
//  WeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation

/// Object representing a resource on some endpoint, A is the type that can be instantiated once resource data is fetched
struct Resource<A> {
    let path: String
    let parameters: [String: String]
    let method: Method
}

extension Resource: CustomStringConvertible {
    var description: String {
        return "Path: \(path), parameters: \(parameters), method: \(method)"
    }
}

extension Resource {
    func toRequest(baseURL: URL) -> URLRequest {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.path = path
        components?.queryItems = parameters.map { URLQueryItem(name: $0, value: $1)}
        let finalURL = components?.url ?? baseURL
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        return request
    }
}

public enum Method: String {
    case GET
    case POST
}
