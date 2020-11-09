//
//  GithubDatastore.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 08/11/20.
//

import Foundation

class GithubDataStore {
    
    static var shared = GithubDataStore()
    
    var organizations: [Organization] = []
    var publicRepositories: [Repository] = []
}
