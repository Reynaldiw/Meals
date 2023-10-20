//
//  MealItemCellController.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import UIKit

public struct MealItemViewModel {
    public let name: String
    public let category: String
}

public protocol MealImageCellControllerDelegate {
    func didRequestImage()
    func didCancelRequestImage()
}

public final class MealItemCellController: NSObject {
    private let viewModel: MealItemViewModel
    private let delegate: MealImageCellControllerDelegate
    private let imageSelection: () -> Void
    private let nextSelection: () -> Void
    private var cell: MealItemCell?
    
    public init(viewModel: MealItemViewModel, delegate: MealImageCellControllerDelegate, imageSelection: @escaping () -> Void, nextSelection: @escaping () -> Void) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.imageSelection = imageSelection
        self.nextSelection = nextSelection
    }
}

extension MealItemCellController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.mealNameLabel.text = viewModel.name
        cell?.mealImageView.image = nil
        cell?.mealImageContainer.isShimmering = true
        
        cell?.onReuse = { [weak self] in
            self?.releaseCellForReuse()
        }
        delegate.didRequestImage()
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nextSelection()
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.cell = cell as? MealItemCell
        delegate.didRequestImage()
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelLoad()
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        delegate.didRequestImage()
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        cancelLoad()
    }
    
    private func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelRequestImage()
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
