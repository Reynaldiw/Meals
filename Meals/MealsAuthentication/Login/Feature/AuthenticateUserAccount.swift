//
//  AuthenticateUserAccount.swift
//  Meals
//
//  Created by Reynaldi on 19/10/23.
//

import Foundation

public struct AuthenticateUserAccount {
    public let id: UUID
    public let fullname: String
    public let username: String
    public let createdAt: String
    
    public init(id: UUID, fullname: String, username: String, createdAt: String) {
        self.id = id
        self.fullname = fullname
        self.username = username
        self.createdAt = createdAt
    }
}
