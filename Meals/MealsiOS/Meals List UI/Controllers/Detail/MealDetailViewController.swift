//
//  MealDetailViewController.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import UIKit

public final class MealDetailViewController: UIViewController {
    
    @IBOutlet private(set) public var mealContentView: UIView!
    @IBOutlet private(set) public var mealNameLabel: UILabel!
    @IBOutlet private(set) public var mealCategoryLabel: UILabel!
    @IBOutlet private(set) public var mealAreaLabel: UILabel!
    @IBOutlet private(set) public var mealImageContainer: UIView!
    @IBOutlet private(set) public var mealImageView: UIImageView!
    @IBOutlet private(set) public var mealInstructionLabel: UILabel!
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        view.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return spinner
    }()
    
    public var isLoading: Bool {
        get { spinner.isAnimating }
        set {
            newValue ? spinner.startAnimating() : spinner.stopAnimating()
        }
    }
    
    public var onLoadDetail: (() -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialView()
        onLoadDetail?()
    }
    
    private func configureInitialView() {
        mealContentView.isHidden = true
    }
}
