//
//  LoginUIComposer.swift
//  Meals
//
//  Created by Reynaldi on 20/10/23.
//

import UIKit
import Combine

public final class LoginUIComposer {
    private init() {}
    
    private typealias LoginPresentationAdapter = ProceedResourcePresentationAdapter<LoginAuthenticateUserAccount>
    
    public static func loginComposedWith(
        loginAuthenticate: @escaping (LoginAuthenticateUserAccount) -> AnyPublisher<Void, Error>,
        onSucceedAuthenticate: @escaping () -> Void = { },
        onRegister: @escaping () -> Void = { }
    ) -> LoginViewController {
        let presentationAdapter = LoginPresentationAdapter(sender: loginAuthenticate)
        
        let loginController = makeLoginViewController()
        loginController.authenticate = presentationAdapter.proceed(_:)
        loginController.onSucceedAuthenticate = onSucceedAuthenticate
        loginController.onRegister = onRegister
        
        presentationAdapter.presenter = ProceedResourcePresenter(
            succeedView: WeakRefVirtualProxy(object: loginController),
            loadingView: WeakRefVirtualProxy(object: loginController),
            errorView: WeakRefVirtualProxy(object: loginController))
        
        return loginController
    }
    
    private static func makeLoginViewController() -> LoginViewController {
        let bundle = Bundle(for: LoginViewController.self)
        let storyboard = UIStoryboard(name: "Login", bundle: bundle)
        let loginViewController = storyboard.instantiateInitialViewController() as! LoginViewController
        loginViewController.title = ""
        
        return loginViewController
    }
}
