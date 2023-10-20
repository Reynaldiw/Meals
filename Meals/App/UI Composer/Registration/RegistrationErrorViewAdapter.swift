//
//  RegistrationErrorViewAdapter.swift
//  Meals
//
//  Created by Reynaldi on 20/10/23.
//

import Foundation

final class RegistrationErrorViewAdapter: ProceedResourceErrorView {
    
    public weak var controller: RegistrationViewController?
    
    init(controller: RegistrationViewController?) {
        self.controller = controller
    }
    
    private static var errorMessageUsernameTaken: String {
        "Username already taken! Please try another one."
    }
    
    func display(_ viewModel: ProceedResourceErrorViewModel) {
        guard let error = viewModel.error else { return }
        
        if let registrationError = error as? RegistrationUserAccountService.Error, registrationError == .usernameAlreadyTaken  {
            controller?.errorMessage = Self.errorMessageUsernameTaken
        } else {
            controller?.errorMessage = viewModel.message ?? ProceedResourcePresenter.sendResourceError
        }
    }
}
