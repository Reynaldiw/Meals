//
//  MealsCoordinator.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import Foundation
import Combine

final class MealsCoordinator {
    
    private var mealsViewController: MealsViewController?
    
    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
        label: "com.reynaldi.meals.infra.queue",
        qos: .userInitiated,
        attributes: .concurrent
    ).eraseToAnyScheduler()
    
    private lazy var baseURL = URL(string: "https://www.themealdb.com/api")!
    
    private lazy var httpClient: HTTPClient = {
        AlamofireHTTPClient(urlSession: URLSession(configuration: .ephemeral))
    }()
    
    func start() -> MealsViewController {
        mealsViewController = MealsUIComposer.mealsComposedWith(
            mealsLoader: loadMeals,
            imageLoader: loadImage(from:),
            selection: { _ in })
            
        return mealsViewController!
    }
    
    private func loadMeals() -> AnyPublisher<[MealItem], Error> {
        httpClient
            .getPublisher(from: MealsEndpoint.get.url(baseURL: baseURL))
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
}