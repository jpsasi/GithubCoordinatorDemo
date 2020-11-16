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

class RepositorySearchCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let baseViewController: UIViewController!
    var navigationController: UINavigationController!
    weak var coordinatorDelegate: RepositorySearchCoordinatorDelegate?
    let repository: GithubRepository

    
    /// When RepositorySearch screen presented modally
    /// - Parameters:
    ///   - baseViewController: Presenting ViewController
    ///   - coordinatorDelegate: coordinator delegate
    ///   - repository: Repository object
    init(baseViewController: UIViewController,
         coordinatorDelegate: RepositorySearchCoordinatorDelegate,
         repository: GithubRepository) {
        self.baseViewController = baseViewController
        self.coordinatorDelegate = coordinatorDelegate
        self.repository = repository
    }

    func start() {
        let searchController = RepositorySearchViewController.instantiate()
        navigationController = UINavigationController(rootViewController: searchController)
        let viewModel = RepositorySearchViewModel(withViewDelegate: searchController, coordinatorDelegate: self, repository: repository)
        searchController.viewModel = viewModel
        navigationController.presentationController?.delegate = self
        baseViewController.present(navigationController, animated: true, completion: nil)
    }
    
    private func showRepositoryDetail(selectedRepository: Repository) {
        let repositoryDetailCoordinator = RepositoryDetailCoordinator(navigationController: navigationController, coordinatorDelegate: self, selectedRepository: selectedRepository, repository: repository)
        addChildCoordinator(repositoryDetailCoordinator)
        repositoryDetailCoordinator.start()
    }

}

extension RepositorySearchCoordinator: RepositorySearchViewModelCoordinatorDelegate {
    
    func repositorySearchViewModelDidFinish(viewModel: RepositorySearchViewModel) {
        coordinatorDelegate?.repositorySearchCoordinatorDidFinish(coordinator: self)
    }
    
    func repositorySearchViewModel(viewModel: RepositorySearchViewModel, didSelect repository: Repository) {
        showRepositoryDetail(selectedRepository: repository)
    }
}


extension RepositorySearchCoordinator: RepositoryDetailCoordinatorDelegate {
    
    func repositoryDetailCoordinatorDidFinish(coordinator: RepositoryDetailCoordinator) {
        removeChildCoordinator(coordinator)
    }
}

extension RepositorySearchCoordinator: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        coordinatorDelegate?.repositorySearchCoordinatorDidFinish(coordinator: self)
    }
}
