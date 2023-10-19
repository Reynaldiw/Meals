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

final class KeychainAuthenticateUserAccountStoreTests: XCTestCase {
    
    func test_save_succeedCacheAGivenValueIntoStore() throws {
        let value = "Test"
        let sut = makeSUT()
        
        try sut.save(value)
        
        let cachedValue = try XCTUnwrap(sut.retrieve())
        XCTAssertEqual(value, cachedValue)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(storeKey: String = "keychain.account.store.test.key") -> KeychainStore {
        let sut = KeychainStore(storeKey: storeKey)
        return sut
    }
}
