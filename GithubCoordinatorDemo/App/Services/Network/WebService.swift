//
//  WebService.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 07/11/20.
//

import Foundation

class WebService {
    let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func load(networkResource: NetworkResource, completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
        guard let urlRequest = networkResource.urlRequest else {
            completion(Result.failure(NetworkError.invalidUrl))
            return
        }
     
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                if let error = error {
                    completion(Result.failure(NetworkError.error(error)))
                } else {
                    completion(Result.failure(NetworkError.invalidResponse))
                }
                return
            }
            let networkResponse: NetworkResponse!
            if let data = data {
                networkResponse = NetworkResponse(statusCode: httpResponse.statusCode, data: data, urlRequest: urlRequest, httpResponse: httpResponse)
            } else if let error = error {
                networkResponse = NetworkResponse(statusCode: httpResponse.statusCode, error: error, urlRequest: urlRequest, httpResponse: httpResponse)
            } else {
                networkResponse = NetworkResponse(statusCode: httpResponse.statusCode, error: NetworkError.invalidResponse, urlRequest: urlRequest, httpResponse: httpResponse)
            }
            switch httpResponse.statusCode {
            case 200..<299:
                completion(Result.success(networkResponse))
            case 400..<499:
                completion(Result.failure(NetworkError.clientError(networkResponse)))
            case 500..<599:
                completion(Result.failure(NetworkError.serverError(networkResponse)))
            default:
                completion(Result.failure(NetworkError.unknown))
            }
        }
        .resume()
    }
}
