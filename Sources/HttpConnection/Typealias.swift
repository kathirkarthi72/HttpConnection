//
//  File.swift
//  
//
//  Created by Kathiresan on 14/12/19.
//

import Foundation
import UIKit

// MARK: Typealias
/// Input parameter
public typealias InputParams = [String: Any]

/// Image input parameter
public typealias ImageParams = [String: UIImage]

/// Failure handler
public typealias FailureHandler = ((_ errorLog: String?) -> ())

/// Completion handler
public typealias CompletionHandler = () -> ()

/// URL Result
public typealias URLResult =  (Result<(URLResponse, Data), Error>) -> Void
