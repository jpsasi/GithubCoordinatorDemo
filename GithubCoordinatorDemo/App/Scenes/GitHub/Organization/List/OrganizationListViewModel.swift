//
//  OrganizationListViewModel.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 07/11/20.
//

import Foundation

protocol OrganizationListViewModelCoordinatorDelegate: class {
    
}

protocol OrganizationListViewModelViewDelegate: class {
    func getOrganizationListDidFinish(status: Bool, errorMessage: String?)
}

class OrganizationListViewModel {
    weak var viewDelegate: OrganizationListViewModelViewDelegate?
    weak var coordinatorDelegate: OrganizationListViewModelCoordinatorDelegate?
    let repository: GithubRepository
    let dataStore: GithubDataStore
    var isFetching: Bool
    
    var organizations: [Organization] {
        return dataStore.organizations
    }
    
    init(withViewDelegate viewDelegate: OrganizationListViewModelViewDelegate,
         coordinatorDelegate: OrganizationListViewModelCoordinatorDelegate,
         repository: GithubRepository, dataStore: GithubDataStore) {
        self.viewDelegate = viewDelegate
        self.coordinatorDelegate = coordinatorDelegate
        self.repository = repository
        self.dataStore = dataStore
        isFetching = false
    }
    
    deinit {
        print("GithubRepositoryListViewModel deinit")
    }
    
    func fetchOrganizationList() {
        guard !isFetching else { return }
        repository.fetchOrganizationList { [weak self] (success, error) in
            guard let self = self else { return }
            if success {
                self.viewDelegate?.getOrganizationListDidFinish(status: true, errorMessage: nil)
            } else {
                self.viewDelegate?.getOrganizationListDidFinish(status: false, errorMessage: error?.localizedDescription)
            }
        }
    }
}
