//
//  MealsUIComposer.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import Combine
import UIKit

public final class MealsUIComposer {
    private init() {}
    
    private typealias MealsPresentationAdapter = LoadResourcePresentationAdapter<[MealItem], MealsViewAdapter>
    
    public static func mealsComposedWith(
        mealsLoader: @escaping () -> AnyPublisher<[MealItem], Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>,
        selection: @escaping (MealItem) -> Void = { _ in }
    ) -> MealsViewController {
        let presentationAdapter = MealsPresentationAdapter(loader: mealsLoader)
        
        let mealsController = makeMealsViewController(title: "Meals")
        mealsController.onRefresh = presentationAdapter.loadResource
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: MealsViewAdapter(
                controller: mealsController,
                imageLoader: imageLoader,
                itemSelection: selection),
            loadingView: WeakRefVirtualProxy(object: mealsController),
            errorView: WeakRefVirtualProxy(object: mealsController))
        
        return mealsController
    }
    
    private static func makeMealsViewController(title: String) -> MealsViewController {
        let bundle = Bundle(for: MealsViewController.self)
        let storyboard = UIStoryboard(name: "Meals", bundle: bundle)
        let mealsController = storyboard.instantiateInitialViewController() as! MealsViewController
        mealsController.title = title
        
        return mealsController
    }
}
