//
//  AppCoordinator.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 07/11/20.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    lazy var tabBarController: UITabBarController = {
        return UITabBarController()
    }()
    
    deinit {
        print("AppCoordinator deinit")
    }
    
    func start() {
        let repositoryCoordinator = GithubCoordinator(withTabBarController: tabBarController, repository: GithubRepository(), dataStore: GithubDataStore.shared)
        addChildCoordinator(repositoryCoordinator)
        
        repositoryCoordinator.start()
    }

}
