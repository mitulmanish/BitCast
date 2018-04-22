//
//  Episode.swift
//  BitCast
//
//  Created by Mitul Manish on 21/4/18.
//  Copyright © 2018 Mitul Manish. All rights reserved.
//

import Foundation
import FeedKit

struct Episode {
    var title: String
    var publicationDate: Date
    var description: String
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.publicationDate = feedItem.pubDate ?? Date()
        self.description = feedItem.description ?? ""
    }
}
