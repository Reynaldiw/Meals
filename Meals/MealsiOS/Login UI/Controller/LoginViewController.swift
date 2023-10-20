//
//  LoginViewController.swift
//  Meals
//
//  Created by Reynaldi on 19/10/23.
//

import UIKit

public typealias LoginAuthenticateUserAccount = (username: String, password: String)

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
    
    public var authenticate: ((LoginAuthenticateUserAccount) -> Void)?
    public var onSucceedAuthenticate: (() -> Void)?
    public var onRegister: (() -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialUI()
    }
    
    private func configureInitialUI() {
        usernameField.delegate = self
        passwordField.delegate = self
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

extension LoginViewController: ProceedResourceSucceedView, ProceedResourceLoadingView, ProceedResourceErrorView {
    public func succeed() {
        
    }
    
    public func display(_ viewModel: ProceedResourceLoadingViewModel) {
        
    }
    
    public func display(_ viewModel: ProceedResourceErrorViewModel) {
        
    }
}

extension LoginViewController: UITextFieldDelegate {
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        let (username, password) = extractLoginFieldsValue()
        updateLoginButtonUIState(isEnable: username?.isEmpty == false && password?.isEmpty == false)
    }
}
