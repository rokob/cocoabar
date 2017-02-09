//
//  ViewController.swift
//  swiftbar
//
//  Created by Andrew Weiss on 2/9/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

import UIKit

enum Tabs: Int {
    case Favorites
    case TopRated
}

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configure() {
        let vc1 = FavoritesViewController()
        vc1.title = "Errors"
        let nav1 = UINavigationController(rootViewController: vc1)
        nav1.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.favorites, tag: Tabs.Favorites.rawValue)
        
        let vc2 = TopRatedViewController()
        vc2.title = "Network"
        let nav2 = UINavigationController(rootViewController: vc2)
        nav2.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.topRated, tag: Tabs.TopRated.rawValue)
        
        self.viewControllers = [nav1, nav2]
    }


}

