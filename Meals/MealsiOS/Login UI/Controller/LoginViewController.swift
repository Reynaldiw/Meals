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
    @IBOutlet private(set) public var errorMessageLabel: UILabel!
    @IBOutlet private(set) public var signUpButton: UIButton!
    @IBOutlet private(set) public var loadingContainer: UIView!
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        loadingContainer.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: loadingContainer.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: loadingContainer.centerYAnchor)
        ])
        
        return spinner
    }()
        
    public var isLoading: Bool {
        get { spinner.isAnimating }
        set {
            loadingContainer.isHidden = !newValue
            loginButton.setTitle(newValue ? "" : "Login", for: .normal)
            newValue ? spinner.startAnimating() : spinner.stopAnimating()
        }
    }
    
    public var errorMessage: String? = nil {
        didSet {
            errorMessageLabel.isHidden = errorMessage == nil
            errorMessageLabel.text = errorMessage
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialUI()
    }
    
    private func configureInitialUI() {
        loadingContainer.isHidden = true
        updateLoginButtonUIState(isEnable: false)
        errorMessageLabel.isHidden = true
    }
    
    private func updateLoginButtonUIState(isEnable: Bool) {
        loginButton.isEnabled = isEnable
        loginButton.layer.opacity = isEnable ? 1.0 : 0.5
    }
    
    private func extractLoginFieldsValue() -> (username: String?, password: String?) {
        return (usernameField.text, passwordField.text)
    }
}

extension LoginViewController: UITextFieldDelegate {
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        let (username, password) = extractLoginFieldsValue()
        updateLoginButtonUIState(isEnable: username?.isEmpty == false && password?.isEmpty == false)
    }
}
