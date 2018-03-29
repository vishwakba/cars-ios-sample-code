//
//  String+Additions.swift
//  cars-ios-interview
//
//  Created by Vishwak on 21/03/18.
//  Copyright © 2018 Vishwak. All rights reserved.
//

import Foundation
import UIKit

// MARK: - String Extension
extension String {
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}


