//
//  MealsEndpoint.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import Foundation

public enum MealsEndpoint {
    case get(mealDetail: MealItem? = nil)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(meal):
            let suffixEndpoint = meal == nil ? "search.php" : "lookup.php"
            let query = meal.map { URLQueryItem(name: "i", value: $0.id) } ?? URLQueryItem(name: "f", value: "a")
            
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/json/v1/1/\(suffixEndpoint)"
            components.queryItems = [query]
            
            return components.url!
        }
    }
}
