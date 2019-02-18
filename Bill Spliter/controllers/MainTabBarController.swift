//
//  MainTabBarController.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 10/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let groupsVC = GroupsTableViewController()
        groupsVC.tabBarItem = UITabBarItem(title: "Groups", image: UIImage(named: "cart-icon"), tag: 0)
        
        let friendsVC = FriendsViewController()
        friendsVC.tabBarItem = UITabBarItem(title: "Friends", image: UIImage(named: "login-icon"), tag: 1)
        
        let tabBarList = [groupsVC, friendsVC]
        viewControllers = tabBarList
        
        self.title = "Your groups"
        tabBar.isTranslucent = true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = item.tag == 0 ? "Your groups" : "Your friends"
    }
}
