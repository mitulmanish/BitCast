//
//  APIService.swift
//  BitCast
//
//  Created by Mitul Manish on 20/4/18.
//  Copyright © 2018 Mitul Manish. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    struct SearchResult: Codable {
        var resultCount: Int?
        var results: [Podcast]?
    }
    
    let baseUrl: String = "https://itunes.apple.com/search"
    
    static let shared = APIService()
    
    func fetchPodcasts(with searchTerm: String,
                       completionHandler: @escaping (([Podcast]?, Error?) -> ())) {
        let params = ["term": "\(searchTerm)", "media": "podcast"]
        Alamofire.request(baseUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).response { (response) in
            if let error = response.error {
                print(error)
                return
            }
            
            guard let data = response.data else {
                return
            }
            
            do {
                let searchResults = try JSONDecoder().decode(SearchResult.self, from: data)
                let podcasts = searchResults.results.flatMap({ $0 }) ?? []
                completionHandler(podcasts, nil)
            } catch let decodeError {
                completionHandler(nil, decodeError)
            }
        }
    }
    
    func getDataFromFeed(with feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        let santizedUrl = feedUrl.sanitizeUrl()
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: santizedUrl), let feedParser = FeedParser(URL: url) else {
                return
            }
            
            feedParser.parseAsync { (result) in
                guard let feed = result.rssFeed else {
                    return
                }
                let episodes = feed.toEpisodes() ?? []
                completionHandler(episodes)
            }
        }
    }
}
