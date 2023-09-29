//
//  AppDelegate.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/06.
//

import UIKit
import NCMB

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let applicationKey = "d2f862695c8699ed78cdc42d0692962ef8c554ab3a767c6683617cfa8a64096b"
        let clientKey = "fc822401d14eb7dad2267279a62b7fa7e58a7047aa040fe45551e4df5419e8d4"
        NCMB.setApplicationKey(applicationKey, clientKey: clientKey)
        
        changeNavigationBarColor()
        
        return true
    }
    
    func changeNavigationBarColor() {
        // 全てのNavigation Barの色を変更する
        // Navigation Bar の背景色の変更
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = appColor.primary
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        // Navigation Bar の文字色の変更
        UINavigationBar.appearance().tintColor = appColor.secondary
        // Navigation Bar のタイトルの文字色の変更
        //UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: appColor.background]
        }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

