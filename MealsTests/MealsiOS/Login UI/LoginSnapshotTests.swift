//
//  LoginSnapshotTests.swift
//  MealsTests
//
//  Created by Reynaldi on 19/10/23.
//

import XCTest
import Meals

final class LoginSnapshotTests: XCTestCase {
    
    func test_loginInitialSetup() {
        let sut = makeSUT()
        
        assert(snapshot: sut.snapshot(configuration: .iPhone13(style: .light)), named: "LOGIN_INITIAL_SETUP_light")
    }
    
    func test_loginWithNotAllOfFieldsIsFilled() {
        let sut = makeSUT()
        sut.fillFields(withUsername: "Test username", andPassword: nil)
        
        assert(snapshot: sut.snapshot(configuration: .iPhone13(style: .light)), named: "LOGIN_NOT_ALL_FIELDS_FILLED_light")
    }
    
    func test_loginFieldsFilled() {
        let sut = makeSUT()
        sut.fillFields(withUsername: "Test username", andPassword: "test password")
        
        assert(snapshot: sut.snapshot(configuration: .iPhone13(style: .light)), named: "LOGIN_FIELDS_FILLED_light")
    }
    
    func test_withAllRequiredFieldsIsFilled_loginWithLoading() {
        let sut = makeSUT()
        sut.fillFields(withUsername: "Test username", andPassword: "test password")
        sut.showLoading()
        
        assert(snapshot: sut.snapshot(configuration: .iPhone13(style: .light)), named: "LOGIN_LOADING_light")
    }
    
    func test_loginWithErrorMessage() {
        let sut = makeSUT()
        sut.fillFields(withUsername: "Test username", andPassword: "test password")
        sut.showErrorMessage("This is multiline\n error message")
        
        assert(snapshot: sut.snapshot(configuration: .iPhone13(style: .light)), named: "LOGIN_ERROR_MESSAGE_light")
    }
    
    //MARK: - Helpers
    
    private func makeSUT() -> LoginViewController {
        let bundle = Bundle(for: LoginViewController.self)
        let storyboard = UIStoryboard(name: "Login", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! LoginViewController
        controller.loadViewIfNeeded()
        
        return controller
    }
}
