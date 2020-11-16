//
//  RepositoryCoordinator.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 08/11/20.
//

import UIKit

class RepositoryCoordinator: NSObject, Coordinator {
    
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
        let viewController = RepositoryListViewController.instantiate()
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.delegate = self
        let viewModel = RepositoryListViewModel(withViewDelegate: viewController,
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
    
    private func showSearch() {
        let searchCoordinator = RepositorySearchCoordinator(baseViewController: navigationController, coordinatorDelegate: self, repository: repository)
        addChildCoordinator(searchCoordinator)
        searchCoordinator.start()
    }
    
    private func showRepositoryDetail(selectedRepository: Repository) {
        let repositoryDetailCoordinator = RepositoryDetailCoordinator(navigationController: navigationController, coordinatorDelegate: self, selectedRepository: selectedRepository, repository: repository)
        addChildCoordinator(repositoryDetailCoordinator)
        repositoryDetailCoordinator.start()
    }
}

extension RepositoryCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let detailViewController = fromViewController as? RepositoryDetailViewController {
            detailViewController.viewModel.onDismiss()
        }
        
        if let searchViewController = fromViewController as? RepositorySearchViewController {
            searchViewController.viewModel.onDismissRepositorySearch()
        }
    }
}

extension RepositoryCoordinator: RepositoryViewModelCoordinatorDelegate {
    
    func repositoryViewModelDidSelectSearch(viewModel: RepositoryListViewModel) {
        showSearch()
    }
    
    func repositoryViewModel(viewModel: RepositoryListViewModel, didSelect repository: Repository) {
        showRepositoryDetail(selectedRepository: repository)
    }
}

extension RepositoryCoordinator: RepositorySearchCoordinatorDelegate {
    
    func repositorySearchCoordinatorDidFinish(coordinator: RepositorySearchCoordinator) {
        removeChildCoordinator(coordinator)
    }
    
}

extension RepositoryCoordinator: RepositoryDetailCoordinatorDelegate {
    
    func repositoryDetailCoordinatorDidFinish(coordinator: RepositoryDetailCoordinator) {
        removeChildCoordinator(coordinator)
    }    
}
