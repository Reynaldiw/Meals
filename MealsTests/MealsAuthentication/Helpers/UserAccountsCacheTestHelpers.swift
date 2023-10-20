//
//  UserAccountsCacheTestHelpers.swift
//  MealsTests
//
//  Created by Reynaldi on 20/10/23.
//

import Foundation
import Meals

func uniqueUser(id: UUID = UUID(), createdAt date: Date = Date()) -> (registration: RegistrationUserAccount, stored: StoredUserAccount) {
    let registrationUser = anyRegistrationUser()
    let storedUser = StoredUserAccount(id: id, fullname: registrationUser.fullname, username: registrationUser.username, password: registrationUser.password, createdAt: date)
    return (registrationUser, storedUser)
}

func anyRegistrationUser() -> RegistrationUserAccount {
    RegistrationUserAccount(fullname: "any-fullname", username: "any-username", password: "any-password")
}
