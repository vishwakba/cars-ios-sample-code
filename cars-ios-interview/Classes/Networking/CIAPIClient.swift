//
//  CIAPIClient.swift
//  cars-ios-interview
//
//  Created by Vishwak on 21/03/18.
//  Copyright © 2018 Vishwak. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
}

open class CIAPIClient {
    // MARK: - Singleton Instance
    fileprivate static let _shared = CIAPIClient()
    
    fileprivate let kAPIBaseURLString = "https://api.walmartlabs.com/"
    var session: URLSession
    var accessToken: String?
    var clientId = "OrdDb6nL8D8AiQbHEiU"
    var clientSecret = "C6ZTGSYev7UpnfOVW7KL1zTTHQ2L0i8Q4tu9f4FwyxKMC0wXhDrUC"
    var grantType = "client_credentials"

    class func shared() -> CIAPIClient {
        return _shared
    }

    public init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Accept" : "application/json",
        ]
        self.session = URLSession(configuration: configuration,
            delegate: nil,
            delegateQueue: OperationQueue.main)
    }

    open func requestWithPath(_ path: String,
                                method: HTTPMethod = .GET,
                                parameter: [String: String],
                                completion: ((Data?,  NSError?) -> ())?) -> URLSessionDataTask {
        let request: NSMutableURLRequest

        if method == .POST {
            let urlString = kAPIBaseURLString + path
            request = NSMutableURLRequest(url: URL(string: urlString as String)!)
            request.httpMethod = method.rawValue
            request.httpBody = buildQueryString(fromDictionary: parameter).data(using: String.Encoding.utf8)
        }
        else {
            let urlString = kAPIBaseURLString + path + buildQueryString(fromDictionary: parameter)
            request = NSMutableURLRequest(url: URL(string: urlString as String)!)
            request.httpMethod = method.rawValue
        }
        
//        if self.accessToken != nil {
//            let token = (self.accessToken)!
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }

        let task = session.dataTask(with: request as URLRequest) {data,response,error in
            if (data == nil || error != nil) {
                completion?(nil, error as NSError?)
            } else {
                completion?(data, error as NSError?)
            }
        }
        
        task.resume()
        
        return task
    }

    fileprivate func buildQueryString(fromDictionary parameters: [String: String]) -> String {

        var urlVars = [String]()
        for (key, var val) in parameters {
            val = val.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            urlVars += [key + "=" + "\(val)"]
        }
        return urlVars.joined(separator: "&")
    }
}
