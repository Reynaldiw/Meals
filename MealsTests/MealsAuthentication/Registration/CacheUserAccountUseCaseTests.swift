//
//  CacheUserAccountUseCaseTests.swift
//  MealsTests
//
//  Created by Reynaldi on 19/10/23.
//

import XCTest

struct StoredUserAccount {}

protocol UserAccountStore {
    func retrieve() throws -> [StoredUserAccount]
    func insert(_ userAccount: StoredUserAccount) throws
}

struct RegistrationUserAccount {
    private let fullname: String
    private let username: String
    private let password: String
    
    init(fullname: String, username: String, password: String) {
        self.fullname = fullname
        self.username = username
        self.password = password
    }
}

final class RegistrationUserAccountService {
    
    private let store: UserAccountStore
    
    init(store: UserAccountStore) {
        self.store = store
    }
    
    func register(_ userAccount: RegistrationUserAccount) {
        _ = try? store.retrieve()
    }
}

final class CacheUserAccountUseCaseTests: XCTestCase {
    
    func test_init_doesNotRetrieveCachedUserAcccountUponCreation() {
        let store = UserAccountStoreSpy()
        let sut = RegistrationUserAccountService(store: store)
        
        XCTAssertEqual(store.messages, [])
    }
    
    func test_register_doesNotRequestInsertionOnRetrievalError() {
        let userAccount = RegistrationUserAccount(
            fullname: "any-fullname",
            username: "any-username",
            password: "any-password")
        let store = UserAccountStoreSpy()
        let sut = RegistrationUserAccountService(store: store)
        
        sut.register(userAccount)
        
        XCTAssertEqual(store.messages, [.retrieveCacheUserAccount])
    }
    
    //MARK: - Helpers
    
    private class UserAccountStoreSpy: UserAccountStore {
        
        enum Message: Equatable {
            case retrieveCacheUserAccount
        }
        
        private(set) var messages: [Message] = []
        
        private var retrievalResult: Result<[StoredUserAccount], Error>?
        
        func retrieve() throws -> [StoredUserAccount] {
            messages.append(.retrieveCacheUserAccount)
            return try retrievalResult?.get() ?? []
        }
        
        func insert(_ userAccount: StoredUserAccount) throws {}
    }
}
