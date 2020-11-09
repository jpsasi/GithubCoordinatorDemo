//
//  Organization.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 07/11/20.
//

import Foundation

struct Organization : Codable {
    let login: String
    let id: Int
    let nodeId: String
    let reposUrl: String
    let url: String
    let eventsUrl: String
    let hooksUrl: String
    let issuesUrl: String
    let membersUrl: String
    let publicMembersUrl: String
    let avatarUrl: String
    let description: String?
}
