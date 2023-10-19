//
//  LoginViewController+SnapshotHelpers.swift
//  MealsTests
//
//  Created by Reynaldi on 19/10/23.
//

import Meals
import Foundation

extension LoginViewController {
    func fillFields(withUsername username: String?, andPassword password: String?) {
        usernameField.text = username
        passwordField.text = password
        textFieldDidChangeSelection(usernameField)
        textFieldDidChangeSelection(passwordField)
    }
    
    func showLoading() {
        isLoading = true
    }
    
    func showErrorMessage(_ message: String) {
        errorMessage = message
    }
}
