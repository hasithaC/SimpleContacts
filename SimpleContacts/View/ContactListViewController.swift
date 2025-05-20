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
    
    private var viewModel = ContactListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Simple Contacts"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        view.addSubview(contactsTable)
        contactsTable.frame = view.bounds
        
        contactsTable.dataSource = self
        contactsTable.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        bindViewModel()
        viewModel.fetchContacts()
    }
    
    @objc func addButtonTapped(){
        let formVC = ContactFormViewController()
        formVC.modalPresentationStyle = .overFullScreen
        formVC.modalTransitionStyle = .crossDissolve
        
        self.present(formVC, animated: true)
    }
    
    private func bindViewModel() {
        viewModel.onContactsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.contactsTable.reloadData()
            }
        }
        viewModel.onError = { error in
            print("Failed to load contacts:", error.localizedDescription)
        }
        
        viewModel.onContactDeleted = { [weak self] indexPath in
            DispatchQueue.main.async {
                self?.contactsTable.deleteRows(at: [indexPath], with: .fade)
            }
        }
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
            viewModel.deleteContact(indexPath: indexPath)
        default:
            break;
        }
    }
}
