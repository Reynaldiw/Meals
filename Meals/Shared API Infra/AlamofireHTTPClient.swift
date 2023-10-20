//
//  AlamofireHTTPClient.swift
//  Meals
//
//  Created by Reynaldi on 21/10/23.
//

import Foundation
import Alamofire

public final class AlamofireHTTPClient: HTTPClient {
    
    private let session: Session
    
    public init (urlSession: URLSession) {
        self.session = Alamofire.Session(configuration: urlSession.configuration)
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private struct AlamofireDataRequestWrapper: HTTPClientTask {
        
        let wrapped: DataRequest
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let dataRequest = session.request(url, method: .get)
            .responseData(emptyResponseCodes: [200]) { response in
                switch response.result {
                case let .failure(error):
                    completion(.failure(error))
                    
                    
                case let .success(data):
                    guard let urlResponse = response.response else {
                        return completion(.failure(UnexpectedValuesRepresentation()))
                    }
                    
                    completion(.success((data, urlResponse)))
                }
            }
        dataRequest.resume()
        return AlamofireDataRequestWrapper(wrapped: dataRequest)
    }
}
