//
//  String+sanitzeUrl.swift
//  BitCast
//
//  Created by Mitul Manish on 23/4/18.
//  Copyright © 2018 Mitul Manish. All rights reserved.
//

import Foundation

extension String {
    func sanitizeUrl() -> String {
        if !self.hasPrefix("https") {
            return self.replacingOccurrences(of: "http", with: "https")
        }
        return self
    }
}
