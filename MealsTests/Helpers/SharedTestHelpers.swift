//
//  SharedTestHelpers.swift
//  MealsTests
//
//  Created by Reynaldi on 21/10/23.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
