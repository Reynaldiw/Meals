//
//  KeychainAuthenticateUserAccountStoreTests.swift
//  MealsTests
//
//  Created by Reynaldi on 20/10/23.
//

import XCTest
import Meals

final class KeychainStore {
    
    enum Error: Swift.Error {
        case failedToSave
        case failedToDelete
    }
    
    private let storeKey: String
    
    init(storeKey: String) {
        self.storeKey = storeKey
    }
}

extension KeychainStore: AuthenticateUserAccountStore {
    func save(_ value: String) throws {
        let data = Data(value.utf8)
        
        do {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: storeKey,
                kSecValueData: data
            ] as [CFString : Any]
            
            SecItemDelete(query as CFDictionary)
            
            guard SecItemAdd(query as CFDictionary, nil) == noErr else { throw Error.failedToSave }
            return
            
        } catch {
            throw error
        }
    }
}

extension KeychainStore {
    public func retrieve() throws -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: storeKey,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
                
        guard let data = result as? Data else { return nil }
        
        let value = String(decoding: data, as: UTF8.self)
        return value
    }
}

extension KeychainStore {
    func delete() throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: storeKey
        ] as [CFString : Any] as CFDictionary
        
        guard SecItemDelete(query) == noErr else { throw Error.failedToDelete }
    }
}

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