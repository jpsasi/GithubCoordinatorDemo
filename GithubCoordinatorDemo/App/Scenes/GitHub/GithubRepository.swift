//
//  GithubRepository.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 07/11/20.
//

import Foundation

class GithubRepository {
    let webService: GithubWebService
    let dataStore: GithubDataStore
    
    init(withWebService webService: GithubWebService = GithubWebService(), dataStore: GithubDataStore = .shared) {
        self.webService = webService
        self.dataStore = dataStore
    }
        
    func fetchOrganizationList(completion: @escaping (Bool, NetworkError?) -> Void) {
        if let lastRecord = dataStore.organizations.last {
            webService.fetchOrganizations(since: lastRecord.id, numberOfRecords: 30) { [weak self] result in
                guard let self = self else { return }
                self.processOrganizationListResult(result: result, completion: completion)
            }
        } else {
            webService.fetchOrganizations(numberOfRecords: 30) { [weak self] result in
                guard let self = self else { return }
                self.processOrganizationListResult(result: result, completion: completion)
            }
        }
    }
    
    func fetchPublicRepositoryList(completion: @escaping (Bool, NetworkError?) -> Void) {
        if let lastRecord = dataStore.organizations.last {
            webService.fetchPublicRepositories(since: lastRecord.id, numberOfRecords: 30) { [weak self] result in
                guard let self = self else { return }
                self.processPublicRepositoryListResult(result: result, completion: completion)
            }
        } else {
            webService.fetchPublicRepositories(numberOfRecords: 30) { [weak self] result in
                guard let self = self else { return }
                self.processPublicRepositoryListResult(result: result, completion: completion)
            }
        }
    }

}

//MARK: Private Methods
extension GithubRepository {
    
    private func processOrganizationListResult(result: Result<[Organization], NetworkError>, completion: (Bool, NetworkError?) -> Void) {
        switch result {
        case let .success(organizations):
            self.dataStore.organizations.append(contentsOf: organizations)
            completion(true, nil)
        case let .failure(error):
            completion(false, error)
        }
    }
    
    private func processPublicRepositoryListResult(result: Result<[Repository], NetworkError>, completion: (Bool, NetworkError?) -> Void) {
        switch result {
        case let .success(repositories):
            self.dataStore.publicRepositories.append(contentsOf: repositories)
            completion(true, nil)
        case let .failure(error):
            completion(false, error)
        }
    }
}
