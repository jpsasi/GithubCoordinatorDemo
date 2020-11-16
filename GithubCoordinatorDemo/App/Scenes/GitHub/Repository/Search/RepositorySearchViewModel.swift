//
//  RepositorySearchViewModel.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 15/11/20.
//

import Foundation

protocol RepositorySearchViewModelCoordinatorDelegate: class {
    func repositorySearchViewModelDidFinish(viewModel: RepositorySearchViewModel)
    func repositorySearchViewModel(viewModel: RepositorySearchViewModel, didSelect repository: Repository)
}

protocol RepositorySearchViewModelViewDelegate: class {
    func repositorySearchViewModel(viewModel: RepositorySearchViewModel, didFinishSearchWithStatus status: Bool, errorMessage: String?)
}

class RepositorySearchViewModel {
    weak var viewDelegate: RepositorySearchViewModelViewDelegate?
    weak var coordinatorDelegate: RepositorySearchViewModelCoordinatorDelegate?
    let repository: GithubRepository
    let perPage: Int = 20
    var page: Int {
        return searchResults.count / perPage
    }
    var isFetching: Bool
    var queryString: String = "" {
        didSet {
            if queryString.count == 0 {
                searchResults.removeAll()
            }
        }
    }
    var searchResults:[Repository] = [] {
        didSet {
            self.viewDelegate?.repositorySearchViewModel(viewModel: self, didFinishSearchWithStatus: true, errorMessage: nil)
        }
    }
    
    init(withViewDelegate viewDelegate: RepositorySearchViewModelViewDelegate,
         coordinatorDelegate: RepositorySearchViewModelCoordinatorDelegate,
         repository: GithubRepository) {
        self.viewDelegate = viewDelegate
        self.coordinatorDelegate = coordinatorDelegate
        self.repository = repository
        isFetching = false
    }

    func fetchSearchRepository() {
        guard !isFetching else { return }
        isFetching = true
        repository.fetchSearchRepository(searchQuery: queryString, perPage: perPage, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(repositories):
                self.searchResults.append(contentsOf: repositories)
            case let .failure(error):
                self.viewDelegate?.repositorySearchViewModel(viewModel: self, didFinishSearchWithStatus: false, errorMessage: error.localizedDescription)
            }
            self.isFetching = false
        }
    }
    
    func onDismissRepositorySearch() {
        coordinatorDelegate?.repositorySearchViewModelDidFinish(viewModel: self)
    }
    
    func onRepositoryDetail(repository: Repository) {
        coordinatorDelegate?.repositorySearchViewModel(viewModel: self, didSelect: repository)
    }
}
