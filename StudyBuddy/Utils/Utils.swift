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

class Utils {
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
    
    static func requestToDatabase(entityName: String) -> [NSManagedObject] {
        var reqReturned = [NSManagedObject]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        req.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(req)
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
}
