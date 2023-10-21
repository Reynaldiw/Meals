//
//  MealDetailResourceViewAdapter.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import UIKit
import Combine

final class MealDetailResourceViewAdapter: ResourceView {
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<MealDetailViewController>>
    
    private weak var controller: MealDetailViewController?
    private let imageLoader: (URL) -> AnyPublisher<Data, Error>
    
    init(
        controller: MealDetailViewController,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>
    ) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: MealItem) {
        guard let controller = controller else { return }
        
        let imageAdapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
            imageLoader(viewModel.imageURL)
        })
        
        let view = MealDetailImageViewAdapter(controller: controller)
        imageAdapter.presenter = LoadResourcePresenter(
            resourceView: WeakRefVirtualProxy(object: controller),
            loadingView: view,
            errorView: view,
            mapper: UIImage.tryMake)
        
        imageAdapter.didRequestImage()
        controller.onCancelLoadImage = imageAdapter.didCancelRequestImage
        
        controller.display(MealItemDetailViewModel(
            name: viewModel.name,
            category: viewModel.category,
            area: viewModel.area,
            instruction: viewModel.instruction))
    }
}
