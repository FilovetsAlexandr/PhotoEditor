//
//  AppDelegate.swift
//  PhotoEditor
//
//  Created by Alexandr Filovets on 4.06.24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { true }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration { UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role) }
}

