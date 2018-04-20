//
//  PodcastDetailTableViewController.swift
//  BitCast
//
//  Created by Mitul Manish on 20/4/18.
//  Copyright © 2018 Mitul Manish. All rights reserved.
//

import UIKit
import FeedKit

class PodcastDetailTableViewController: UITableViewController {
    private let cellIdentifier = "cellId"
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName ?? ""
            getDataFromFeed()
        }
    }
    
    fileprivate func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
        
    }
    
    func getDataFromFeed() {
        guard let feedUrl = podcast?.feedUrl else {
            return
        }
        
        let santizedUrl = feedUrl.hasPrefix("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: santizedUrl), let feedParser = FeedParser(URL: url) else {
            return
        }
        
        feedParser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { [weak self] (result) in
            switch result {
            case .rss(let feed):
                guard let items = feed.items else {
                    break
                }
                for item in items {
                    let episode = Episode(title: item.title ?? "", publicationDate: item.pubDate)
                    self?.episodes.append(episode)
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
                }
            case .failure(let err):
                print(err)
            default:
                break
            }
        }
    }
    
    struct Episode {
        var title: String
        var publicationDate: Date?
    }
    
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        let episode = episodes[indexPath.item]
        cell.textLabel?.text = episode.title
        return cell
    }
}
