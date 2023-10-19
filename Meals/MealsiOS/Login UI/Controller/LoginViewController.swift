//
//  LoginViewController.swift
//  Meals
//
//  Created by Reynaldi on 19/10/23.
//

import UIKit

public final class LoginViewController: UIViewController {
    
    @IBOutlet private(set) public var usernameField: UITextField!
    @IBOutlet private(set) public var passwordField: UITextField!
    @IBOutlet private(set) public var loginButton: UIButton!
    @IBOutlet private(set) public var signUpButton: UIButton!
    @IBOutlet private(set) public var loadingContainer: UIView!

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialUI()
    }
    
    private func configureInitialUI() {
        loadingContainer.isHidden = true
        updateLoginButtonUIState(isEnable: false)
    }
    
    private func updateLoginButtonUIState(isEnable: Bool) {
        loginButton.isEnabled = isEnable
        loginButton.layer.opacity = isEnable ? 1.0 : 0.5
    }
}

extension LoginViewController: UITextFieldDelegate {
    public func textFieldDidChangeSelection(_ textField: UITextField) {}
}
