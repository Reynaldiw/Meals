//
//  AuthUserAccountStoreFactory.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import Foundation

final class AuthUserAccountStoreFactory {
    private init() {}
    
    static func create() -> KeychainStore {
        KeychainStore(storeKey: "authenticate-user-account-store")
    }
}
