//
//  SceneDelegate.swift
//  NASA-APOD
//
//  Created by Manik on 07/10/2025.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: MainTabBarCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let ws = (scene as? UIWindowScene) else { return }
        let di = APODDIContainer(apiKey: ProcessInfo.processInfo.environment["NASA_API_KEY"])
        coordinator = MainTabBarCoordinator(di: di)
        let window = UIWindow(windowScene: ws)
        window.rootViewController = coordinator?.start()
        self.window = window
        window.makeKeyAndVisible()
    }
}
