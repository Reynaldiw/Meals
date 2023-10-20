//
//  WeakRefVirtualProxy.swift
//  Meals
//
//  Created by Reynaldi on 20/10/23.
//

import Foundation

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: ProceedResourceErrorView where T: ProceedResourceErrorView {
    func display(_ viewModel: ProceedResourceErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: ProceedResourceLoadingView where T: ProceedResourceLoadingView {
    func display(_ viewModel: ProceedResourceLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: ProceedResourceSucceedView where T: ProceedResourceSucceedView {
    func succeed() {
        object?.succeed()
    }
}
