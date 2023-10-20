//
//  ProceedResourceErrorViewModel.swift
//  Meals
//
//  Created by Reynaldi on 20/10/23.
//

import Foundation

public struct ProceedResourceErrorViewModel {
    public let error: Error?
    public let message: String?
    
    public static var noError: ProceedResourceErrorViewModel {
        ProceedResourceErrorViewModel(error: nil, message: nil)
    }
    
    public static func error(_ error: Error, message: String) -> ProceedResourceErrorViewModel {
        ProceedResourceErrorViewModel(error: error, message: message)
    }
}
