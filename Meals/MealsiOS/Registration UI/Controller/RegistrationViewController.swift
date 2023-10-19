//
//  RegistrationViewController.swift
//  Meals
//
//  Created by Reynaldi on 19/10/23.
//

import UIKit

public final class RegistrationViewController: UIViewController {
    
    @IBOutlet private(set) public var fullnameField: UITextField!
    @IBOutlet private(set) public var usernameField: UITextField!
    @IBOutlet private(set) public var passwordField: UITextField!
    @IBOutlet private(set) public var registerButton: UIButton!
    @IBOutlet private(set) public var errorMessageLabel: UILabel!
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
            registerButton.setTitle(newValue ? "" : "Register", for: .normal)
            newValue ? spinner.startAnimating() : spinner.stopAnimating()
        }
    }
    
    public var errorMessage: String? = nil {
        didSet {
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
    }
    
    private func updateLoginButtonUIState(isEnable: Bool) {
        registerButton.isEnabled = isEnable
        registerButton.layer.opacity = isEnable ? 1.0 : 0.5
    }
    
    private func extractRegistrationFieldsValue() -> (fullname: String?, username: String?, password: String?) {
        return (fullnameField.text, usernameField.text, passwordField.text)
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        let (fullname, username, password) = extractRegistrationFieldsValue()
        updateLoginButtonUIState(isEnable: fullname?.isEmpty == false && username?.isEmpty == false && password?.isEmpty == false)
    }
}
