//
//  CIAPIHandler.swift
//  cars-ios-interview
//
//  Created by Vishwak on 21/03/18.
//  Copyright © 2018 Vishwak. All rights reserved.
//

import Foundation

typealias CompletionBlock = (_ result: [String: AnyObject]?,_ error: Error?) -> Void
let kAPI_KEY = "dmatdjj2ctutkh79hh2bjc7g"

class CIAPIHandler: NSObject {
    
    class func fetchContent(_ query: String, numOfItems:Int, offset:Int, completion: @escaping CompletionBlock) -> URLSessionDataTask {
        let client = CIAPIClient.shared()
        let parameter: [String: String] = [:];
        return client.requestWithPath("v1/search?query=\(query)&format=json&apiKey=\(kAPI_KEY)&numItems=\(numOfItems)&start=\(offset)", parameter: parameter) {
            (data, error) in
            do {
                if data != nil {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
                    completion(json, nil)
                } else {
                    completion(nil, error)
                }
            } catch {
                completion(nil, error)
            }
        }
    }
}
