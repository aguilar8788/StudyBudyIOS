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
    var decks = [String]()
    
    struct wordsObject {
        var notTranslated: String
        var translated: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestWords = Utils.requestToDatabase(entityName: "VocabWord")
        
        for word in requestWords {
            if let untranslatedWord = word.value(forKey: "notTranslated") {
                if let translatedWord = word.value(forKey: "translated") {
                    words.append(wordsObject.init(notTranslated: untranslatedWord as! String, translated: translatedWord as! String))
                    
                    if let deck = word.value(forKey: "vocabDeck") as? String {
                        if !decks.contains(deck) {
                            if !decks.contains("all words") {
                                if deck == "" {
                                    decks.append("all words")
                                }
                            } else if deck != "" {
                                decks.append(deck)
                            }
                        }
                    }
                }
            }
        }
        
        
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
                performSegue(withIdentifier: "studySegue", sender: words)
            }else {
            performSegue(withIdentifier: "userDecksSegue", sender: decks)
            }
        } else {
            if words.count > 0 {
                performSegue(withIdentifier: "studySegue", sender: words)
            } else {
                //modal popup stating words have not been created yet
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