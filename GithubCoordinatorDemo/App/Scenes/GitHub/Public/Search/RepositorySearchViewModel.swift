//
//  RepositorySearchViewModel.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 15/11/20.
//

import Foundation

protocol RepositorySearchViewModelCoordinatorDelegate: class {
    
}

protocol RepositorySearchViewModelViewDelegate: class {
    
}

class RepositorySearchViewModel {
    weak var viewDelegate: RepositorySearchViewModelViewDelegate?
    weak var coordinatorDelegate: RepositorySearchViewModelCoordinatorDelegate?
    let repository: GithubRepository
    
    var searchResults:[Int] = []
    
    init(withViewDelegate viewDelegate: RepositorySearchViewModelViewDelegate,
         coordinatorDelegate: RepositorySearchViewModelCoordinatorDelegate,
         repository: GithubRepository) {
        self.viewDelegate = viewDelegate
        self.coordinatorDelegate = coordinatorDelegate
        self.repository = repository
    }

}
