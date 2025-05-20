//
//  ContactListViewModel.swift
//  SimpleContacts
//
//  Created by Hasitha Chamupathi on 2025-05-19.
//

import Foundation

class ContactListViewModel {
    
    private(set) var contacts: [ContactItem] = []
        
    func fetchContacts(completion: @escaping(Result<Void, Error>)->Void) {
        DataPersistenceManager.shared.fetchContactItems { [weak self] result in
            switch result {
            case .success(let contactItems):
                self?.contacts = contactItems
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteContact(at indexPath: IndexPath, completion: @escaping(Result<IndexPath, Error>)->Void){
        let contact = contacts[indexPath.row]
        DataPersistenceManager.shared.deleteContact(contact: contact) { [weak self] result in
            switch result {
            case .success:
                self?.contacts.remove(at: indexPath.row)
                completion(.success(indexPath))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func numberOfContacts() -> Int {
        return contacts.count
    }
    
    func contactName(at index: Int) -> String {
        return contacts[index].contact_name ?? ""
    }
    
    func contact(at index: Int) -> ContactItem {
        return contacts[index]
    }
}
