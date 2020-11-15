//
//  Coordinator.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 07/11/20.
//

import Foundation
import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        let found = childCoordinators.contains { (child) -> Bool in
            child === coordinator
        }
        if !found {
            childCoordinators.append(coordinator)
        }
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        for (index, child) in childCoordinators.enumerated() {
            if child === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func navigationBarAppearance() -> UINavigationBarAppearance {
        let navigationBarAppearance = UINavigationBarAppearance()
        let backButtonImage = UIImage(named: "navigationBack")!
        navigationBarAppearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        let barButtonAppearance = UIBarButtonItemAppearance()
        barButtonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: -1000, vertical: 0)
        navigationBarAppearance.backButtonAppearance = barButtonAppearance
        return navigationBarAppearance
    }
}
