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

    public override func viewDidLoad() {
        super.viewDidLoad()
    }
}
