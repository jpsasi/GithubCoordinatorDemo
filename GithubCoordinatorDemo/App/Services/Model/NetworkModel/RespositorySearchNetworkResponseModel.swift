//
//  RespositorySearchNetworkResponseModel.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 15/11/20.
//

import Foundation

struct RespositorySearchNetworkResponseModel: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]
}
