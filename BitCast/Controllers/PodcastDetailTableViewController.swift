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
    
    fileprivate func fetchEpisodes(_ sanitizedUrl: String) {
        APIService.shared.getDataFromFeed(with: sanitizedUrl) { [weak self] (episodes) in
            self?.episodes = episodes
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicatorView?.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName ?? ""
            guard let sanitizedUrl = podcast?.feedUrl?.sanitizeUrl() else {
                return
            }
            fetchEpisodes(sanitizedUrl)
        }
    }
    
    fileprivate func setupTableView() {
        let cellNib = UINib(nibName: "PodcastDetailTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
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
        cell.configure(publishedDate: episode.publicationDate,
                       episodeName: episode.title,
                       episodeDescription: episode.description,
                       episodeImagUrl: episode.imageUrl ?? "")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let window = UIApplication.shared.keyWindow
        guard let playerDetailsView = Bundle.main.loadNibNamed("PlayersDetailView",
                                                               owner: self,
                                                               options: nil)?.first as? PlayersDetailView else {
            return
        }
        playerDetailsView.frame = self.view.frame
        playerDetailsView.episode = self.episodes[indexPath.row]
        window?.addSubview(playerDetailsView)
    }
    
    var activityIndicatorView: UIActivityIndicatorView?
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView?.activityIndicatorViewStyle = .gray
        activityIndicatorView?.hidesWhenStopped = true
        activityIndicatorView?.startAnimating()
        return activityIndicatorView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
}
