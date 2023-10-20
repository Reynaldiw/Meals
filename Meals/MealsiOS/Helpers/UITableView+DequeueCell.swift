//
//  UITableView+DequeueCell.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import UIKit

public extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
