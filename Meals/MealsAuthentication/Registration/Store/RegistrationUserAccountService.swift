//
//  RegistrationUserAccountService.swift
//  Meals
//
//  Created by Reynaldi on 19/10/23.
//

import Foundation

public final class RegistrationUserAccountService {
    
    public enum Error: Swift.Error {
        case usernameAlreadyTaken
    }
    
    private let store: UserAccountStore
    private let userAccountID: () -> UUID
    private let userAccountCreatedAt: () -> Date
    
    public init(store: UserAccountStore, userAccountID: @escaping () -> UUID = UUID.init, userAccountCreatedAt: @escaping () -> Date = Date.init) {
        self.store = store
        self.userAccountID = userAccountID
        self.userAccountCreatedAt = userAccountCreatedAt
    }
    
    public func register(_ userAccount: RegistrationUserAccount) throws {
        do {
            let cachedUserAccounts = try store.retrieve()
            let isValid = cachedUserAccounts.filter { $0.username.lowercased() == userAccount.username.lowercased() }.isEmpty == true
            
            guard isValid else { throw Error.usernameAlreadyTaken }
            
            try store.insert(StoredUserAccount(
                id: userAccountID(),
                fullname: userAccount.fullname,
                username: userAccount.username,
                password: userAccount.password,
                createdAt: userAccountCreatedAt()))
            
        } catch {
            throw error
        }
    }
}
