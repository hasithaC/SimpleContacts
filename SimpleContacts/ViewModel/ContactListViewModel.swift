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
    
    func numberOfContacts() -> Int {
        return contacts.count
    }
    
    func contactName(at index: Int) -> String {
        return contacts[index].contact_name ?? ""
    }
}
