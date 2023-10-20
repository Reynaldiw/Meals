//
//  AuthCoordinator.swift
//  Meals
//
//  Created by Reynaldi on 20/10/23.
//

import Combine
import CoreData
import Foundation

final class AuthCoordinator {
    
    private var loginController: LoginViewController?
    private var registrationController: RegistrationViewController?
    
    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
        label: "com.reynaldi.authentication.infra.queue",
        qos: .userInitiated,
        attributes: .concurrent
    ).eraseToAnyScheduler()
    
    private lazy var userAccountStore: UserAccountStore = {
        do {
            return try CoreDataUserAccountStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appending(component: "user-account-store.sqlite"))
        } catch {
            assertionFailure("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            return NullStore()
        }
    }()
    
    private lazy var authenticateUserAccountStore: AuthenticateUserAccountStore = {
        KeychainStore(storeKey: "authenticate-user-account-store")
    }()
    
    private lazy var registrationService: RegistrationUserAccountService = {
        RegistrationUserAccountService(store: userAccountStore)
    }()
    
    func start(
        onSucceedLogin: @escaping () -> Void
    ) -> LoginViewController {
        loginController = LoginUIComposer.loginComposedWith(
            loginAuthenticate: authenticateLogin(account:),
            onSucceedAuthenticate: onSucceedLogin,
            onRegister: routeToRegistrationPage
        )
        
        return loginController!
    }
    
    //MARK: - Login Composer Helpers
    
    private func authenticateLogin(account: LoginAuthenticateUserAccount) -> AnyPublisher<Void, Error> {
        return userAccountStore
            .retrievePublisher()
            .tryCompactMap { [weak self] cacheUserAccounts in
                try self?.validate(cacheUserAccounts, with: account)
            }
            .tryMap(AuthenticateUserAccountMapper.map)
            .caching(to: authenticateUserAccountStore)
            .map { _ in Void() } // Succeed
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func validate(_ cacheUserAccounts: [StoredUserAccount], with authenticateUserAccount: LoginAuthenticateUserAccount) throws -> AuthenticateUserAccount {
        let matchingAccountUsername = cacheUserAccounts.filter { $0.username.lowercased() == authenticateUserAccount.username.lowercased() }
        
        guard !matchingAccountUsername.isEmpty else { throw AuthError.nonMatchingUsername }
        
        guard let matchedAccount = matchingAccountUsername.filter({ $0.password == authenticateUserAccount.password }).first
        else { throw AuthError.nonMatchingPassword  }
        
        return AuthenticateUserAccount(id: matchedAccount.id, fullname: matchedAccount.fullname, username: matchedAccount.username, createdAt: matchedAccount.createdAt)
    }
    
    //MARK: - Registration Composer Helpers
    
    private func routeToRegistrationPage() {
        registrationController = RegistrationUIComposer.registerComposedWith(
            registerAuthenticate: register(account:),
            onSucceedRegistration: handleSucceedRegistration
        )
        
        loginController?.show(registrationController!, sender: self)
    }
    
    private func register(account: RegistrationAuthenticationAccount) -> AnyPublisher<Void, Error> {
        return registrationService
            .registerPublisher(
                RegistrationUserAccount(fullname: account.fullname, username: account.username, password: account.password))
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func handleSucceedRegistration() {
        registrationController?.navigationController?.popViewController(animated: true)
    }
}
