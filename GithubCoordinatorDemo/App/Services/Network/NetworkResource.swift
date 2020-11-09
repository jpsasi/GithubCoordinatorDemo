//
//  NetworkResource.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 07/11/20.
//

import Foundation

enum HttpMethod {
    case get, post, put, delete
    
    var name: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        }
    }
}

enum AuthType {
    case basic(userName: String, password: String)
    case token(token: String)
    case none
}

extension AuthType: Equatable {
    static func ==(lhs: AuthType, rhs: AuthType) -> Bool {
        switch (lhs, rhs) {
        case (.basic, .basic): return true
        case (.none, .none): return true
        case (.token, .token): return true
        default: return false
        }
    }
}

class NetworkResponse {
    let statusCode: Int
    let data: Data?
    let urlRequest: URLRequest?
    let httpResponse: HTTPURLResponse?
    let error: Error?
    
    init(statusCode: Int, data: Data, urlRequest: URLRequest, httpResponse: HTTPURLResponse) {
        self.statusCode = statusCode
        self.data = data
        self.urlRequest = urlRequest
        self.httpResponse = httpResponse
        error = nil
    }
    
    init(statusCode: Int, error: Error, urlRequest: URLRequest, httpResponse: HTTPURLResponse) {
        self.statusCode = statusCode
        self.urlRequest = urlRequest
        self.httpResponse = httpResponse
        self.error = error
        self.data = nil
    }
}

enum NetworkError: Error {
    case invalidUrl, invalidResponse, error(Error), clientError(NetworkResponse), serverError(NetworkResponse), unknown, parsingError, rateLimitExceeded
    
    var errorString: String {
        switch self {
        case .invalidUrl:
            return "Invalid Url"
        case .invalidResponse:
            return "Error Response"
        case let .error(error):
            return "\(error.localizedDescription)"
        case let .clientError(response):
            if let error = response.error {
                return "\(error.localizedDescription)"
            } else {
                return "Client error \(response.statusCode)"
            }
        case let .serverError(response):
            if let error = response.error {
                return "\(error.localizedDescription)"
            } else {
                return "Server error \(response.statusCode)"
            }
        case .unknown:
            return "Unknow Error"
        case .parsingError:
            return "Parsing Error"
        case .rateLimitExceeded:
            return "Rate limit exceeded"
        }
    }
}

public enum ParameterEncoding {
    case url, json, form, none, multipart(boundary: String)
}

protocol NetworkResource {
    var baseURL: URL { get }
    var endPoint: String { get }
    var method: HttpMethod { get }
    var headers: [String:String] { get }
    var params: [String:Any] { get }
    var paramsEncoding: ParameterEncoding { get }
    var authType: AuthType { get }
}

extension NetworkResource {
    
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents(string: (baseURL.absoluteString + "/" + endPoint).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        
        if method == .get {
            var queryItems = [URLQueryItem]()
            for (key,value) in params {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                queryItems.append(queryItem)
            }
            
            if queryItems.count > 0 {
                urlComponents?.queryItems = queryItems
            }
        }
        
        if let url = urlComponents?.url {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.name
            
            if headers.count > 0 {
                urlRequest.allHTTPHeaderFields = headers
            }
            
            if method == .post || method == .delete || method == .put {
                
            }
            
            switch authType {
            case let .basic(userName, password):
                let authStr = "\(userName):\(password)"
                let authData = authStr.data(using: .utf8)!
                let encodedString = authData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
                urlRequest.setValue("Basic \(encodedString)", forHTTPHeaderField: "Authorization")
            case let .token(token):
                urlRequest.setValue("\(token)", forHTTPHeaderField: "x-fi-access-token")
            default:
                break
            }
            return urlRequest
        } else {
            return nil
        }
    }
    
    private var encodedParams: Data? {
        switch paramsEncoding {
        case .url:
            var components:[(String,String)] = []
            for key in params.keys.sorted(by: <) {
                if let value = params[key] as? String {
                    components.append((escape(key), escape(value)))
                }
            }
            return components.map { "\($0)=\($1)" }.joined(separator: "&").data(using: .utf8)
        case .json:
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
                return jsonData
            } catch {
                print("json conversion failed")
                return nil
            }
        default:
            return nil
        }
    }
    
    private func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        let escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        return escaped
    }

}


