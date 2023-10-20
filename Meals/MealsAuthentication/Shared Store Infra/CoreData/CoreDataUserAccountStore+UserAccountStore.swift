//
//  CoreDataUserAccountStore+UserAccountStore.swift
//  Meals
//
//  Created by Reynaldi on 20/10/23.
//

import Foundation

extension CoreDataUserAccountStore: UserAccountStore {
    public func retrieve() throws -> [StoredUserAccount] {
        try performSync { context in
            Result {
                try ManagedCache.find(in: context).map {
                    $0.localUserAccounts
                } ?? []
            }
        }
    }
    
    public func insert(_ userAccount: StoredUserAccount) throws {
        var cacheUserAccounts = try retrieve()
        cacheUserAccounts.append(userAccount)
        
        try performSync { context in
            Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.userAccounts = ManagedUserAccount.accounts(from: cacheUserAccounts, in: context)
                
                try context.save()
            }
        }
    }
}
