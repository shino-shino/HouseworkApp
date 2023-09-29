//
//  TabBarViewController.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/28.
//

import UIKit

//@available(iOS 15.0, *)
class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    //MARK: viewDidLoad()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        if #available(iOS 15.0, *) {
            // アイコンの色を変更できます！
            UITabBar.appearance().tintColor = appColor.secondary
            // 背景色を変更できます！
            let appearance = UITabBarAppearance()
            appearance.backgroundColor =  appColor.primary
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.barTintColor = appColor.primary
            tabBar.tintColor = appColor.secondary
        }
    }
} 
