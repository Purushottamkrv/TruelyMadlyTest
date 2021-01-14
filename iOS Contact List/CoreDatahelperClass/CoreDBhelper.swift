//
//  CoreDBhelper.swift
//  iOS Contact List
//
//  Created by Purushottam on 12/01/21.
//  Copyright © 2021 Purushottam. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDBhelper {
    
    static let shared = CoreDBhelper()
    private init(){}
    
    func saveCategoryDataToCoreDB(contactListArray : [ContactData]) {
        
        let appdelegate  = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ContactList", in: context)
        
        
        for object in contactListArray {
            
            print("object is",object)
            
            let newCategory = NSManagedObject(entity: entity!, insertInto: context)
            newCategory.setValue(object.name, forKey: "name")
            newCategory.setValue(object.contact, forKey: "contact")
            newCategory.setValue(object.email, forKey: "email")
            newCategory.setValue(object.image, forKey: "image")
            newCategory.setValue(object.contactId, forKey: "id")


            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
        
    }
    
    
    
    
    func getDataFromDb(listName : String) -> [NSManagedObject]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: listName)
        let context = appDelegate.persistentContainer.viewContext
        var result = [NSManagedObject]()
        request.returnsObjectsAsFaults = false
        do {
            result = try context.fetch(request) as! [NSManagedObject]
            
            return result
        } catch {
            print("Failed")
        }
        return result
    }
    
    
    
    
    
    
    
    func updateDataFromDb(listName : String,conntactData:ContactData) {

             //As we know that container is set up in the AppDelegates so we need to refer that container.
             guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
             
             //We need to create a context from this container
             let managedContext = appDelegate.persistentContainer.viewContext
             
             let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: listName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", conntactData.contactId)
             do
             {
                 let test = try managedContext.fetch(fetchRequest)
        
                     let objectUpdate = test[0] as! NSManagedObject
                     objectUpdate.setValue(conntactData.name, forKey: "name")
                     objectUpdate.setValue(conntactData.email, forKey: "email")
                     objectUpdate.setValue(conntactData.contact, forKey: "contact")
                     objectUpdate.setValue(conntactData.image, forKey: "image")
                objectUpdate.setValue(conntactData.contactId, forKey: "id")
                                        
                     do{
                         try managedContext.save()
                     }
                     catch
                     {
                         print(error)
                     }
                 }
             catch
             {
                 print(error)
             }
        
        
        
    }
    
    
    
    func convertDBDataToDBUser(object : [NSManagedObject]) -> [ContactData] {

        var tempData = [ContactData]()
        for object in object {
            let contactName = object.value(forKey: "name") as? String ?? ""
            let email = object.value(forKey: "email") as? String ?? ""
            let contact = object.value(forKey: "contact") as? String ?? ""
            let image = object.value(forKey: "image") as? Data
            
            let id = object.value(forKey: "id") as? String ?? ""


            let singleContact = ContactData(image: image!, name: contactName, contact: contact, email: email, contactId: id)
            tempData.append(singleContact)
        }
        return tempData
    }
    
    
    
    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try context.execute(DelAllReqVar) }
        catch { print(error) }
    }
    
    
}
