//
//  GithubOrganizationCoordinator.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 08/11/20.
//

import UIKit

class OrganizationCoordinator: Coordinator {
    
    let tabBarController: UITabBarController
    var childCoordinators: [Coordinator] = []
    
    init(withTabBarController tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    func start() {
        let repositoryListViewController = GithubOrganizationListViewController.instantiate()
        let repositoryListNavController = UINavigationController(rootViewController: repositoryListViewController)
        let viewModel = GithubOrganizationListViewModel(withViewDelegate: repositoryListViewController, coordinatorDelegate: self, repository: GithubRepository(), dataStore: GithubDataStore.shared)
        repositoryListViewController.viewModel = viewModel
        viewModel.viewDelegate = repositoryListViewController
        if tabBarController.viewControllers == nil {
            tabBarController.viewControllers = [repositoryListNavController]
        } else {
            tabBarController.viewControllers?.append(repositoryListNavController)
        }
    }
}

extension OrganizationCoordinator: GithubOrganizationListViewModelCoordinatorDelegate {
    
}
