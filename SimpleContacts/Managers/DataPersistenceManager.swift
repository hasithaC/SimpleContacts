//
//  DataPersistenceManager.swift
//  SimpleContacts
//
//  Created by Hasitha Chamupathi on 2025-05-20.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    
    enum DataPersistenceError: Error {
        case failedToSave
        case failedToFetch
        case failedToDelete
        case failedToUpdate
    }
    
    func saveContact(model: Contact, completion: @escaping (Result<Void, Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let item = ContactItem(context: context)
        
        item.id = model.id
        item.contact_name = model.name
        item.contact_number = model.phoneNumber
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DataPersistenceError.failedToSave))
        }
    }
    
    func fetchContactItems(completion: @escaping(Result<[ContactItem], Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<ContactItem>
        request = ContactItem.fetchRequest()
        
        do{
            let contactItems = try context.fetch(request)
            completion(.success(contactItems))
        }catch{
            completion(.failure(DataPersistenceError.failedToFetch))
        }
    }
    
    func deleteContact(contact: ContactItem, completion: @escaping(Result<Void, Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(contact)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DataPersistenceError.failedToDelete))
        }
    }
    
    func updateContact(item: ContactItem, model: Contact, completion: @escaping(Result<Void, Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        item.contact_name = model.name
        item.contact_number = model.phoneNumber
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DataPersistenceError.failedToUpdate))
        }
    }
}
