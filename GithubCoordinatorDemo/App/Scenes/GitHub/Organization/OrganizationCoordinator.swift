//
//  OrganizationCoordinator.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 08/11/20.
//

import UIKit

class OrganizationCoordinator: Coordinator {
    
    let tabBarController: UITabBarController
    let repository: GithubRepository
    let dataStore: GithubDataStore
    var childCoordinators: [Coordinator] = []
    
    init(withTabBarController tabBarController: UITabBarController,
         repository: GithubRepository, dataStore: GithubDataStore) {
        self.tabBarController = tabBarController
        self.repository = repository
        self.dataStore = dataStore
    }

    func start() {
        let viewController = OrganizationListViewController.instantiate()
        let navController = UINavigationController(rootViewController: viewController)
        let viewModel = OrganizationListViewModel(withViewDelegate: viewController,
                                                  coordinatorDelegate: self,
                                                  repository: repository,
                                                  dataStore: dataStore)
        viewController.viewModel = viewModel
        viewModel.viewDelegate = viewController
        if tabBarController.viewControllers == nil {
            tabBarController.viewControllers = [navController]
        } else {
            tabBarController.viewControllers?.append(navController)
        }
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
    }
}

extension OrganizationCoordinator: OrganizationListViewModelCoordinatorDelegate {
    
}
