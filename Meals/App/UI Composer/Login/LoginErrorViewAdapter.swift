//
//  LoginErrorViewAdapter.swift
//  Meals
//
//  Created by Reynaldi on 20/10/23.
//

import Foundation

final class LoginErrorViewAdapter: ProceedResourceErrorView {
    
    public weak var controller: LoginViewController?
    
    init(controller: LoginViewController?) {
        self.controller = controller
    }
    
    private static var errorMessageUsernameNotMatch: String {
        "Incorrect username"
    }
    
    private static var errorMessagePasswordNotMatch: String {
        "Incorrect username"
    }
    
    func display(_ viewModel: ProceedResourceErrorViewModel) {
        guard let error = viewModel.error else { return }
        guard let validationError = error as? AuthError else {
            return displayDefaultErrorMessage(viewModel)
        }
        
        if validationError == .nonMatchingUsername {
            controller?.errorMessage = Self.errorMessageUsernameNotMatch
        } else if validationError == .nonMatchingPassword {
            controller?.errorMessage = Self.errorMessagePasswordNotMatch
        } else {
            displayDefaultErrorMessage(viewModel)
        }
    }
    
    private func displayDefaultErrorMessage(_ viewModel: ProceedResourceErrorViewModel) {
        controller?.errorMessage = viewModel.message ?? ProceedResourcePresenter.sendResourceError
    }
}
