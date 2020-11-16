//
//  GithubCoordinator.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 07/11/20.
//

import UIKit

protocol GithubRepositoryCoordinatorDelegate: class {
    
}

class GithubCoordinator: Coordinator {
    
    let tabBarController: UITabBarController
    let repository: GithubRepository
    let dataStore: GithubDataStore
    
    var childCoordinators: [Coordinator] = []
    
    init(withTabBarController tabBarController: UITabBarController, repository: GithubRepository, dataStore: GithubDataStore) {
        self.tabBarController = tabBarController
        self.repository = repository
        self.dataStore = dataStore
    }
    
    deinit {
        print("GithubRepositoryCoordinator deinit")
    }
    
    func start() {
        let publicRepositoryCoordinator = RepositoryCoordinator(withTabBarController: tabBarController, repository: repository, dataStore: dataStore)
        addChildCoordinator(publicRepositoryCoordinator)
        publicRepositoryCoordinator.start()

        let organizationCoordinator = OrganizationCoordinator(withTabBarController: tabBarController, repository: repository, dataStore: dataStore)
        addChildCoordinator(organizationCoordinator)
        organizationCoordinator.start()
    }
}

