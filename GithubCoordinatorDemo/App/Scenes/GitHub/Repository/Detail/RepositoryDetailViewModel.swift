//
//  RepositoryDetailViewModel.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 16/11/20.
//

import Foundation

protocol RepositoryDetailViewModelCoordinatorDelegate: class {
    func repositoryDetailViewModelDidDismissRepositoryDetail(viewModel: RepositoryDetailViewModel)
}

protocol RepositoryDetailViewModelViewDelegate: class {
    
}

class RepositoryDetailViewModel {
    weak var viewDelegate: RepositoryDetailViewModelViewDelegate?
    weak var coordinatorDelegate: RepositoryDetailViewModelCoordinatorDelegate?
    let repository: GithubRepository
    let selectedRepository: Repository
    
    init(selectedRepository: Repository,
         viewDelegate: RepositoryDetailViewModelViewDelegate,
         coordinatorDelegate: RepositoryDetailViewModelCoordinatorDelegate,
         repository: GithubRepository) {
        self.selectedRepository = selectedRepository
        self.viewDelegate = viewDelegate
        self.coordinatorDelegate = coordinatorDelegate
        self.repository = repository
    }
    
    func onDismiss() {
        coordinatorDelegate?.repositoryDetailViewModelDidDismissRepositoryDetail(viewModel: self)
    }
}
