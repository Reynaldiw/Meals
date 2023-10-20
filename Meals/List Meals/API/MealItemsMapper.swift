//
//  MealItemsMapper.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import Foundation

public final class MealItemsMapper {
    private struct Root: Decodable {
        private enum CodingKeys: String, CodingKey {
            case meals
        }
        
        let meals: [StoredMealItem]
    }
    
    private struct StoredMealItem: Decodable {
        
        private enum CodingKeys: String, CodingKey {
            case idMeal, strCategory, strMeal, strMealThumb
        }
        
        let idMeal: String
        let strCategory: String
        let strMeal: String
        let strMealThumb: URL
        
        var item: MealItem {
            MealItem(id: idMeal, imageURL: strMealThumb, name: strMeal, category: strCategory)
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
        
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [MealItem] {
        guard response.isOK, let storedItems = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return storedItems.meals.map { $0.item }
    }
}
