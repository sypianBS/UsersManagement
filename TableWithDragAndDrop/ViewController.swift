//
//  ViewController.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 12.03.22.
//

import UIKit

import UIKit
class ViewController: UITabBarController {
    
    let users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let favoritesTab = FavoritesViewController()
        let favoritesTabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        
        favoritesTab.tabBarItem = favoritesTabBarItem
        
        //needed to show the search bar
        let mainListTab = UINavigationController(rootViewController: MainListViewController())
        let mainListTabBarItem = UITabBarItem(title: "Users", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        mainListTab.tabBarItem = mainListTabBarItem
        
        let settingsTab = SettingsViewController()
        let settingsTabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape"))
        
        settingsTab.tabBarItem = settingsTabBarItem
        
        self.viewControllers = [favoritesTab, mainListTab, settingsTab]
        self.selectedIndex = 1 //start point is the middle tab
    }
        
}
