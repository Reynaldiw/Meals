//
//  MealsEndpoint.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import Foundation

public enum MealsEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/json/v1/1/search.php"
            components.queryItems = [
                URLQueryItem(name: "f", value: "a")
            ]
            
            return components.url!
        }
    }
}
