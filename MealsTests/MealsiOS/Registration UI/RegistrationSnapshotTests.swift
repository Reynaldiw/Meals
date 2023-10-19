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
    
    //MARK: - Helpers
    
    private func makeSUT() -> RegistrationViewController {
        let bundle = Bundle(for: RegistrationViewController.self)
        let storyboard = UIStoryboard(name: "Registration", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! RegistrationViewController
        controller.loadViewIfNeeded()
        
        return controller
    }
}
