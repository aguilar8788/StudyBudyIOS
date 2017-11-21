//
//  Utils.swift
//  StudyBuddy
//
//  Created by Peter Aguilar on 10/31/17.
//  Copyright © 2017 Aguilar Technology Solutions. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Utils: UIViewController {
    func deleteUserFromDatabase(objToDelete: NSManagedObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
            context.delete(objToDelete)
            try context.save()
        } catch {
            print("error: could not delete")
        }
    }
    
    static func addUserTodataBase(entityName: String, firstName: String, lastName: String, userLanguage: String, studyingLanguage: String, context: NSManagedObjectContext) {
        
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        
        newUser.setValue(firstName, forKey: "firstName")
        newUser.setValue(lastName, forKey: "lastName")
        newUser.setValue(userLanguage, forKey: "nativeLanguage")
        newUser.setValue(studyingLanguage, forKey: "languageStudying")
        
        do {
            try context.save()
            print("user has been saved")
        } catch {
            print("error: user was not saved")
        }
    }
    
    // refactor. SHit is horrible
    static func addWordToDataBase(word: String, translatedWord: String, context: NSManagedObjectContext) {
        let newWord = NSEntityDescription.insertNewObject(forEntityName: "VocabWord", into: context)
        
        newWord.setValue(false, forKey: "learnedStatus")
        newWord.setValue(word, forKey: "notTranslated")
        newWord.setValue(translatedWord, forKey: "translated")
        newWord.setValue("", forKey: "vocabDeck")
        
        do {
            try context.save()
            print("word has been saved :)")
        } catch {
            print("error: word has not been saved")
        }
    }
    
    struct dataBaseFetchObj {
        var results: NSFetchRequest<NSFetchRequestResult>
        var predicate: String
        var predicateVal: String
    }
    
    static func fetchDatabaseItems(entityName: String, predicate: String = "", predicateVal: String = "") -> dataBaseFetchObj {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        req.returnsObjectsAsFaults = false
        if predicate != "" && predicateVal != "" {
             req.predicate = NSPredicate(format: predicate + " = %@", predicateVal)
        }
       
        return dataBaseFetchObj.init(results: req, predicate: predicate, predicateVal: predicateVal)
    }
    
    static func returnDBFetchedObjects(entityName: String) -> [NSManagedObject] {
        var reqReturned = [NSManagedObject]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let objectFetched = self.fetchDatabaseItems(entityName: entityName)
        
        do {
            let results = try context.fetch(objectFetched.results)
            if results.count > 0 {
                for result in results  as! [NSManagedObject]{
                    reqReturned.append(result)
                }
                
            }
            
        } catch {
            print("couldnt fetch")
        }
        
        return reqReturned
    }
    
    
    
    static func makeChangeToDatabase(requestFromDB:dataBaseFetchObj, filterForKey: String, newValue: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        do {
            let results = try context.fetch(requestFromDB.results)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if (result.value(forKey: requestFromDB.predicate) as? String) != nil {
                        if filterForKey == "learnedStatus" {
                            result.setValue("learned", forKey: "vocabDeck")
                            result.setValue(1, forKey: "learnedStatus")
                        } else {
                            result.setValue(newValue, forKey: filterForKey)
                        }
                        do {
                            print("should save")
                            try context.save()
                        } catch {
                            print("didnt save")
                        }
                    }
                }
            }else {
                print("No results")
            }
        }catch {
            print("counldnt fetch")
        }
        
    }
    
    static func modalPopUp(title: String, message: String, duration: Int) -> UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(duration)) {
            alertController.dismiss(animated: true) {
            }
        }
        return alertController
    }
}
