//
//  SceneDelegate.swift
//  Meals
//
//  Created by Reynaldi on 19/10/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let authCoordinator = AuthCoordinator()
    private let mealsCoordinator = MealsCoordinator()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
                
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        makeInitialRootViewController()
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
    }
    
    private func makeInitialRootViewController() {
        window?.rootViewController = UINavigationController(
            rootViewController: mealsCoordinator.start()
        )
    }
}

