//
//  Config.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import Foundation

enum Config {
    private enum Keys: String {
        case baseURL = "BASE_URL"
        case authUserAccountStoreKey = "AUTH_USER_ACCOUNT_STORE_KEY"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist not found")
        }
        return dict
    }()
    
    static let baseURL: URL = {
        guard let baseURL = Config.infoDictionary[Keys.baseURL.rawValue] as? String else {
            fatalError("Base URL not set in plist")
        }
        guard let url = URL(string: baseURL) else {
            fatalError("Base URL is invalid")
        }
        return url
    }()
    
    static let authUserAccountStoreKey: String = {
        guard let key = Config.infoDictionary[Keys.authUserAccountStoreKey.rawValue] as? String else {
            fatalError("Auth User Account Store Key is not set in plist")
        }
        return key
    }()
}
