//
//  ViewController.swift
//  PhotoEditor
//
//  Created by Alexandr Filovets on 4.06.24.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarApperance()
    }

    private func generateTabBar() {
        viewControllers = [
            generateVC(viewController: MainVC(), title: "Main", image: UIImage(systemName: "camera")),
            generateVC(viewController: SettingsVC(), title: "Settings", image: UIImage(systemName: "gear"))
        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
    
    private func setTabBarApperance() {
        let positionOnX: CGFloat = 114
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(x: positionOnX, y: tabBar.bounds.minY - positionOnY, width: width, height: height),
            cornerRadius: height / 2
        )
        roundLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor.mainWhite.cgColor
        
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight
    }
}
