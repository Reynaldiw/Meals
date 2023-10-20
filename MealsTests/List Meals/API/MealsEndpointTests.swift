//
//  MealsEndpointTests.swift
//  MealsTests
//
//  Created by Reynaldi on 21/10/23.
//

import XCTest
import Meals

final class MealsEndpointTests: XCTestCase {
    
    func test_meals_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!

        let received = MealsEndpoint.get.url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "http", "Scheme")
        XCTAssertEqual(received.host, "base-url.com", "Host")
        XCTAssertEqual(received.path, "/json/v1/1/search.php", "Path")
        XCTAssertEqual(received.query, "f=a", "Query")
    }
}
