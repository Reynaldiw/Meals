//
//  ProceedResourcePresenter.swift
//  Meals
//
//  Created by Reynaldi on 20/10/23.
//

import Foundation

public final class ProceedResourcePresenter {
    
    private let succeedView: ProceedResourceSucceedView
    private let loadingView: ProceedResourceLoadingView
    private let errorView: ProceedResourceErrorView
    
    public init(succeedView: ProceedResourceSucceedView, loadingView: ProceedResourceLoadingView, errorView: ProceedResourceErrorView) {
        self.succeedView = succeedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public static var sendResourceError: String {
        "Something went wrong"
    }
    
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(ProceedResourceLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with error: Error?) {
        if let error = error {
            errorView.display(.error(error, message: Self.sendResourceError))
        } else {
            succeedView.succeed()
        }
        loadingView.display(ProceedResourceLoadingViewModel(isLoading: false))
    }
}
