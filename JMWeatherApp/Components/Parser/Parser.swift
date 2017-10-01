//
//  Parser.swift
//  JMWeatherApp
//
//  Created by Jakub Matuła on 01/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation

protocol Mappable {
    static func mapToModel(_ object: Any) -> Result<Self, WError>
}

func parse<T: Mappable>(data: Data, completion: (Result<[T], WError>) -> Void) {
    
    let decodedData: Result<Any, WError> = decodeData(data)
    
    switch decodedData {
        
    case .success(let result):
        
        guard let array = result as? [Any] else { completion(.failure(.parser)); return }
        
        let result: Result<[T], WError> = arrayToModels(array)
        completion(result)
        
    case .failure:
        completion(.failure(.parser))
    }
}

private func arrayToModels<T: Mappable>(_ objects: [Any]) -> Result<[T], WError> {
    
    var convertAndCleanArray: [T] = []
    
    for object in objects {
        
        guard case .success(let model) = T.mapToModel(object) else { continue }
        convertAndCleanArray.append(model)
    }
    
    return .success(convertAndCleanArray)
}

private func decodeData(_ data: Data) -> Result<Any, WError> {
    
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return .success(json)
    }
    catch {
        return .failure(.parser)
    }
}
