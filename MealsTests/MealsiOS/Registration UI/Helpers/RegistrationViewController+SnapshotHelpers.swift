//
//  RegistrationViewController+SnapshotHelpers.swift
//  MealsTests
//
//  Created by Reynaldi on 19/10/23.
//

import Foundation
import Meals

extension RegistrationViewController {
    func fillAllRequiredFields(_ isAllFilled: Bool) {
        fullnameField.text = "Test Fullname"
        
        if isAllFilled {
            usernameField.text = "Test Username"
            passwordField.text = "Test Password"
        }
        
        textFieldDidChangeSelection(fullnameField)
    }
    
    func showLoading() {
        isLoading = true
    }
    
    func showErrorMessage(_ message: String) {
        errorMessage = message
    }
}

