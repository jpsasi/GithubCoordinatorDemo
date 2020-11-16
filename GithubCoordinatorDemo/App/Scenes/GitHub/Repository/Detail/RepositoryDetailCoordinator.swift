//
//  RepositoryDetailCoordinator.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 16/11/20.
//

import UIKit

protocol RepositoryDetailCoordinatorDelegate: class {
    func repositoryDetailCoordinatorDidFinish(coordinator: RepositoryDetailCoordinator)
}

class RepositoryDetailCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    weak var coordinatorDelegate: RepositoryDetailCoordinatorDelegate?
    let navigationController: UINavigationController
    let selectedRepository: Repository
    let repository: GithubRepository

    init(navigationController: UINavigationController, coordinatorDelegate: RepositoryDetailCoordinatorDelegate, selectedRepository: Repository,
         repository: GithubRepository) {
        self.navigationController = navigationController
        self.coordinatorDelegate = coordinatorDelegate
        self.selectedRepository = selectedRepository
        self.repository = repository
    }
    
    func start() {
        let viewController = RepositoryDetailViewController.instantiate()
        let viewModel = RepositoryDetailViewModel(selectedRepository: selectedRepository, viewDelegate: viewController, coordinatorDelegate: self, repository: repository)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension RepositoryDetailCoordinator: RepositoryDetailViewModelCoordinatorDelegate {
    
    func repositoryDetailViewModelDidDismissRepositoryDetail(viewModel: RepositoryDetailViewModel) {
        coordinatorDelegate?.repositoryDetailCoordinatorDidFinish(coordinator: self)
    }
}
