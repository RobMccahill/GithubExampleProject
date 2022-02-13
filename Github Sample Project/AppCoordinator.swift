//
//  AppCoordinator.swift
//  Github Sample Project
//
//  Created by Robert Mccahill on 13/02/2022.
//

import Foundation
import UIKit

class AppCoordinator {
    let window: UIWindow
    var navigationController: UINavigationController!
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        navigationController.setViewControllers(
            [
                configureStartScreenViewController(),
                configureSearchUsersViewController()
            ],
            animated: true
        )
        
        navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController = navigationController
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func configureStartScreenViewController() -> StartScreenViewController {
        let viewController = StartScreenViewController(
            nibName: "StartScreenViewController",
            bundle: nil
        )
        
        let eventHandler = StartScreenViewController.EventHandler(
            searchUsersTapped: searchUsersTapped,
            //todo: Hook up when repositories screen is built
            searchRepositoriesTapped: {}
        )
        viewController.eventHandler = eventHandler
        return viewController
    }
}


private extension AppCoordinator {
    func configureSearchUsersViewController() -> SearchUsersViewController {
        let searchUsersViewController = SearchUsersViewController(
            nibName: "SearchUsersViewController",
            bundle: nil
        )
        
        searchUsersViewController.viewModel = SearchUsersViewModel(
            repository: UserSearchService().asRepository()
        )
        
        return searchUsersViewController
    }
    
    func searchUsersTapped() {
        navigationController.pushViewController(configureSearchUsersViewController(), animated: true)
    }
}
