//
//  CMTime+formattedTime.swift
//  BitCast
//
//  Created by Mitul Manish on 25/4/18.
//  Copyright © 2018 Mitul Manish. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
    func toTimeInHourMinuteAndSeconds() -> String {
        let timeInFloat64 = CMTimeGetSeconds(self)
        guard !timeInFloat64.isNaN else {
            return "--:--:--"
        }
        let timeInSeconds = Int(timeInFloat64)
        let seconds = timeInSeconds % 60
        let minutes = timeInSeconds % (60 * 60) / 60
        let hours = timeInSeconds / 60 / 60
        let formattedString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return formattedString
    }
}
