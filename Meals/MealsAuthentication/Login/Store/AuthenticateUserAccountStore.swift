//
//  AuthenticateUserAccountStore.swift
//  Meals
//
//  Created by Reynaldi on 20/10/23.
//

import Foundation

public protocol AuthenticateUserAccountStore {
    func save(_ value: String) throws
}
