//
//  PodcastsSearchTableViewController.swift
//  BitCast
//
//  Created by Mitul Manish on 17/4/18.
//  Copyright © 2018 Mitul Manish. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    static let cellIdentifier = "cellId"
    var podcasts = [Podcast]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
    }
    
    // MARK:- Helpers
    
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupTableView() {
        let podcastNib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(podcastNib, forCellReuseIdentifier: PodcastsSearchTableViewController.cellIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    var searchTimer: Timer?
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false, block: { (_) in
            APIService.shared.fetchPodcasts(with: searchText) { [weak self] (podcasts, error) in
                if let err = error {
                    print(err)
                } else if let podcasts = podcasts {
                    self?.podcasts = podcasts
                    self?.tableView.reloadData()
                }
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PodcastsSearchTableViewController.cellIdentifier, for: indexPath) as? PodcastTableViewCell ?? PodcastTableViewCell()
        cell.selectionStyle = .none
        let podcast = podcasts[indexPath.row]
        cell.configureCell(trackName: podcast.trackName ?? "",
                           artistName: podcast.artistName ?? "",
                           episodeCount: podcast.trackCount ?? 0,
                           imageUrl: podcast.artworkUrl600 ?? "")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please search for a Podcast"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .blue
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return podcasts.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podcast = podcasts[indexPath.item]
        let destinationController = PodcastDetailTableViewController()
        destinationController.podcast = podcast
        navigationController?.pushViewController(destinationController, animated: true)
    }
}
