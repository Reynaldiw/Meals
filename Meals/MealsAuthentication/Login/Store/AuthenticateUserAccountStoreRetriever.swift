//
//  AuthenticateUserAccountStoreRetriever.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import Foundation

public protocol AuthenticateUserAccountStoreRetriever {
    func retrieve() throws -> String?
}
