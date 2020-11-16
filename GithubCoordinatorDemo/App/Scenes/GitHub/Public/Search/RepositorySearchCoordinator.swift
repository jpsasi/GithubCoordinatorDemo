//
//  RepositorySearchCoordinator.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 16/11/20.
//

import UIKit

protocol RepositorySearchCoordinatorDelegate: class {
    func repositorySearchCoordinatorDidFinish(coordinator: RepositorySearchCoordinator)
}

class RepositorySearchCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    weak var coordinatorDelegate: RepositorySearchCoordinatorDelegate?
    let repository: GithubRepository

    init(navigationController: UINavigationController,
         coordinatorDelegate: RepositorySearchCoordinatorDelegate,
         repository: GithubRepository) {
        self.navigationController = navigationController
        self.coordinatorDelegate = coordinatorDelegate
        self.repository = repository
    }
    
    func start() {
        let searchController = RepositorySearchViewController.instantiate()
        let searchNavController = UINavigationController(rootViewController: searchController)
        let viewModel = RepositorySearchViewModel(withViewDelegate: searchController, coordinatorDelegate: self, repository: repository)
        searchController.viewModel = viewModel
        self.navigationController.present(searchNavController, animated: true, completion: nil)
    }
}

extension RepositorySearchCoordinator: RepositorySearchViewModelCoordinatorDelegate {
    
    func repositorySearchViewModelDidFinish(viewModel: RepositorySearchViewModel) {
        coordinatorDelegate?.repositorySearchCoordinatorDidFinish(coordinator: self)
    }
}
