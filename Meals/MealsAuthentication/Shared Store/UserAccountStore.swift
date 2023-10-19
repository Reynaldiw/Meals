//
//  UserAccountStore.swift
//  Meals
//
//  Created by Reynaldi on 19/10/23.
//

import Foundation

public protocol UserAccountStore {
    func retrieve() throws -> [StoredUserAccount]
    func insert(_ userAccount: StoredUserAccount) throws
}
