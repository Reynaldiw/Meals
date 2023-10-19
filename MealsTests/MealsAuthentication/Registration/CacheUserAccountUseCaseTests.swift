//
//  CacheUserAccountUseCaseTests.swift
//  MealsTests
//
//  Created by Reynaldi on 19/10/23.
//

import XCTest

final class RegistrationUserAccountService {
    
    init(store: Any) {}
}

final class CacheUserAccountUseCaseTests: XCTestCase {
    
    func test_init_doesNotRetrieveCachedUserAcccountUponCreation() {
        let store = UserAccountStoreSpy()
        let sut = RegistrationUserAccountService(store: store)
        
        XCTAssertEqual(store.messages, [])
    }
    
    //MARK: - Helpers
    
    private class UserAccountStoreSpy {
        
        private(set) var messages: [String] = []
    }
}
