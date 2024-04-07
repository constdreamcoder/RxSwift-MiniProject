//
//  MainViewController.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/6/24.
//

import UIKit

final class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchVC = SearchViewController()
        let bookmarkVC = BookmarkViewController()
        
        let searchNav = UINavigationController(rootViewController: searchVC)
        let bookmarkNav = UINavigationController(rootViewController: bookmarkVC)
        
        
        searchNav.tabBarItem = UITabBarItem(
            title: "검색",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        bookmarkNav.tabBarItem = UITabBarItem(
            title: "북마크",
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill")
        )
        
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        
        setViewControllers([searchNav, bookmarkNav], animated: false)
    }
    
}
