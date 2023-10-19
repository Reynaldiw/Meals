//
//  StoredUserAccount.swift
//  Meals
//
//  Created by Reynaldi on 19/10/23.
//

import Foundation

public struct StoredUserAccount: Equatable {
    public let id: UUID
    public let fullname: String
    public let username: String
    public let password: String
    public let createdAt: Date
    
    public init(id: UUID, fullname: String, username: String, password: String, createdAt: Date) {
        self.id = id
        self.fullname = fullname
        self.username = username
        self.password = password
        self.createdAt = createdAt
    }
}
