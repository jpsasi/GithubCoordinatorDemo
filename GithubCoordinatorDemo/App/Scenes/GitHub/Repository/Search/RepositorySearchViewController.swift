//
//  RepositorySearchViewController.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 15/11/20.
//

import UIKit

enum LoadingState {
    case initial, loading, loaded
}

class RepositorySearchViewController: UIViewController, Storyboarded {

    var viewModel: RepositorySearchViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var loadingState: LoadingState = .initial {
        didSet {
            updateLoadingState()
        }
    }
    
    lazy var searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.autocapitalizationType = .none
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.onDismissRepositorySearch()
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
        updateLoadingState()
    }
    
    private func updateEmptyViewState() {
        if viewModel.searchResults.count > 0 {
            emptyLabel.isHidden = true
            tableView.isHidden = false
        } else {
            emptyLabel.isHidden = false
            tableView.isHidden = true
        }
    }
    
    private func updateLoadingState() {
        switch loadingState {
        case .initial:
            emptyLabel.isHidden = false
            tableView.isHidden = true
            loadingIndicator.isHidden = true
        case .loading:
            emptyLabel.isHidden = true
            tableView.isHidden = true
            loadingIndicator.isHidden = false
        case .loaded:
            updateEmptyViewState()
            loadingIndicator.isHidden = true
        }
    }
}

extension RepositorySearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepositorySearchResultCell", for: indexPath) as! RepositoryTableViewCell
            let repository = viewModel.searchResults[indexPath.row]
            cell.repository = repository
            cell.accessoryType = .disclosureIndicator
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
        loadingState = .loaded
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
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            if let searchText = searchTextField.text, searchText.count > 2 {
                loadingState = .loading
                viewModel.fetchSearchRepository()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }
}
