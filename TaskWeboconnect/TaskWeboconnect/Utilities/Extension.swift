//
//  Extension.swift
//  TaskWeboconnect
//
//  Created by Sandeep Srivastava on 26/07/24.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
