//
//  MealDetailImageViewAdapter.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import Foundation

final class MealDetailImageViewAdapter: ResourceLoadingView, ResourceErrorView {
    private weak var controller: MealDetailViewController?

    init(controller: MealDetailViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: ResourceLoadingViewModel) {
        controller?.displayImageView(viewModel.isLoading)
    }
    
    func display(_ viewModel: ResourceErrorViewModel) {
        guard viewModel.error != nil else { return }
    }
}
