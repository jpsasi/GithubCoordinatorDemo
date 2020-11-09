//
//  Decodable.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 07/11/20.
//

import Foundation

extension Decodable {
    
    static func modelObject(fromString jsonString: String) -> Self? {
        return modelObject(fromData: jsonString.data(using: .utf8)!)
    }
    
    static func modelObject(fromData data: Data) -> Self? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(self, from: data)
        } catch {
            print("parsing error \(error)")
            do {
                if let obj = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? String {
                    return try decoder.decode(self, from: obj.data(using: .utf8)!)
                }
            } catch {
                print("parsing error \(error)")
            }
        }
        return nil
    }
}
