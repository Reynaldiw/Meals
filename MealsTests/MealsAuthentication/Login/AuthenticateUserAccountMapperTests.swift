//
//  AuthenticateUserAccountMapperTests.swift
//  MealsTests
//
//  Created by Reynaldi on 19/10/23.
//

import XCTest
import Meals

final class AuthenticateUserAccountMapperTests: XCTestCase {

    func test_map_deliversEmptyModelOnInvalidInputValue() throws {
        let invalidValue = "invalid-value"
        
        XCTAssertNil(try AuthenticateUserAccountMapper.map(base64EncodedValue: invalidValue))
    }
    
    func test_map_deliversModelOnValidInputValue() {
        let expectedModel = AuthenticateUserAccount(id: UUID(), fullname: "any-fullname", username: "any-username", createdAt: Date())
        
        do {
            let base64EncodedValue = try AuthenticateUserAccountMapper.map(expectedModel)
            let receivedModel = try AuthenticateUserAccountMapper.map(base64EncodedValue: base64EncodedValue)
            
            XCTAssertEqual(expectedModel, receivedModel)
            
        } catch {
            XCTFail("Expected to succeed with a given model")
        }
    }
}
