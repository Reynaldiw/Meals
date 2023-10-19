//
//  KeychainAuthenticateUserAccountStoreTests.swift
//  MealsTests
//
//  Created by Reynaldi on 20/10/23.
//

import XCTest
import Meals

final class KeychainAuthenticateUserAccountStoreTests: XCTestCase {
    
    func test_save_succeedCacheAGivenValueIntoStore() throws {
        let value = "Test"
        let sut = makeSUT()
        
        try sut.save(value)
        
        let cachedValue = try XCTUnwrap(sut.retrieve())
        XCTAssertEqual(value, cachedValue)
    }
    
    func test_save_succeedsCachedLastValue() throws {
        let anyValue1 = "any-value-1"
        let anyValue2 = "any-value-2"
        let sut = makeSUT()

        try sut.save(anyValue1)
        try sut.save(anyValue2)

        let cachedValue = try XCTUnwrap(sut.retrieve())
        XCTAssertEqual(anyValue2, cachedValue)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(storeKey: String = "keychain.account.store.test.key") -> KeychainStore {
        let sut = KeychainStore(storeKey: storeKey)
        
        addTeardownBlock {
            try? KeychainStore(storeKey: storeKey).delete()
        }
        
        return sut
    }
}
