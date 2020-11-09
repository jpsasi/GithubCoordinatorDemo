//
//  GithubWebService.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 07/11/20.
//

import Foundation

enum GithubNetworkResource: NetworkResource {
    case organization(since: Int, perPage: Int)
    case publicRepository(since: Int, perPage: Int)
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var endPoint: String {
        switch self {
        case .organization:
            return "organizations"
        case .publicRepository:
            return "repositories"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .organization:
            return .get
        case .publicRepository:
            return .get
        }
    }
    
    var headers: [String : String] {
        return ["accept":"application/vnd.github.v3+json"]
    }
    
    var params: [String : Any] {
        switch self {
        case let .organization(since: since, perPage: perPage):
            return ["per_page": perPage, "since": since]
        case let .publicRepository(since: since, perPage: perPage):
            return ["per_page": perPage, "since": since]
        }
    }
    
    var paramsEncoding: ParameterEncoding {
        return .none
    }
    
    var authType: AuthType {
        return .none
    }
}

class GithubWebService {
    let webService: WebService
    var organizationPagination: GithubAPIPagination?
    
    init(webService: WebService = WebService()) {
        self.webService = webService
    }
    
    func fetchOrganizations(since: Int = 0, numberOfRecords: Int, completion: @escaping (Result<[Organization], NetworkError>) -> Void) {
        let networkResource = GithubNetworkResource.organization(since: since, perPage: numberOfRecords)
        webService.load(networkResource: networkResource) { (result) in
            switch result {
            case let .success(response):
                switch response.statusCode {
                case 200:
                    if let data = response.data, let model = [Organization].modelObject(fromData: data) {
                        DispatchQueue.main.async {
                            completion(Result.success(model))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(Result.failure(.parsingError))
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        completion(Result.failure(.invalidResponse))
                    }
                }
            case let .failure(error):
                DispatchQueue.main.async {                    
                    completion(Result.failure(.error(error)))
                }
            }
        }
    }
    
    func fetchPublicRepositories(since: Int = 0, numberOfRecords: Int, completion: @escaping (Result<[Repository], NetworkError>) -> Void) {
        let networkResource = GithubNetworkResource.publicRepository(since: since, perPage: numberOfRecords)
        webService.load(networkResource: networkResource) { (result) in
            switch result {
            case let .success(response):
                switch response.statusCode {
                case 200:
                    if let data = response.data, let model = [Repository].modelObject(fromData: data) {
                        DispatchQueue.main.async {
                            completion(Result.success(model))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(Result.failure(.parsingError))
                        }
                    }
                case 403:
                    DispatchQueue.main.async {
                        completion(Result.failure(.rateLimitExceeded))
                    }
                default:
                    DispatchQueue.main.async {
                        completion(Result.failure(.invalidResponse))
                    }
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    completion(Result.failure(.error(error)))
                }
            }
        }

    }
}
