//
//  MealsViewAdapter.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import UIKit
import Combine

final class MealsViewAdapter: ResourceView {
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<MealItemCellController>>
    
    private weak var controller: MealsViewController?
    private let imageLoader: (URL) -> AnyPublisher<Data, Error>
    private let itemSelection: (MealItem) -> Void
    
    init(controller: MealsViewController?, imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>, itemSelection: @escaping (MealItem) -> Void) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.itemSelection = itemSelection
    }
    
    func display(_ viewModel: [MealItem]) {
        controller?.display(
            viewModel.map { model in
                let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
                    imageLoader(model.imageURL)
                })
                
                let view = MealItemCellController(
                    window: (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window,
                    viewModel: MealItemViewModel(name: model.name, category: model.category),
                    delegate: adapter,
                    selection: { [itemSelection] in
                        itemSelection(model)
                    })
                
                adapter.presenter = LoadResourcePresenter(
                    resourceView: WeakRefVirtualProxy(object: view),
                    loadingView: WeakRefVirtualProxy(object: view),
                    errorView: WeakRefVirtualProxy(object: view),
                    mapper: UIImage.tryMake)
                
                let controller = CellController(id: model, dataSource: view)
                return controller
            }
        )
    }
}

extension UIImage {
    struct InvalidImageData: Swift.Error {}
    
    static func tryMake(data: Data) throws -> UIImage {
        guard let image = UIImage.init(data: data) else {
            throw InvalidImageData()
        }
        
        return image
    }
}
