//
//  MainTabBarController.swift
//  BitCast
//
//  Created by Mitul Manish on 17/4/18.
//  Copyright © 2018 Mitul Manish. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .purple
        UINavigationBar.appearance().prefersLargeTitles = true
        setupViewControllers()
        
        setupPlayerDetailsView()
    }
    
     //MARK:- Helper Functions
    
    private var anchorConstant: CGFloat!
    private var playerMinimizedTopAnchor: NSLayoutConstraint!
    private var playerMaximizedTopAnchor: NSLayoutConstraint!
    
    var playerDetailView: PlayersDetailView? = PlayersDetailView.initFromNib()
    func setupPlayerDetailsView() {
        guard let playerDetailView = playerDetailView
            else { return }
        view.insertSubview(playerDetailView, belowSubview: tabBar)
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        anchorConstant = tabBar.frame.height
        playerMinimizedTopAnchor = playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: anchorConstant)
        playerMinimizedTopAnchor.isActive = true
        
        playerMaximizedTopAnchor = playerDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        playerMaximizedTopAnchor.isActive = false
        
        playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    enum PlayerDetailsViewAnimationType {
        case shrink
        case expand
    }
    
    func animatePlayerDetailsView(withAnimationType type: PlayerDetailsViewAnimationType) {
        switch type {
        case .expand:
            playerMinimizedTopAnchor.isActive = false
            playerMaximizedTopAnchor.isActive = true
        case .shrink:
            playerMaximizedTopAnchor.isActive = false
            playerMinimizedTopAnchor.isActive = true
            playerMinimizedTopAnchor.constant = -64
        }
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                        switch type {
                        case .expand:
                            self?.tabBar.transform = CGAffineTransform(translationX: 0, y: self?.tabBar.frame.height ?? 44)
                        case .shrink:
                            self?.tabBar.transform = .identity
                        }
            self?.view.layoutIfNeeded()
        })
    }
    
    fileprivate func setupViewControllers() {
        viewControllers = [
            generateNavigationController(with: PodcastsSearchTableViewController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            generateNavigationController(with: UIViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
            generateNavigationController(with: UIViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
    }
    
    fileprivate func generateNavigationController(with rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        return navigationController
    }
}
