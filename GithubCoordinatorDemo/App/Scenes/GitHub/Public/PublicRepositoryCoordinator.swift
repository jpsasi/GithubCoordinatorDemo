//
//  PublicRepositoryCoordinator.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 08/11/20.
//

import UIKit

class PublicRepositoryCoordinator: Coordinator {
    
    let tabBarController: UITabBarController
    var navigationController: UINavigationController!
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
        let viewController = PublicRepositoryViewController.instantiate()
        navigationController = UINavigationController(rootViewController: viewController)
        let viewModel = PublicRepositoryViewModel(withViewDelegate: viewController,
                                                  coordinatorDelegate: self,
                                                  repository: repository,
                                                  dataStore: dataStore)
        viewController.viewModel = viewModel
        viewModel.viewDelegate = viewController
        if tabBarController.viewControllers == nil {
            tabBarController.viewControllers = [navigationController]
        } else {
            tabBarController.viewControllers?.append(navigationController)
        }
        let image = UIImage(systemName: "list.dash")
        viewController.tabBarItem = UITabBarItem(title: "Repository", image: image, tag: 0)
        
        navigationController.navigationBar.standardAppearance = navigationBarAppearance()
        navigationController.navigationBar.compactAppearance = navigationBarAppearance()
    }
    
    func showSearch() {
        let searchController = RepositorySearchViewController.instantiate()
        let viewModel = RepositorySearchViewModel(withViewDelegate: searchController, coordinatorDelegate: self, repository: repository)
        searchController.viewModel = viewModel
        navigationController.pushViewController(searchController, animated: true)
    }
}

extension PublicRepositoryCoordinator: PublicRepositoryViewModelCoordinatorDelegate {
    
    func repositoryViewModelDidSelectSearch(viewModel: PublicRepositoryViewModel) {
        showSearch()
    }
}

extension PublicRepositoryCoordinator: RepositorySearchViewModelCoordinatorDelegate {
    
}
