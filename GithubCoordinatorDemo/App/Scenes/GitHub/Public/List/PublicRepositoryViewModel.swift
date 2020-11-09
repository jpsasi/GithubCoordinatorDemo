//
//  PublicRepositoryViewModel.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 08/11/20.
//

import Foundation

protocol PublicRepositoryViewModelCoordinatorDelegate: class {
    
}

protocol PublicRepositoryViewModelViewDelegate: class {
    func getPublicRepositoryListDidFinish(status: Bool, errorMessage: String?)
}

class PublicRepositoryViewModel {
    weak var viewDelegate: PublicRepositoryViewModelViewDelegate?
    weak var coordinatorDelegate: PublicRepositoryViewModelCoordinatorDelegate?
    let repository: GithubRepository
    let dataStore: GithubDataStore
    var isFetching: Bool
    
    var publicRepositories: [Repository] {
        return dataStore.publicRepositories
    }
    
    init(withViewDelegate viewDelegate: PublicRepositoryViewModelViewDelegate,
         coordinatorDelegate: PublicRepositoryViewModelCoordinatorDelegate,
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
                self.viewDelegate?.getPublicRepositoryListDidFinish(status: true, errorMessage: nil)
            } else {
                self.viewDelegate?.getPublicRepositoryListDidFinish(status: false, errorMessage: error?.localizedDescription)
            }
        }
    }

}
