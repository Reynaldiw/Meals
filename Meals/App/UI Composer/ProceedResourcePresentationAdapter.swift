//
//  ProceedResourcePresentationAdapter.swift
//  Meals
//
//  Created by Reynaldi on 20/10/23.
//

import Foundation
import Combine

final class ProceedResourcePresentationAdapter<Resource> {
    
    private let sender: (Resource) -> AnyPublisher<Void, Error>
    private var cancellable: Cancellable?
    private var isLoading = false
    
    var presenter: ProceedResourcePresenter?
    
    init(sender: @escaping (Resource) -> AnyPublisher<Void, Error>) {
        self.sender = sender
    }
    
    func proceed(_ resource: Resource) {
        guard !isLoading else { return }
        
        presenter?.didStartLoading()
        isLoading = true
        
        cancellable = sender(resource)
            .dispatchOnMainQueue()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                    
                case let .failure(error):
                    self?.presenter?.didFinishLoading(with: error)
                }
                
                self?.isLoading = false
            } receiveValue: { [weak self] _ in
                self?.presenter?.didFinishLoading(with: nil)
            }
    }
}
