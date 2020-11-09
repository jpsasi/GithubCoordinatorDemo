//
//  Storyboarded.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 07/11/20.
//

import UIKit

protocol Storyboarded: class {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate() -> Self {
        let storyboardName = String(describing: self)
        return instantiate(storyboardName)
    }
    
    static func instantiate(_ storyboardName: String) -> Self {
        let bundle = Bundle(for: Self.self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(identifier: identifier) as! Self
    }
}
