//
//  CoreDataUserAccountStoreTests.swift
//  MealsTests
//
//  Created by Reynaldi on 20/10/23.
//

import XCTest
import Meals

final class CoreDataUserAccountStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .success([]))
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveTwice: .success([]))
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let account = uniqueUser().stored
        
        insert(account, to: sut)
        
        expect(sut, toRetrieve: .success([account]))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let account = uniqueUser().stored
        
        insert(account, to: sut)
        
        expect(sut, toRetrieveTwice: .success([account]))
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        let insertionError = insert(uniqueUser().stored, to: sut)
        
        XCTAssertNil(insertionError, "Expected to insert cache successfully")
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        
        insert(uniqueUser().stored, to: sut)

        let insertionError = insert(uniqueUser().stored, to: sut)

        XCTAssertNil(insertionError, "Expected to override cache successfully")
    }
    
    func test_insert_doesNotOverridePreviouslyInsertedCacheValues() {
        let sut = makeSUT()
        
        let oldAccounts = uniqueUser().stored
        
        insert(oldAccounts, to: sut)
        
        let latestAccounts = uniqueUser().stored
        
        insert(latestAccounts, to: sut)
        
        expect(sut, toRetrieve: .success([oldAccounts, latestAccounts]))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> UserAccountStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataUserAccountStore(storeURL: storeURL)
        trackForMemoryLeaks(sut)
        return sut
    }
    
    func expect(
        _ sut: UserAccountStore,
        toRetrieveTwice expectedResult: Result<[StoredUserAccount], Error>,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(
        _ sut: UserAccountStore,
        toRetrieve expectedResult: Result<[StoredUserAccount], Error>,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let retrievedResult = Result { try sut.retrieve() }
        
        switch (expectedResult, retrievedResult) {
        case (.success([]), .success([])), (.failure, .failure):
            break
            
        case let (.success(expectedCache), .success(retrievedCache)):
            XCTAssertEqual(expectedCache, retrievedCache, file: file, line: line)
            
        default:
            XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
        }
    }
    
    @discardableResult
    func insert(_ cache: StoredUserAccount, to sut: UserAccountStore) -> Error? {
        do {
            try sut.insert(cache)
            return nil
        } catch {
            return error
        }
    }
}
