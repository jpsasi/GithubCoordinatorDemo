//
//  RepositoryListViewModel.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 08/11/20.
//

import Foundation

protocol RepositoryViewModelCoordinatorDelegate: class {
    func repositoryViewModelDidSelectSearch(viewModel: RepositoryListViewModel)
    func repositoryViewModel(viewModel: RepositoryListViewModel, didSelect repository: Repository)
}

protocol RepositoryViewModelViewDelegate: class {
    func repositoryViewModel(viewModel: RepositoryListViewModel, didFinishLoadingWithStatus status: Bool, errorMessage: String?)
}

class RepositoryListViewModel {
    weak var viewDelegate: RepositoryViewModelViewDelegate?
    weak var coordinatorDelegate: RepositoryViewModelCoordinatorDelegate?
    let repository: GithubRepository
    let dataStore: GithubDataStore
    var isFetching: Bool
    
    var publicRepositories: [Repository] {
        return dataStore.publicRepositories
    }
    
    init(withViewDelegate viewDelegate: RepositoryViewModelViewDelegate,
         coordinatorDelegate: RepositoryViewModelCoordinatorDelegate,
         repository: GithubRepository, dataStore: GithubDataStore) {
        self.viewDelegate = viewDelegate
        self.coordinatorDelegate = coordinatorDelegate
        self.repository = repository
        self.dataStore = dataStore
        isFetching = false
    }
    
    deinit {
        print("PublicRepositoryViewModel deinit")
    }
    
    func getPublicRepositoryList() {
        guard !isFetching else { return }
        repository.fetchPublicRepositoryList { [weak self] (success, error) in
            guard let self = self else { return }
            if success {
                self.viewDelegate?.repositoryViewModel(viewModel: self, didFinishLoadingWithStatus: true, errorMessage: nil)
            } else {
                self.viewDelegate?.repositoryViewModel(viewModel: self, didFinishLoadingWithStatus: false, errorMessage: error?.localizedDescription)
            }
        }
    }
    
    func onSearch() {
        coordinatorDelegate?.repositoryViewModelDidSelectSearch(viewModel: self)
    }

    func onRepositoryDetail(repository: Repository) {
        coordinatorDelegate?.repositoryViewModel(viewModel: self, didSelect: repository)
    }
}
