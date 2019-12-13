//
//  HttpConnectionError.swift
//  FidelityUmsuka
//
//  Created by Kathiresan on 10/12/19.
//  Copyright © 2019 Kathiresan. All rights reserved.
//

import Foundation

/// HTTP Connection error
public enum HttpConnectionError: Error {
    
    /// API error. custom error
    case apiError(error: Error)
    
    /// Invalid endpoint
    case invalidEndpoint
    
    /// Invalid Response
    case invalidResponse
    
    /// No Data
    case noData
    
    /// Decode Error
    case decodeError
    
    /// Invalid url
    case invalidURL
    
    /// Custom localized description
    public var localizedDescription: String {
        switch self {
        case .apiError(error: let error):
            return error.localizedDescription
        case .invalidEndpoint:
            return "Invalid end point"
        case .invalidResponse:
            return  "Invalid response"
        case .noData:
            return "No data fount"
        case .decodeError:
            return "Decode error"
        case .invalidURL:
            return "Invalid url"
        }
    }
}


