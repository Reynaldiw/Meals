//
//  AuthenticateUserAccountMapper.swift
//  Meals
//
//  Created by Reynaldi on 19/10/23.
//

import Foundation

public final class AuthenticateUserAccountMapper {
    
    private struct CodableAuthenticateUserAccount: Codable {
        public let id: UUID
        public let fullname: String
        public let username: String
        public let createdAt: Date
        
        public init(id: UUID, fullname: String, username: String, createdAt: Date) {
            self.id = id
            self.fullname = fullname
            self.username = username
            self.createdAt = createdAt
        }
        
        var model: AuthenticateUserAccount {
            AuthenticateUserAccount(id: id, fullname: fullname, username: username, createdAt: createdAt)
        }
    }
    
    private init() {}
    
    /// Mapping model `AuthenticateUserAccount` into `Base64-Encoded String`
    public static func map(_ model: AuthenticateUserAccount) throws -> String {
        let codableModel = CodableAuthenticateUserAccount(
            id: model.id,
            fullname: model.fullname,
            username: model.username,
            createdAt: model.createdAt)
        return try JSONEncoder().encode(codableModel).base64EncodedString()
    }
    
    /// Mapping model `Base64-Encoded String`  into `AuthenticateUserAccount`
    public static func map(base64EncodedValue value: String) throws -> AuthenticateUserAccount? {
        guard let data = Data(base64Encoded: value) else { return nil }
        return try JSONDecoder().decode(CodableAuthenticateUserAccount.self, from: data).model
    }
}
