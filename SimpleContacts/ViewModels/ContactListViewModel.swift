//
//  ContactListViewModel.swift
//  SimpleContacts
//
//  Created by Hasitha Chamupathi on 2025-05-19.
//

import Foundation

class ContactListViewModel {
    
    private(set) var contacts: [ContactItem] = []
    private(set) var filteredContacts: [ContactItem] = []
    private(set) var isSearching = false
        
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
        let contact = currentContacts()[indexPath.row]
        DataPersistenceManager.shared.deleteContact(contact: contact) { [weak self] result in
            switch result {
            case .success:
                guard let isSearching = self?.isSearching else {
                    return
                }
                
                if  (isSearching)  {
                    self?.filteredContacts.remove(at: indexPath.row)
                }
                
                if let index = self?.contacts.firstIndex(where: { $0.id == contact.id }) {
                    self?.contacts.remove(at: index)
                }
                completion(.success(indexPath))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func numberOfContacts() -> Int {
        return currentContacts().count
    }
    
    func contactName(at index: Int) -> String {
        return currentContacts()[index].contact_name ?? ""
    }
    
    func contact(at index: Int) -> ContactItem {
        return currentContacts()[index]
    }
    
    private func currentContacts() -> [ContactItem] {
        return isSearching ? filteredContacts : contacts
    }
    
    func filterContacts(text: String?, completion: @escaping (Bool) -> Void) {
        guard let filter = text, !filter.isEmpty else {
            filteredContacts.removeAll()
            isSearching = false
            completion(false)
            return
        }

        isSearching = true
        filteredContacts = contacts.filter { contact in
            contact.contact_name?.lowercased().contains(filter.lowercased()) ?? false
        }
        completion(true)
    }

}
