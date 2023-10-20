//
//  CacheUserAccountUseCaseTests.swift
//  MealsTests
//
//  Created by Reynaldi on 19/10/23.
//

import XCTest
import Meals

final class CacheUserAccountUseCaseTests: XCTestCase {
    
    func test_init_doesNotRetrieveCachedUserAcccountUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.messages, [])
    }
    
    func test_register_doesNotRequestInsertionOnRetrievalError() {
        let userAccount = uniqueUser().registration
        let retrievalError = NSError(domain: "any-error", code: 0)
        let (sut, store) = makeSUT()
        
        store.completeRetrieval(with: retrievalError)
        
        try? sut.register(userAccount)
        
        XCTAssertEqual(store.messages, [.retrieveCacheUserAccount])
    }
    
    func test_register_doesNotRequestInsertionOnNonValidUserAccount() {
        let userAccount = uniqueUser()
        let (sut, store) = makeSUT()

        store.completeRetrieval(with: [userAccount.stored])
        
        try? sut.register(userAccount.registration)
        
        XCTAssertEqual(store.messages, [.retrieveCacheUserAccount])
    }
    
    func test_register_requestInsertionOnSucceesRetrievalAndValidUserAccount() {
        let userAccountID = UUID()
        let userAccountDateCreated = Date()
        let userAccount = uniqueUser(id: userAccountID, createdAt: userAccountDateCreated)
        let (sut, store) = makeSUT(userAccountID: { userAccountID }, userAccountCreatedAt: { userAccountDateCreated })
        
        store.completeRetrieval(with: [])
        
        try? sut.register(userAccount.registration)
        
        XCTAssertEqual(store.messages, [.retrieveCacheUserAccount, .insert(userAccount.stored)])
    }
    
    func test_register_deliversErrorOnRetrievalError() {
        let retrievalError = anyNSError()
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: retrievalError, when: {
            store.completeRetrieval(with: retrievalError)
        })
    }
    
    func test_register_deliversErrorOnNonValidUserAccount() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWithError: RegistrationUserAccountService.Error.usernameAlreadyTaken as NSError, when: {
            store.completeRetrieval(with: [uniqueUser().stored])
        })
    }
    
    func test_register_deliversErrorOnInsertionError() {
        let insertionError = anyNSError()
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: insertionError, when: {
            let cacheUserAccount = StoredUserAccount(
                id: UUID(),
                fullname: "another fullname",
                username: "another username",
                password: "another password",
                createdAt: Date())
            store.completeRetrieval(with: [cacheUserAccount])
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_register_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: .none, when: {
            store.completeRetrieval(with: [])
            store.completeInsertionSuccessfully()
        })
    }
    
    //MARK: - Helpers
    
    private func makeSUT(
        userAccountID: @escaping () -> UUID = UUID.init,
        userAccountCreatedAt: @escaping () -> Date = Date.init,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RegistrationUserAccountService, store: UserAccountStoreSpy) {
        let store = UserAccountStoreSpy()
        let sut = RegistrationUserAccountService(store: store, userAccountID: userAccountID, userAccountCreatedAt: userAccountCreatedAt)
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        return (sut, store)
    }
    
    private func expect(_ sut: RegistrationUserAccountService, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        action()
        
        do {
            try sut.register(uniqueUser().registration)
        } catch {
            XCTAssertEqual(error as NSError, expectedError, file: file, line: line)
        }
    }
    
    func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    private class UserAccountStoreSpy: UserAccountStore {
        
        enum Message: Equatable {
            case retrieveCacheUserAccount
            case insert(StoredUserAccount)
        }
        
        private(set) var messages: [Message] = []
        
        private var retrievalResult: Result<[StoredUserAccount], Error>?
        private var insertionResult: Result<Void, Error>?
        
        func retrieve() throws -> [StoredUserAccount] {
            messages.append(.retrieveCacheUserAccount)
            return try retrievalResult?.get() ?? []
        }
        
        func completeRetrieval(with error: Error) {
            retrievalResult = .failure(error)
        }
        
        func completeRetrieval(with userAccounts: [StoredUserAccount]) {
            retrievalResult = .success(userAccounts)
        }
        
        func insert(_ userAccount: StoredUserAccount) throws {
            messages.append(.insert(userAccount))
            try insertionResult?.get()
        }
        
        func completeInsertion(with error: Error) {
            insertionResult = .failure(error)
        }
        
        func completeInsertionSuccessfully() {
            insertionResult = .success(())
        }
    }
}
