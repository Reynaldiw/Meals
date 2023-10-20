//
//  NullStore.swift
//  Meals
//
//  Created by Reynaldi on 20/10/23.
//

import Foundation

class NullStore: UserAccountStore {
    func retrieve() throws -> [StoredUserAccount] {
        return []
    }
    
    func insert(_ userAccount: StoredUserAccount) throws {}
}
