//
//  MealItem.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import Foundation

public struct MealItem: Equatable {
    public let id: String
    public let imageURL: URL
    public let name: String
    public let category: String
    
    public init(id: String, imageURL: URL, name: String, category: String) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.category = category
    }
}
