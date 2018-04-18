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
    }
    
     //MARK:- Helper Functions
    
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
