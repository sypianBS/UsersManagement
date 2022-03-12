//
//  ViewController.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 12.03.22.
//

import UIKit

import UIKit
class ViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let favoritesTab = FavoritesViewController()
        let favoritesTabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        
        favoritesTab.tabBarItem = favoritesTabBarItem
        
        let mainListTab = MainListViewController()
        let mainListTabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "list.bullet.rectangle.portrait"), selectedImage: UIImage(systemName: "list.bullet.rectangle.portrait.fill"))
        
        mainListTab.tabBarItem = mainListTabBarItem
        
        let settingsTab = SettingsViewController()
        let settingsTabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape"))
        
        settingsTab.tabBarItem = settingsTabBarItem
        
        
        self.viewControllers = [favoritesTab, mainListTab, settingsTab]
    }
        
}
