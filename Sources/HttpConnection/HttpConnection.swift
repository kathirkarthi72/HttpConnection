
//
//  HttpConnection.swift
//  FidelityUmsuka
//
//  Created by Kathiresan on 25/11/19.
//  Copyright © 2019 Kathiresan. All rights reserved.
//

import Foundation
import UIKit

// MARK: HTTPConnection

// MARK: Fetch resources from url

/// Fetch resource from Decodable
/// - Parameters:
///   - urlInputs: URL with input parameters
///   - completion: Completion handler
public func fetchResource<T: Decodable>(urlInputs: URLInputs,
                                 completion: @escaping((Result<T, HttpConnectionError>) -> Void)) {
    
    // Step 1 Creating URL Request
    var request = URLRequest(url: urlInputs.url)
    
    // Step 2 set http method
    request.httpMethod = urlInputs.httpMethod.rawValue
    
    // Step 3 set Http header fields
    if !urlInputs.httpHeader.isEmpty {
        request.allHTTPHeaderFields = urlInputs.httpHeader
    }
    
    // Step 4 set input parameters
    if urlInputs.httpMethod == .post {
        if urlInputs.imageParameters.isEmpty {
            
            let postString = getPostString(params: urlInputs.inputParameters)
            request.httpBody = postString.data(using: .utf8)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        } else {
            if let boundary = generateBoundaryString() {
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                
                if !urlInputs.imageParameters.isEmpty {
                    var imageDatas: [Data] = []
                    for image in urlInputs.imageParameters.values {
                        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
                        
                        imageDatas.append(imageData)
                    }
                    
                    var imageKeys: [String] = []
                    for key in urlInputs.imageParameters.keys {
                        imageKeys.append(key)
                    }
                    
                    request.httpBody = createBodyWithParameters(parameters: urlInputs.inputParameters, filePathKeys: imageKeys, imageDataKeys: imageDatas, boundary: boundary) as Data
                }
            }
        }
    }
    
    // Step 5 get URL Session dataTask
    let dataTask = URLSession.shared.customDataTask(with: request) { (result) in
        switch result {
        case .success(let (_, data)):
            do {
                let values = try JSONDecoder().decode(T.self, from: data)
                completion(.success(values))
            } catch {
                completion(.failure(.decodeError))
            }
            
        case .failure(let error):
            completion(.failure(.apiError(error: error)))
        }
    }
    
    // Step 7 Datatask resume
    dataTask.resume()
}

// MARK: Supporting functions
/// Generate boundart string form Multiform - data (image upload)
fileprivate func generateBoundaryString() -> String? {
    let lowerCaseLettersInASCII = UInt8(ascii: "a")...UInt8(ascii: "z")
    let upperCaseLettersInASCII = UInt8(ascii: "A")...UInt8(ascii: "Z")
    let digitsInASCII = UInt8(ascii: "0")...UInt8(ascii: "9")
    
    let sequenceOfRanges = [lowerCaseLettersInASCII, upperCaseLettersInASCII, digitsInASCII].joined()
    guard let toString = String(data: Data(sequenceOfRanges), encoding: .utf8) else { return nil }
    
    var randomString = ""
    for _ in 0..<20 { randomString += String(toString.randomElement()!) }
    
    let boundary = String(repeating: "-", count: 20) + randomString + "\(Int(Date.timeIntervalSinceReferenceDate))"
    
    return boundary
}

/// Get post strim
/// - Parameter params: input params
fileprivate func getPostString(params: InputParams) -> String {
    var data = [String]()
    for(key, value) in params
    {
        data.append(key + "=\(value)")
    }
    return data.map { String($0) }.joined(separator: "&")
}

/// Create body with parameters
/// - Parameters:
///   - parameters: input parameters
///   - filePathKeys: image file path keys
///   - imageDataKeys: image data keys
///   - boundary: boundary
fileprivate func createBodyWithParameters(parameters: InputParams, filePathKeys: [String], imageDataKeys: [Data], boundary: String) -> NSMutableData {
    let body = NSMutableData();
    
    /// Params
    for (key, value) in parameters {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }
    
    
    /// Images
    for item in 0..<filePathKeys.count {
        
        let filePathKey = filePathKeys[item]
        let imageDataKey = imageDataKeys[item]
        
        let filename = "image.jpg"
        let mimetype = "image/jpg"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
        body.append(imageDataKey)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
    }
    
    return body
}

