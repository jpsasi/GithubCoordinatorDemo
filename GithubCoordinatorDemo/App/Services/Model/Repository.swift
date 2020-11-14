//
//  Repository.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 08/11/20.
//

import Foundation

struct Repository : Codable {
    let id: Int
    let nodeId: String
    let name: String
    let fullName: String
    let `private`: Bool
    let description: String?
    let owner: Owner
    
    struct Owner : Codable {
        let login: String
        let id: Int
        let avatarUrl: String
        let type: String
        let siteAdmin: Bool
    }
}
