//
//  MealItemCellController.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import UIKit

public protocol MealImageCellControllerDelegate {
    func didRequestImage()
    func didCancelRequestImage()
}

public final class MealItemCellController: NSObject {
    private let window: UIWindow?
    private let viewModel: MealItemViewModel
    private let delegate: MealImageCellControllerDelegate
    private let selection: () -> Void
    private var cell: MealItemCell?
    
    public init(window: UIWindow?, viewModel: MealItemViewModel, delegate: MealImageCellControllerDelegate, selection: @escaping () -> Void) {
        self.window = window
        self.viewModel = viewModel
        self.delegate = delegate
        self.selection = selection
    }
    
    public func configureImagePinchZoom() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinch(sender:)))
        cell?.mealImageView.addGestureRecognizer(pinch)
        pinch.delegate = cell
    }
    
    // the view that will be overlayed, giving a back transparent look
    private var overlayView: UIView!
    
    // a property representing the maximum alpha value of the background
    private let maxOverlayAlpha: CGFloat = 0.8
    // a property representing the minimum alpha value of the background
    private let minOverlayAlpha: CGFloat = 0.4
    
    // the initial center of the pinch
    private var initialCenter: CGPoint?
    // the view to be added to the Window
    private var windowImageView: UIImageView?
    // the origin of the source imageview (in the Window coordinate space)
    private var startingRect = CGRect.zero
    
    @objc
    private func pinch(sender: UIPinchGestureRecognizer) {
        guard let cell = self.cell, let currentWindow = window else { return }
        
        if sender.state == .began {
            // the current scale is the aspect ratio
            let currentScale = cell.mealImageView.frame.size.width / cell.mealImageView.bounds.size.width
            // the new scale of the current `UIPinchGestureRecognizer`
            let newScale = currentScale * sender.scale
            
            // if we are really zooming
            if newScale > 1 {
                // setup the overlay to be the same size as the window
                overlayView = UIView.init(
                    frame: CGRect(
                        x: 0,
                        y: 0,
                        width: (currentWindow.frame.size.width),
                        height: (currentWindow.frame.size.height)
                    )
                )
                
                // set the view of the overlay as black
                overlayView.backgroundColor = UIColor.black
                
                // set the minimum alpha for the overlay
                overlayView.alpha = CGFloat(minOverlayAlpha)
                
                // add the subview to the overlay
                currentWindow.addSubview(overlayView)
                
                // set the center of the pinch, so we can calculate the later transformation
                initialCenter = sender.location(in: currentWindow)
                
                // set the window Image view to be a new UIImageView instance
                windowImageView = UIImageView.init(image: cell.mealImageView.image)
                
                // set the contentMode to be the same as the original ImageView
                windowImageView!.contentMode = .scaleAspectFill
                
                // Do not let it flow over the image bounds
                windowImageView!.clipsToBounds = true
                
                // since the to view is nil, this converts to the base window coordinates.
                // so where is the origin of the imageview, in the main window
                let point = cell.mealImageView.convert(
                    cell.mealImageView.frame.origin,
                    to: nil
                )
                
                // the location of the imageview, with the origin in the Window's coordinate space
                startingRect = CGRect(
                    x: point.x,
                    y: point.y,
                    width: cell.mealImageView.frame.size.width,
                    height: cell.mealImageView.frame.size.height
                )
                
                // set the frame for the image to be added to the window
                windowImageView?.frame = startingRect
                
                // add the image to the Window, so it will be in front of the navigation controller
                currentWindow.addSubview(windowImageView!)
                
                // hide the original image
                cell.mealImageView.isHidden = true
            }
        } else if sender.state == .changed {
            // if we don't have a current window, do nothing. Ensure the initialCenter has been set
            guard let currentWindow = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window,
                  let initialCenter = initialCenter,
                  let windowImageWidth = windowImageView?.frame.size.width
            else { return }
            
            // Calculate new image scale.
            let currentScale = windowImageWidth / startingRect.size.width
            
            // the new scale of the current `UIPinchGestureRecognizer`
            let newScale = currentScale * sender.scale
            
            // Calculate new overlay alpha, so there is a nice animated transition effect
            overlayView.alpha = minOverlayAlpha + (newScale - 1) < maxOverlayAlpha ? minOverlayAlpha + (newScale - 1) : maxOverlayAlpha
            
            // calculate the center of the pinch
            let pinchCenter = CGPoint(
                x: sender.location(in: currentWindow).x - (currentWindow.bounds.midX),
                y: sender.location(in: currentWindow).y - (currentWindow.bounds.midY)
            )
            
            // calculate the difference between the inital centerX and new centerX
            let centerXDif = initialCenter.x - sender.location(in: currentWindow).x
            // calculate the difference between the intial centerY and the new centerY
            let centerYDif = initialCenter.y - sender.location(in: currentWindow).y
            
            // calculate the zoomscale
            let zoomScale = (newScale * windowImageWidth >= cell.mealImageView.frame.width) ? newScale : currentScale
            
            // transform scaled by the zoom scale
            let transform = currentWindow.transform
                .translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: zoomScale, y: zoomScale)
                .translatedBy(x: -centerXDif, y: -centerYDif)
            
            // apply the transformation
            windowImageView?.transform = transform
            
            // Reset the scale
            sender.scale = 1
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            guard let windowImageView = windowImageView else { return }
            
            // animate the change when the pinch has finished
            UIView.animate(withDuration: 0.3, animations: {
                // make the transformation go back to the original
                windowImageView.transform = CGAffineTransform.identity
            }, completion: { [weak self] _ in
                
                // remove the imageview from the superview
                windowImageView.removeFromSuperview()
                
                // remove the overlayview
                self?.overlayView.removeFromSuperview()
                
                // make the original view reappear
                cell.mealImageView.isHidden = false
            })
        }
    }
}

extension MealItemCellController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.mealNameLabel.text = viewModel.name
        cell?.mealImageView.image = nil
        cell?.mealImageContainer.isShimmering = true
        configureImagePinchZoom()
        
        cell?.onReuse = { [weak self] in
            self?.releaseCellForReuse()
        }
        delegate.didRequestImage()
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection()
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

extension MealItemCellController: ResourceView, ResourceLoadingView, ResourceErrorView {
    public typealias ResourceViewModel = UIImage
    
    public func display(_ viewModel: UIImage) {
        cell?.mealImageView.setImageAnimated(viewModel)
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell?.mealImageContainer.isShimmering = viewModel.isLoading
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        cell?.mealImageView.image = UIImage()
    }
}
