//
//  RegistrationSnapshotTests.swift
//  MealsTests
//
//  Created by Reynaldi on 19/10/23.
//

import XCTest
import Meals

final class RegistrationSnapshotTests: XCTestCase {

    func test_registrationInitialSetup() {
        let sut = makeSUT()
        
        assert(snapshot: sut.snapshot(configuration: .iPhone13(style: .light)), named: "REGISTRATION_INITIAL_SETUP_light")
    }
    
    func test_registrationWithNotAllOfRequiredFieldsIsFilled() {
        let sut = makeSUT()
        sut.fillAllRequiredFields(false)
        
        assert(snapshot: sut.snapshot(configuration: .iPhone13(style: .light)), named: "REGISTRATION_NOT_ALL_REQUIRED_FIELDS_FILLED_light")
    }
    
    func test_registrationWitlAllRequiredFieldsFilled() {
        let sut = makeSUT()
        sut.fillAllRequiredFields(true)
        
        assert(snapshot: sut.snapshot(configuration: .iPhone13(style: .light)), named: "REGISTRATION_REQUIRED_FIELDS_FILLED_light")
    }
    
    //MARK: - Helpers
    
    private func makeSUT() -> RegistrationViewController {
        let bundle = Bundle(for: RegistrationViewController.self)
        let storyboard = UIStoryboard(name: "Registration", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! RegistrationViewController
        controller.loadViewIfNeeded()
        
        return controller
    }
}

private extension RegistrationViewController {
    func fillAllRequiredFields(_ isAllFilled: Bool) {
        fullnameField.text = "Test Fullname"
        
        if isAllFilled {
            usernameField.text = "Test Username"
            passwordField.text = "Test Password"
        }
        
        textFieldDidChangeSelection(fullnameField)
    }
}
