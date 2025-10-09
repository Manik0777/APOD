//
//  MainTabBarController.swift
//  NASA-APOD
//
//  Created by Manik on 07/10/2025.
//

import UIKit
import SwiftUI
import Dashboard
import Explore

public final class MainTabBarCoordinator {
    private let di: APODDIContainer
    public init(di: APODDIContainer) { self.di = di }

    @MainActor
    public func start() -> UITabBarController {
        let tabBar = UITabBarController()

        let dashVM = DashboardViewModel(repository: di.repository)
        let dashVC = DashboardViewController(viewModel: dashVM)
        dashVC.tabBarItem = UITabBarItem(title: "main.tabbar.screen.tabbar.item1.title".localized(bundle: Bundle.main), image: UIImage(systemName: "main.tabbar.screen.tabbar.item1.image.name".localized(bundle: Bundle.main)), tag: 0)
        let dashNav = UINavigationController(rootViewController: dashVC)

        let exploreVM = ExploreViewModel(repository: di.repository)
        let exploreView = ExploreView(viewModel: exploreVM)
        let exploreVC = UIHostingController(rootView: exploreView)
        exploreVC.tabBarItem = UITabBarItem(title: "main.tabbar.screen.tabbar.item2.title".localized(bundle: Bundle.main), image: UIImage(systemName: "main.tabbar.screen.tabbar.item2.image.name".localized(bundle: Bundle.main)), tag: 1)

        tabBar.viewControllers = [dashNav, exploreVC]
        return tabBar
    }
}

