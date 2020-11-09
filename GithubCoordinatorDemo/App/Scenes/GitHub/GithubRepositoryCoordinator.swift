//
//  GithubRepositoryCoordinator.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 07/11/20.
//

import UIKit

protocol GithubRepositoryCoordinatorDelegate: class {
    
}

class GithubCoordinator: Coordinator {

    let tabBarController: UITabBarController
    var childCoordinators: [Coordinator] = []
    
    init(withTabBarController tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    deinit {
        print("GithubRepositoryCoordinator deinit")
    }
    
    func start() {
        let organizationCoordinator = GithubOrganizationCoordinator(withTabBarController: tabBarController)
        addChildCoordinator(organizationCoordinator)
        organizationCoordinator.start()
    }
}

