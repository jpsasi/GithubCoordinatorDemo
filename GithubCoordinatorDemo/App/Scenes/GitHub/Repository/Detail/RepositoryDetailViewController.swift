//
//  RepositoryDetailViewController.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 16/11/20.
//

import UIKit

class RepositoryDetailViewController: UIViewController, Storyboarded {

    var viewModel: RepositoryDetailViewModel!
        
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return navigationController?.topViewController == self
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = viewModel.selectedRepository.name
    }
}

extension RepositoryDetailViewController: RepositoryDetailViewModelViewDelegate {
    
}
