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
        searchBar.becomeFirstResponder()
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
        if viewModel.searchResults.count > 0 {
            return viewModel.searchResults.count + 1
        }
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == viewModel.searchResults.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingIndicatorTableViewCell", for: indexPath) as! LoadingIndicatorTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepositorySearchResultCell", for: indexPath) as! PublicRepositoryTableViewCell
            let repository = viewModel.searchResults[indexPath.row]
            cell.repository = repository
            return cell
        }
    }
}

extension RepositorySearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.searchResults.count > 0 && indexPath.row == viewModel.searchResults.count {
            viewModel.fetchSearchRepository()
        }
    }
}

extension RepositorySearchViewController: RepositorySearchViewModelViewDelegate {
    
    func repositorySearchViewModel(viewModel: RepositorySearchViewModel, didFinishSearchWithStatus status: Bool, errorMessage: String?) {
        tableView.reloadData()
    }
}

extension RepositorySearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("search Results")
    }
}

extension RepositorySearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.queryString = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search button clicked")
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            if let searchText = searchTextField.text, searchText.count > 2 {
                viewModel.fetchSearchRepository()
            }
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel button tapped")
    }
}
