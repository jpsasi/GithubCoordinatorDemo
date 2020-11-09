//
//  RepositoryListViewModel.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 07/11/20.
//

import Foundation

protocol RepositoryListCoordinatorDelegate: class {
    
}

protocol RepositoryListViewDelegate: class {
    
}

class GithubRepositoryListViewModel {
    weak var coordinatorDelegate: RepositoryListCoordinatorDelegate?
    weak var viewDelegate: RepositoryListViewDelegate?
    
    init(withViewDelegate viewDelegate: RepositoryListViewDelegate, coordinatorDelegate: RepositoryListCoordinatorDelegate) {
        self.viewDelegate = viewDelegate
        self.coordinatorDelegate = coordinatorDelegate
    }
}
