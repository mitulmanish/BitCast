//
//  Date+string.swift
//  BitCast
//
//  Created by Mitul Manish on 23/4/18.
//  Copyright © 2018 Mitul Manish. All rights reserved.
//

import Foundation

extension Date {
    func stringify() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter.string(from: self)
    }
}
