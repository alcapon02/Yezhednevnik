//
//  SceneDelegate.swift
//  Yezhednevnik
//
//  Created by Александр Шастик on 15.12.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let rootViewController = CalendarViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = nil
        
        let navigationBar = navigationController.navigationBar
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

