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
    var podcasts: [Podcast] = [
        Podcast(trackName: "Tech Crunch", artistName: "Xavier Hernandez"),
        Podcast(trackName: "Wired", artistName: "Zoey Simmons")
    ]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        
        let s = SomeStruct<Int, String>()
        s.doSomeThing(with: 5)
        s.doSomeThingAgain(with: 5, v: "hey")
    }
    
    // MARK:- Helpers
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupTableView() {
        let podcastNib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(podcastNib, forCellReuseIdentifier: PodcastsSearchTableViewController.cellIdentifier)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let url = "https://itunes.apple.com/search"
        let params = ["term": "\(searchText)", "media": "podcast"]
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).response { [weak self] (response) in
            if let error = response.error {
                print(error)
                return
            }
            guard let data = response.data else {
                return
            }
            
            do {
                let searchResults = try JSONDecoder().decode(SearchResult.self, from: data)
                self?.podcasts = searchResults.results.flatMap({ $0 }) ?? []
                self?.tableView.reloadData()
            } catch let decodeError {
                print(decodeError)
            }
        }
    }
    
    struct SearchResult: Codable {
        var resultCount: Int?
        var results: [Podcast]?
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
        cell.configureCell(trackName: podcast.trackName ?? "", artistName: podcast.artistName ?? "", episodeCount: 10)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
}
