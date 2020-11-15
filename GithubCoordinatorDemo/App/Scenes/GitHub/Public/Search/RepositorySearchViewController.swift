//
//  RepositorySearchViewController.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 15/11/20.
//

import UIKit

class RepositorySearchViewController: UIViewController, Storyboarded {

    var viewModel: RepositorySearchViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!

    lazy var searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        return searchBar
    }()

    lazy var searchController: UISearchController = {
       let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return navigationController?.topViewController == self
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }

    private func configureUI() {
        navigationItem.titleView = searchBar
    }
    
    private func toggleEmptyView() {
        if viewModel.searchResults.count > 0 {
            emptyLabel.isHidden = true
            tableView.isHidden = false
        } else {
            emptyLabel.isHidden = false
            tableView.isHidden = true
        }
    }
}

extension RepositorySearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toggleEmptyView()
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositorySearchResultCell", for: indexPath)
        return cell
    }
}

extension RepositorySearchViewController: UITableViewDelegate {
    
}

extension RepositorySearchViewController: RepositorySearchViewModelViewDelegate {
    
}

extension RepositorySearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("search Results")
    }
}

extension RepositorySearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text \(searchText)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search button clicked")
    }
}
