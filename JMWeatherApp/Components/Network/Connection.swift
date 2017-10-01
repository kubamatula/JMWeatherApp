//
//  Connection.swift
//  WeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation

protocol Connectable: AnyObject {
    func makeRequest(with request: URLRequest, completion: @escaping (Result<Data,WError>) -> Void)
}

final class Connection {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}

extension Connection: Connectable {
    func makeRequest(with request: URLRequest, completion: @escaping (Result<Data, WError>) -> Void) {
        session.dataTask(with: request) { data, _, error in
            switch (data, error) {
            case(let data?, _): completion(.succes(data))
            case(_, let error?): completion(.failure(.network(error.localizedDescription)))
            default: break
            }
        }.resume()
    }
}
