//
//  CIData.swift
//  cars-ios-interview
//
//  Created by Vishwak on 21/03/18.
//  Copyright © 2018 Vishwak. All rights reserved.
//

import UIKit

class CIData: NSObject {

    let shortDescription: String?
    let name: String?
    let imageEntities: Array<Any>?

    init(company: [String: AnyObject]) {
        self.shortDescription = "\((company["shortDescription"])!)"
        self.name = company["name"] as? String
        self.imageEntities = company["imageEntities"] as? Array<Any>

    }
}
