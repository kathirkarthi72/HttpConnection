//
//  File.swift
//  
//
//  Created by Kathiresan on 14/12/19.
//

import Foundation

/// Request URL with input parameters
public struct URLInputs {
    
    /// Request url
    public var url: URL
    
    /// Http method
    public var httpMethod: HttpMethod
    
    /// Http header
    public var httpHeader: [String: String]
    
    /// Post input paramter
    public var inputParameters: InputParams
    
    /// Post image parameter
    public var imageParameters: ImageParams
    
    /// Init
    /// - Parameters:
    ///   - url: request url
    ///   - method: http method
    ///   - header: http header
    ///   - inputP: Post input param
    ///   - imageP: Post image param
    public init(requestURL url: URL,
                httpMethod method: HttpMethod = .get,
                httpHeader header: [String: String] = [:],
                inputParameters inputP: InputParams = [:],
                imageParameters imageP: ImageParams = [:]) {
        
        self.url = url
        self.httpMethod = method
        self.httpHeader = header
        self.inputParameters = inputP
        self.imageParameters = imageP
    }
}
