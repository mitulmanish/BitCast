//
//  RSSFeed+iTunes.swift
//  BitCast
//
//  Created by Mitul Manish on 23/4/18.
//  Copyright © 2018 Mitul Manish. All rights reserved.
//

import Foundation
import FeedKit

extension RSSFeed {
    func toEpisodes() -> [Episode]? {
        let feedImageUrl = iTunes?.iTunesImage?.attributes?.href?.sanitizeUrl()
        guard let feedItems = self.items else {
            return nil
        }
        var episodes = [Episode]()
        for item in feedItems {
            var episode = Episode(feedItem: item)
            if episode.imageUrl == nil {
                episode.imageUrl = feedImageUrl
            }
            episodes.append(episode)
        }
        return episodes
    }
}
