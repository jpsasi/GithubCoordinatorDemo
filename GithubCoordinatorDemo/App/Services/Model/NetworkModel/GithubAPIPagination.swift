//
//  GithubAPIPagination.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 08/11/20.
//

import Foundation

struct GithubAPIPagination {
    let next: URL?
    let last: URL?
    let first: URL?
    let prev: URL?
    
    let link: String
    
    init(link: String) {
        self.link = link
        
        
        next = nil
        last = nil
        first = nil
        prev = nil
    }
}


