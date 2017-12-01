//
//  FlashCardsTableViewController.swift
//  StudyBuddy
//
//  Created by Peter Aguilar on 10/31/17.
//  Copyright © 2017 Aguilar Technology Solutions. All rights reserved.
//

import UIKit

class FlashCardsTableViewController: UITableViewController {
    var words = [wordsObject]()
    var wordsNotLearned = [wordsObject]()
    var wordsLearned = [wordsObject]()
    var decks = [String]()
    
    struct wordsObject {
        var notTranslated: String
        var translated: String
        var learnedStatus: Int
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        checkForDecks()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {

            checkForDecks()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlashCardCell", for: indexPath)
        cell.textLabel?.text = words[indexPath.row].notTranslated
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let translatedWord = words[indexPath.row]
        performSegue(withIdentifier: "translatedWordSegue", sender: translatedWord)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let wordViewController = segue.destination as? WordViewController {
            if let word = sender as? wordsObject {
                wordViewController.translatedWord = word.translated
            }
        }
        
        if let studySegue = segue.destination as? StudyWordsViewController {
          
            if let words = sender as? [wordsObject] {
                studySegue.wordsToStudy = words
            }
        }
        
        if let userDecksSegue = segue.destination as? UserDecksTableViewController {
          
            if let decks = sender as? [String] {
                userDecksSegue.userDecks = decks
            }
        }
    }
    
    
    @IBAction func studyCardsAction(_ sender: Any) {
        if decks.count > 0 {
            if decks.count == 1 && decks[0] == "all words" {
                performSegue(withIdentifier: "studySegue", sender: wordsNotLearned)
            }else {
                performSegue(withIdentifier: "userDecksSegue", sender: decks)
            }
        } else {
            if words.count > 0 {
                performSegue(withIdentifier: "studySegue", sender: wordsNotLearned)
            } else {
                //modal popup stating words have not been created yet
            }
        }
    }
    
    func checkForDecks() {
        let requestWords = Utils.returnDBFetchedObjects(entityName: "VocabWord")
        print("words \(requestWords.count)")
        print("words aquí \(words.count)")
        if words.count != requestWords.count {
            if words.count <= requestWords.count {
            for word in requestWords {
                if let learnedStatus = word.value(forKey: "learnedStatus") as? Int {
                    if let untranslatedWord = word.value(forKey: "notTranslated") {
                        if let translatedWord = word.value(forKey: "translated") as? String {
                            
                            words.append(wordsObject.init(notTranslated: untranslatedWord as! String, translated: translatedWord, learnedStatus: learnedStatus))
                            
                            if learnedStatus != 1 {
                                wordsNotLearned.append(wordsObject.init(notTranslated: untranslatedWord as! String, translated: translatedWord, learnedStatus: learnedStatus))
                            } else if learnedStatus == 1 {
                                wordsLearned.append(wordsObject.init(notTranslated: untranslatedWord as! String, translated: translatedWord, learnedStatus: learnedStatus))
                            }
                            if let deck = word.value(forKey: "vocabDeck") as? String {
                                if !decks.contains(deck) {
                                    if !decks.contains("all words") {
                                        if deck == "" {
                                            decks.append("all words")
                                        }
                                    } else if deck != "" {
                                        if !decks.contains(deck) {
                                            decks.append(deck)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        }
        
        if wordsLearned.count > 0 {
            if !decks.contains("learned") {
                decks.append("learned")
            }
        }
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            print(words.count)
//            //            Utils.deleteUserFromDatabase(entityName: "VocabWord", predicate: "translated", predicateVal: words[indexPath.row].translated)
//            words.remove(at: indexPath.row)
//            print(words.count)
//            //            tableView.deleteRows(at: [indexPath], with: .fade)
//
//        }
//        tableView.reloadData()
//    }
//
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
        
            Utils.deleteUserFromDatabase(entityName: "VocabWord", predicate: "translated", predicateVal: words[indexPath.row].translated)
            words.remove(at: indexPath.row)
            tableView.reloadData()
 
            //     tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    
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
    
    
}
