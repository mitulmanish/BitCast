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
    let author: String
    let title: String
    let publicationDate: Date
    let description: String
    var imageUrl: String?
    var streamUrl: String
    
    init(feedItem: RSSFeedItem) {
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.title = feedItem.title ?? ""
        self.publicationDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href?.sanitizeUrl()
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
}
