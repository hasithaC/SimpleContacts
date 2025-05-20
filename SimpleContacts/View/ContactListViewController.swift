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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        view.backgroundColor = .systemBackground
        view.addSubview(contactsTable)
        contactsTable.frame = view.bounds
        
        contactsTable.dataSource = self
        contactsTable.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension ContactListViewController {
    @objc func addButtonTapped(){
        DispatchQueue.main.async {
            let formVC = ContactFormViewController()
            formVC.modalPresentationStyle = .overFullScreen
            formVC.modalTransitionStyle = .crossDissolve
            
            self.present(formVC, animated: true)
        }
    }
}

extension ContactListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text = viewModel.contacts[indexPath.row].name
        return cell
    }
}

class PopupViewController: UIViewController {
  var dismissHandler: (() -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Customize the appearance of the view here
    view.backgroundColor = .white
  }

  @IBAction func dismissButtonTapped(_ sender: Any) {
    dismissHandler?()
    dismiss(animated: true, completion: nil)
  }
}
