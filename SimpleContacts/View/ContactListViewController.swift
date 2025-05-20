//
//  ViewController.swift
//  SimpleContacts
//
//  Created by Hasitha Chamupathi on 2025-05-18.
//

import UIKit

class ContactListViewController: UIViewController {
    
    private let contactsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController()
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search for a name"
        return controller
    }()

    private var viewModel = ContactListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Simple Contacts"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        view.addSubview(contactsTable)
        contactsTable.frame = view.bounds
        
        contactsTable.dataSource = self
        contactsTable.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        viewModel.fetchContacts { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.contactsTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func addButtonTapped(){
        let formVC = ContactFormViewController()
        formVC.delegate = self
        formVC.modalPresentationStyle = .overFullScreen
        formVC.modalTransitionStyle = .crossDissolve
        
        self.present(formVC, animated: true)
    }
}

extension ContactListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfContacts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.contactName(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
            viewModel.deleteContact(at: indexPath) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.contactsTable.deleteRows(at: [indexPath], with: .fade)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let formVC = ContactFormViewController()
        formVC.delegate = self
        formVC.modalPresentationStyle = .overFullScreen
        formVC.modalTransitionStyle = .crossDissolve
        formVC.contact = viewModel.contact(at: indexPath.row)
        
        self.present(formVC, animated: true)
    }
}

extension ContactListViewController: ContactFormViewControllerDelegate {
    func didUpdateContacts() {
        viewModel.fetchContacts { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.contactsTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ContactListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterContacts(text: searchController.searchBar.text) { [weak self] isSearching in
            if isSearching {
                DispatchQueue.main.async {
                    self?.contactsTable.reloadData()
                }
            }else {
                self?.viewModel.fetchContacts { result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self?.contactsTable.reloadData()
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
}
