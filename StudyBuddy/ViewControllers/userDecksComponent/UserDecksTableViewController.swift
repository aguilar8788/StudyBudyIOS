//
//  UserDecksTableViewController.swift
//  StudyBuddy
//
//  Created by Peter Aguilar on 11/6/17.
//  Copyright © 2017 Aguilar Technology Solutions. All rights reserved.
//

import UIKit

class UserDecksTableViewController: UITableViewController {
    var userDecks = [String]()
    var wordsInDeck = [FlashCardsTableViewController.wordsObject]()
    var wordsWithNoDeck = [FlashCardsTableViewController.wordsObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let requestWords = Utils.requestToDatabase(entityName: "VocabWord")
        //
        //        for word in requestWords {
        //            if let untranslatedWord = word.value(forKey: "notTranslated") {
        //                if let translatedWord = word.value(forKey: "translated") {
        //                    words.append(FlashCardsTableViewController.wordsObject.init(notTranslated: untranslatedWord as! String, translated: translatedWord as! String))
        //                }
        //            }
        //        }
        
        //        print("userDecks \(userDecks)")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDecks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deckCell", for: indexPath)
        if userDecks.count > 0 {
            cell.textLabel?.text = userDecks[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let requestWords = Utils.returnDBFetchedObjects(entityName: "VocabWord")
        if requestWords.count > 0 {
            wordsInDeck = [FlashCardsTableViewController.wordsObject]()
            wordsWithNoDeck.removeAll()
            for word in requestWords {
                if let learnedStatus = word.value(forKey: "learnedStatus") {
                    if let untranslatedWord = word.value(forKey: "notTranslated") {
                        if let translatedWord = word.value(forKey: "translated") {
                            if let deck = word.value(forKey: "vocabDeck") as? String {
                                if userDecks[indexPath.row] == deck {
                                    wordsInDeck.append(FlashCardsTableViewController.wordsObject.init(notTranslated: untranslatedWord as! String, translated: translatedWord as! String, learnedStatus: learnedStatus as! Int))
                                } else {
                                    wordsWithNoDeck.append(FlashCardsTableViewController.wordsObject.init(notTranslated: untranslatedWord as! String, translated: translatedWord as! String, learnedStatus: learnedStatus as! Int))
                                }
                            }
                        }
                    }
                }
            }
            performSegue(withIdentifier: "studyDeckSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let decksStudySegue = segue.destination as? StudyWordsViewController {
            if wordsInDeck.count > 0 {
                decksStudySegue.wordsToStudy = wordsInDeck
            } else {
                decksStudySegue.wordsToStudy = wordsWithNoDeck
            }
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
