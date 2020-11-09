//
//  PublicRepositoryViewController.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 08/11/20.
//

import UIKit

class PublicRepositoryViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: PublicRepositoryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getPublicRepositoryList()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Repositories"
    }
    
    func updateTitle() {
        title = "Repositories (\(viewModel.publicRepositories.count))"
    }
}

extension PublicRepositoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.publicRepositories.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == viewModel.publicRepositories.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PublicRepositoryLoadingCell", for: indexPath) as! LoadingIndicatorTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PublicRepositoryCell", for: indexPath) as! PublicRepositoryTableViewCell
            let repository = viewModel.publicRepositories[indexPath.row]
            cell.repository = repository
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
}

extension PublicRepositoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.publicRepositories.count {
//            viewModel.fetchPublicRepositoryList()
        }
    }
}

extension PublicRepositoryViewController: PublicRepositoryViewModelViewDelegate {
    
    func getPublicRepositoryListDidFinish(status: Bool, errorMessage: String?) {
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
