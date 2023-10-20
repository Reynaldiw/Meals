//
//  MealItemsMapperTests.swift
//  MealsTests
//
//  Created by Reynaldi on 21/10/23.
//

import XCTest
import Meals

final class MealItemsMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeMealValues([])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try MealItemsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try MealItemsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJson = makeMealValues([])
        
        let result = try MealItemsMapper.map(emptyListJson, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversItemsOnNonEmptyValues() throws {
        let meal1 = makeMeal(
            id: "any-id",
            imageURL: URL(string: "https://any-url.com")!,
            name: "any-name",
            category: "any-category")
        
        let meal2 = makeMeal(
            id: "another-id",
            imageURL: URL(string: "https://another-url.com")!,
            name: "another-name",
            category: "another-category")
        
        do {
            let receivedMeals = try MealItemsMapper.map(makeMealValues([meal1.value, meal2.value]), from: HTTPURLResponse(statusCode: 200))
            XCTAssertEqual(receivedMeals, [meal1.model, meal2.model])
        } catch {
            XCTFail("Expected to succeed with result, but got \(error) instead")
        }
    }
    
    //MARK: - Helpers
    
    private func makeMeal(
        id: String,
        imageURL: URL,
        name: String,
        category: String
    ) -> (model: MealItem, value: [String: Any]) {
        let model = MealItem(id: id, imageURL: imageURL, name: name, category: category)
        let value: [String: Any] = [
            "idMeal": id,
            "strMeal": name,
            "strCategory": category,
            "strMealThumb": imageURL.absoluteString
        ]
        
        return (model, value)
    }
    
    private func makeMealValues(_ items: [[String: Any]]) -> Data {
        let meals = [
            "meals": items
        ]
        return try! JSONSerialization.data(withJSONObject: meals)
    }
}
