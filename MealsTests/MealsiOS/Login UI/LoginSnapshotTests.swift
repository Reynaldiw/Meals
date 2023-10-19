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
    
    //MARK: - Helpers
    
    private func makeSUT() -> LoginViewController {
        let bundle = Bundle(for: LoginViewController.self)
        let storyboard = UIStoryboard(name: "Login", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! LoginViewController
        controller.loadViewIfNeeded()
        
        return controller
    }
}
