//
//  MealsCoordinator.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import Foundation
import Combine

final class MealsCoordinator {
    
    private weak var mealsViewController: MealsViewController?
    
    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
        label: "com.reynaldi.meals.infra.queue",
        qos: .userInitiated,
        attributes: .concurrent
    ).eraseToAnyScheduler()
    
    private lazy var baseURL = URL(string: "https://www.themealdb.com/api")!
    
    private lazy var httpClient: HTTPClient = {
        AlamofireHTTPClient(urlSession: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var authenticateUserAccountStore: AuthenticateUserAccountStoreRemover = {
        KeychainStore(storeKey: "authenticate-user-account-store")
    }()
    
    func start(
        onSucceedLogout: @escaping () -> Void
    ) -> MealsViewController {
        mealsViewController = MealsUIComposer.mealsComposedWith(
            mealsLoader: loadMeals,
            logout: { [logout] in
                logout(onSucceedLogout)
            },
            imageLoader: loadImage(from:),
            selection: showDetail(of:))
            
        return mealsViewController!
    }
    
    private func loadMeals() -> AnyPublisher<[MealItem], Error> {
        httpClient
            .getPublisher(from: MealsEndpoint.get().url(baseURL: baseURL))
            .tryMap(MealItemsMapper.map)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func loadImage(from url: URL) -> AnyPublisher<Data, Error> {
        httpClient
            .getPublisher(from: url)
            .tryMap(ImageDataMapper.map)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    //MARK: - Meal Detail
    
    private func showDetail(of meal: MealItem) {
        let detailController = MealItemDetailUIComposer.detailComposedWith(
            detailLoader: { [loadDetail] in
                loadDetail(meal)
            },
            imageLoader: loadImage(from:))
        
        mealsViewController?.show(detailController, sender: self)
    }
    
    private func loadDetail(of meal: MealItem) -> AnyPublisher<MealItem, Error> {
        httpClient
            .getPublisher(from: MealsEndpoint.get(mealDetail: meal).url(baseURL: baseURL))
            .tryMap(MealItemsMapper.map)
            .compactMap { $0.first }
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    //MARK: - Logout
    
    private func logout(onSucceedLogout: () -> Void) {
        do {
            try authenticateUserAccountStore.delete()
            onSucceedLogout()
        } catch {
            assertionFailure("Error Deleting Authenticate User Account in Keychain Store, error: \(error)")
        }
    }
}
