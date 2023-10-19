//
//  CacheUserAccountUseCaseTests.swift
//  MealsTests
//
//  Created by Reynaldi on 19/10/23.
//

import XCTest

struct StoredUserAccount {
    let id: UUID
    let fullname: String
    let username: String
    let password: String
    let createdAt: Date
}

protocol UserAccountStore {
    func retrieve() throws -> [StoredUserAccount]
    func insert(_ userAccount: StoredUserAccount) throws
}

struct RegistrationUserAccount {
    let fullname: String
    let username: String
    let password: String
    
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
        let userAccount = uniqueUser().registration
        let store = UserAccountStoreSpy()
        let sut = RegistrationUserAccountService(store: store)
        
        sut.register(userAccount)
        
        XCTAssertEqual(store.messages, [.retrieveCacheUserAccount])
    }
    
    func test_register_doesNotRequestInsertionOnNonValidUserAccount() {
        let userAccount = uniqueUser()
        let store = UserAccountStoreSpy()
        let sut = RegistrationUserAccountService(store: store)
        
        store.completeRetrieval(with: [userAccount.stored])
        
        sut.register(userAccount.registration)
        
        XCTAssertEqual(store.messages, [.retrieveCacheUserAccount])
    }
    
    //MARK: - Helpers
    
    private func uniqueUser(id: UUID = UUID(), createdAt date: Date = Date()) -> (registration: RegistrationUserAccount, stored: StoredUserAccount) {
        let registrationUser = anyRegistrationUser()
        let storedUser = StoredUserAccount(id: id, fullname: registrationUser.fullname, username: registrationUser.username, password: registrationUser.password, createdAt: date)
        return (registrationUser, storedUser)
    }
    
    private func anyRegistrationUser() -> RegistrationUserAccount {
        RegistrationUserAccount(fullname: "any-fullname", username: "any-username", password: "any-password")
    }
    
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
        
        func completeRetrieval(with userAccounts: [StoredUserAccount]) {
            retrievalResult = .success(userAccounts)
        }
        
        func insert(_ userAccount: StoredUserAccount) throws {}
    }
}
