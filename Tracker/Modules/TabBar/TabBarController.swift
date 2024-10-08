//
//  TabBarController.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 22.07.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = UIColor(named: "White")
        setupTabBar()
    }
    
    func setupTabBar() {
        
        let trackerViewController = UINavigationController(rootViewController: TrackerViewController())
        let statisticViewController = UINavigationController(rootViewController: StatisticViewController())
       
        trackerViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Trackers", comment: ""),
            image: UIImage(named: "tab_bar_tracker_icon"),
            selectedImage: nil
        )
        statisticViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Stats", comment: ""),
            image: UIImage(named: "tab_bar_statistic_icon"),
            selectedImage: nil
        )
        
        self.viewControllers = [trackerViewController, statisticViewController]
    }
}
