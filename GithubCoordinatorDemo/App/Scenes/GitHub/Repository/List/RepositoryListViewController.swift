//
//  RepositoryViewController.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 08/11/20.
//

import UIKit

class RepositoryListViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: RepositoryListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(onSearch(sender:)))
    }

    private func updateTitle() {
        if viewModel.publicRepositories.count > 0 {
            navigationItem.title = "Repositories (\(viewModel.publicRepositories.count))"
        } else {
            navigationItem.title = "Repositories"
        }
    }
    
    @objc func onSearch(sender: AnyObject) {
        viewModel.onSearch()
    }
}

extension RepositoryListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.publicRepositories.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == viewModel.publicRepositories.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryLoadingCell", for: indexPath) as! LoadingIndicatorTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as! RepositoryTableViewCell
            let repository = viewModel.publicRepositories[indexPath.row]
            cell.repository = repository
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
}

extension RepositoryListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.publicRepositories.count {
            viewModel.getPublicRepositoryList()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = viewModel.publicRepositories[indexPath.row]
        viewModel.onRepositoryDetail(repository: repository)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RepositoryListViewController: RepositoryViewModelViewDelegate {
    
    func repositoryViewModel(viewModel: RepositoryListViewModel, didFinishLoadingWithStatus status: Bool, errorMessage: String?) {
        if let errorMessage = errorMessage {
            showAlert(message: errorMessage)
        } else {
            tableView.reloadData()
            updateTitle()
        }
    }
}

extension UIViewController {
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Public Repository", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
