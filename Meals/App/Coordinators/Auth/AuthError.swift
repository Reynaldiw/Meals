//
//  AuthError.swift
//  Meals
//
//  Created by Reynaldi on 20/10/23.
//

import Foundation

enum AuthError: Swift.Error {
    case nonMatchingUsername
    case nonMatchingPassword
}
