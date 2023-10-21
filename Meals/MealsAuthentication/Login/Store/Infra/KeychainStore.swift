//
//  KeychainStore.swift
//  Meals
//
//  Created by Reynaldi on 20/10/23.
//

import Foundation

public final class KeychainStore {
    
    public enum Error: Swift.Error {
        case failedToSave
        case failedToDelete
    }
    
    private let storeKey: String
    
    public init(storeKey: String) {
        self.storeKey = storeKey
    }
}

extension KeychainStore: AuthenticateUserAccountStoreSaver {
    public func save(_ value: String) throws {
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

extension KeychainStore: AuthenticateUserAccountStoreRetriever {
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
    public func delete() throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: storeKey
        ] as [CFString : Any] as CFDictionary
        
        guard SecItemDelete(query) == noErr else { throw Error.failedToDelete }
    }
}
