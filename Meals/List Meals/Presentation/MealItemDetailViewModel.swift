//
//  MealItemDetailViewModel.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import Foundation

public struct MealItemDetailViewModel {
    public let name: String
    public let category: String
    public let area: String
    public let instruction: String
    
    public init(name: String, category: String, area: String, instruction: String) {
        self.name = name
        self.category = category
        self.area = area
        self.instruction = instruction
    }
}
