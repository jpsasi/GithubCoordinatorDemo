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
    case searchRepository(text: String, perPage: Int, page: Int)
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var endPoint: String {
        switch self {
        case .organization:
            return "organizations"
        case .publicRepository:
            return "repositories"
        case .searchRepository:
            return "search/repositories"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .organization:
            return .get
        case .publicRepository:
            return .get
        case .searchRepository:
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
        case let .searchRepository(text: text, perPage: perPage, page: page):
            return ["q": text, "per_page": perPage, "page": page]
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
    
    init(webService: WebService = WebService()) {
        self.webService = webService
    }
    
    func fetchOrganizations(since: Int = 0, numberOfRecords: Int, completion: @escaping (Result<[Organization], NetworkError>) -> Void) {
        let networkResource = GithubNetworkResource.organization(since: since, perPage: numberOfRecords)
        githubApiCall(networkResource: networkResource, model: [Organization].self, completion: completion)
    }
    
    func fetchPublicRepositories(since: Int = 0, numberOfRecords: Int, completion: @escaping (Result<[Repository], NetworkError>) -> Void) {
        let networkResource = GithubNetworkResource.publicRepository(since: since, perPage: numberOfRecords)
        githubApiCall(networkResource: networkResource, model: [Repository].self, completion: completion)
    }

    func searchRepository(queryString: String, perPage: Int = 20, page: Int = 0, completion: @escaping (Result<[Repository], NetworkError>) -> Void) {
        let networkResource = GithubNetworkResource.searchRepository(text: queryString, perPage: perPage, page: page)
        githubApiCall(networkResource: networkResource, model: RespositorySearchNetworkResponseModel.self) { result in
            switch result {
            case let .success(responseModel):
                completion(Result.success(responseModel.items))
            case let .failure(error):
                completion(Result.failure(error))
            }
        }
    }
    
    private func parse<T:Codable>(jsonData data: Data, modalType: T.Type) -> T? {
        return modalType.modelObject(fromData: data)
    }

    private func githubApiCall<T:Codable>(networkResource: GithubNetworkResource, model: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        webService.load(networkResource: networkResource) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                switch response.statusCode {
                case 200:
                    if let data = response.data {
                        if let modelObject = self.parse(jsonData: data, modalType: model.self) {
                            DispatchQueue.main.async {
                                completion(Result.success(modelObject))
                            }
                        } else {
                            DispatchQueue.main.async {
                                completion(Result.failure(.parsingError))
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(Result.failure(.invalidResponse))
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
