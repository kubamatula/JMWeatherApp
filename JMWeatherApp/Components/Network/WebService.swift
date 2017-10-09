//
//  NetworkRequest.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 16/09/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation
import UIKit

class WebSerivce {
    func load<A>(resource: Resource<A>, completion: @escaping (A?) -> Void) {
        urlSession.dataTask(with: resource.url) { data, _, _ in
            let objects = data.flatMap(resource.parse)
            completion(objects)
        }.resume()
    }
    
    
    private init(){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 10
        self.urlSession = URLSession(configuration: configuration)
    }
    private let urlSession: URLSession
    static let shared = WebSerivce()
}
