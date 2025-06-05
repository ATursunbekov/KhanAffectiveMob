//
//  SceneDelegate.swift
//  KhanMobileEffect
//
//  Created by Alikhan Tursunbekov on 1/6/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = UINavigationController(rootViewController: MainModuleBuilder.build())
        window?.makeKeyAndVisible()
    }
}
