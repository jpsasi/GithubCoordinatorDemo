//
//  OrganizationListViewController.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 07/11/20.
//

import UIKit

class OrganizationListViewController: UIViewController, Storyboarded {

    var viewModel: OrganizationListViewModel!
    @IBOutlet weak var tableView:UITableView!
    
    deinit {
        print("GithubOrganizationListViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func updateTitle() {
        if viewModel.organizations.count > 0 {
            navigationItem.title = "Organizations (\(viewModel.organizations.count))"
        } else {
            navigationItem.title = "Organizations"
        }
    }
}

extension OrganizationListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.organizations.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == viewModel.organizations.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingIndicatorTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationListCell", for: indexPath) as! OrganizationTableViewCell
            let organization = viewModel.organizations[indexPath.row]
            cell.organization = organization
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
}

extension OrganizationListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.organizations.count {
            viewModel.fetchOrganizationList()
        }
    }
}


extension OrganizationListViewController: OrganizationListViewModelViewDelegate {
    
    func getOrganizationListDidFinish(status: Bool, errorMessage: String?) {
        if let errorMessage = errorMessage {
            showAlert(message: errorMessage)
        } else {
            tableView.reloadData()
            updateTitle()
        }
    }
}
