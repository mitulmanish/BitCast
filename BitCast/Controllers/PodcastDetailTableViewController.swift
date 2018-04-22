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
        let cellNib = UINib(nibName: "PodcastDetailTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
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
                    let episode = Episode(feedItem: item)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PodcastDetailTableViewCell
        let episode = episodes[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(publishedDate: episode.publicationDate, episodeName: episode.title, episodeDescription: episode.description)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
