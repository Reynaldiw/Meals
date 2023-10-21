//
//  MealItemDetailUIComposer.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import UIKit
import Combine

final class MealItemDetailUIComposer {
    private init() {}
    
    private typealias MealDetailPresentationAdapter = LoadResourcePresentationAdapter<MealItem, MealDetailResourceViewAdapter>
    
    static func detailComposedWith(
        detailLoader: @escaping () -> AnyPublisher<MealItem, Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>
    ) -> MealDetailViewController {
        let adapter = MealDetailPresentationAdapter(loader: detailLoader)
        
        let detailController = makeDetailViewController(title: "Detail")
        detailController.onLoadDetail = adapter.loadResource
        
        adapter.presenter = LoadResourcePresenter(
            resourceView: MealDetailResourceViewAdapter(
                controller: detailController,
                imageLoader: imageLoader),
            loadingView: WeakRefVirtualProxy(object: detailController),
            errorView: WeakRefVirtualProxy(object: detailController)
        )
                
        return detailController
    }
    
    private static func makeDetailViewController(title: String) -> MealDetailViewController {
        let bundle = Bundle(for: MealDetailViewController.self)
        let storyboard = UIStoryboard(name: "MealDetail", bundle: bundle)
        let detailController = storyboard.instantiateInitialViewController() as! MealDetailViewController
        detailController.title = title
        
        return detailController
    }
}
