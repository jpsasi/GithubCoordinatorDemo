//
//  RepositoryListViewController.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 07/11/20.
//

import UIKit

class GithubRepositoryListViewController: UIViewController, Storyboarded {

    var viewModel: GithubRepositoryListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension GithubRepositoryListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath)
        return cell
    }
    
}

extension GithubRepositoryListViewController: UITableViewDelegate {
    
}
