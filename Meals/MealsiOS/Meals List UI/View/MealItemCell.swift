//
//  MealItemCell.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import UIKit

public final class MealItemCell: UITableViewCell {
    
    @IBOutlet private(set) public var mealCategoryContainer: UIView!
    @IBOutlet private(set) public var mealCategoryLabel: UILabel!
    @IBOutlet private(set) public var mealImageContainer: UIView!
    @IBOutlet private(set) public var mealImageView: UIImageView!
    @IBOutlet private(set) public var mealNameLabel: UILabel!
    
    var onReuse: (() -> Void)?
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        onReuse?()
    }
}
