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
    }
}
