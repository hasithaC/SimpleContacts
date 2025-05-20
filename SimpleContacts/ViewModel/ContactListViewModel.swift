//
//  ContactListViewModel.swift
//  SimpleContacts
//
//  Created by Hasitha Chamupathi on 2025-05-19.
//

import Foundation

class ContactListViewModel {
    
    private(set) var contacts: [ContactItem] = []
    
    var onContactsUpdated: (() -> Void)?
    var onContactDeleted: ((IndexPath) -> Void)?
    var onError: ((Error) -> Void)?
    
    func fetchContacts() {
        DataPersistenceManager.shared.fetchContactItems { [weak self] result in
            switch result {
            case .success(let contactItems):
                self?.contacts = contactItems
                self?.onContactsUpdated?()
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
    func deleteContact(indexPath: IndexPath){
        let contact = contacts[indexPath.row]
        DataPersistenceManager.shared.deleteContact(contact: contact) { [weak self] result in
            switch result {
            case .success:
                self?.contacts.remove(at: indexPath.row)
                self?.onContactDeleted?(indexPath)
                print("Successfully Deleted")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func numberOfContacts() -> Int {
        return contacts.count
    }
    
    func contactName(at index: Int) -> String {
        return contacts[index].contact_name ?? ""
    }
}
