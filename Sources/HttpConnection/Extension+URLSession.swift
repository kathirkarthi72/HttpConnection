//
//  File.swift
//  
//
//  Created by Kathiresan on 14/12/19.
//

import Foundation

// MARK: URL Session
extension URLSession {
    
    /// Custom data task
    /// - Parameters:
    ///   - urlRequest: url request
    ///   - result: url result
    func customDataTask(with urlRequest: URLRequest, result: @escaping URLResult) -> URLSessionDataTask {
        
        return dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            
            result(.success((response, data)))
        }
    }
}
