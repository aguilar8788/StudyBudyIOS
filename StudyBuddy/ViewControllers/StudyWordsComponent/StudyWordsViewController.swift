//
//  StudyWordsViewController.swift
//  StudyBuddy
//
//  Created by Peter Aguilar on 11/3/17.
//  Copyright © 2017 Aguilar Technology Solutions. All rights reserved.
//

import UIKit

class StudyWordsViewController: UIViewController {
    @IBOutlet weak var flashCardOutlet: UILabel!
    @IBOutlet weak var secondInDeckFlashCardOutlet: UILabel!
    @IBOutlet weak var moveBackInDeckOutlet: UILabel!
    @IBOutlet weak var endOfDeckLabelOutlet: UILabel!
    
    var wordsToStudy = [FlashCardsTableViewController.wordsObject]()
    var wordsLearned = [FlashCardsTableViewController.wordsObject]()
    var cardBackSide = false
    var counter = 0
    var counterBehindOne = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endOfDeckLabelOutlet.isHidden = true
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRec:)))
        flashCardOutlet.addGestureRecognizer(gesture)
        
        flashCardOutlet.text = wordsToStudy[counter].translated
        if wordsToStudy.count > 2 {
            secondInDeckFlashCardOutlet.text = wordsToStudy[counter + 1].translated
        }
        
//        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
//        doubleTap.numberOfTapsRequired = 2
//        view.addGestureRecognizer(doubleTap)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapFlipCard))
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.sendSubview(toBack: self.moveBackInDeckOutlet)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func singleTapFlipCard() {
        secondInDeckFlashCardOutlet.isHidden = true
        moveBackInDeckOutlet.isHidden = true
        let options = UIViewAnimationOptions.transitionFlipFromLeft
        UIView.transition(with: self.flashCardOutlet, duration: 0.3, options: options, animations: {
            if !self.cardBackSide {
                self.flashCardOutlet.text = self.wordsToStudy[self.counter].notTranslated
                self.cardBackSide = true
            } else if self.cardBackSide {
                self.flashCardOutlet.text = self.wordsToStudy[self.counter].translated
                self.cardBackSide = false
            }
        }, completion: { finished in
            self.secondInDeckFlashCardOutlet.isHidden = false
            self.moveBackInDeckOutlet.isHidden = false
        })
    }

    //must be refactored before production
    @objc
    func doubleTapped() {
        if wordsToStudy.count - 1 > 0 {
            wordsLearned.append(wordsToStudy[counter])
            
            let databaseFetch = Utils.fetchDatabaseItems(entityName: "VocabWord", predicate: "translated", predicateVal: wordsToStudy[counter].translated)
            
            Utils.makeChangeToDatabase(requestFromDB: databaseFetch, filterForKey: "learnedStatus", newValue: "1")
            wordsToStudy.remove(at: counter)
            
            if wordsToStudy.count - 1 != 0 && counter > 0 {
                counter = counter - 1
            }
            
            UIView.animate(withDuration: 1.0) {
                self.flashCardOutlet.center.y -= self.view.bounds.width * 2
                self.flashCardOutlet.isHidden = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.flashCardOutlet.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
                self.flashCardOutlet.isHidden = false
                if self.wordsToStudy.count > 1 {
                    if self.counter == self.wordsToStudy.count {
                        self.flashCardOutlet.text = self.wordsToStudy[self.counter - 1].translated
                        self.secondInDeckFlashCardOutlet.isHidden = true
                    } else {
                        if self.counter != 0 && self.counter != self.wordsToStudy.count - 1 {
                            self.counter = self.counter + 1
                            self.flashCardOutlet.text = self.wordsToStudy[self.counter].translated
                            self.secondInDeckFlashCardOutlet.text = self.wordsToStudy[self.counter + 1].translated
                        } else {
                            if self.counter != self.wordsToStudy.count - 1 {
                                self.flashCardOutlet.text = self.wordsToStudy[self.counter].translated
                                self.secondInDeckFlashCardOutlet.text = self.wordsToStudy[self.counter + 1].translated
                            } else {
                           
                                    self.cardBackSide = false
                                    self.flashCardOutlet.text = self.wordsToStudy[self.counter].translated
                                    
                                    self.moveBackInDeckOutlet.center.x -= self.view.bounds.width
                                    self.view.sendSubview(toBack: self.moveBackInDeckOutlet)
                            
                            }
                        }
                    }
                } else {
                    if self.counter == self.wordsToStudy.count {
                        self.secondInDeckFlashCardOutlet.isHidden = true
                        self.flashCardOutlet.text = self.wordsToStudy[self.counter - 1].translated
                    } else {
                        self.secondInDeckFlashCardOutlet.text = self.wordsToStudy[self.counter].translated
                        self.flashCardOutlet.text = self.wordsToStudy[self.counter].translated
                    }
                }
            })
            
            let learnedModal = Utils.modalPopUp(title: "card learned", message: "moving to learned deck", duration: 1)
            self.present(learnedModal, animated: true, completion: nil)
        } else {
            flashCardOutlet.isHidden = true
            secondInDeckFlashCardOutlet.isHidden = true
            moveBackInDeckOutlet.isHidden = true
            let finishedModal = Utils.modalPopUp(title: "Woohoo!!", message: "You learned this deck!", duration: 2)
            self.present(finishedModal, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc
    func wasDragged(gestureRec: UIPanGestureRecognizer) {
        cardBackSide = false

 
        if gestureRec.velocity(in: self.view).x > 700 {
            print("something")
            moveBackInDeckOutlet.isHidden = false
            secondInDeckFlashCardOutlet.isHidden = false
            
            if counter != 0 {
                counter = counterBehindOne
                
                if (counter + 1) != wordsToStudy.count {
                    secondInDeckFlashCardOutlet.text = wordsToStudy[counter + 1].translated
                }
                
                self.moveBackInDeckOutlet.center.x -= self.view.bounds.width
                
                
                self.view.bringSubview(toFront: moveBackInDeckOutlet)
                
                UIView.animate(withDuration: 0.2) {
                    self.moveBackInDeckOutlet.text = self.wordsToStudy[self.counterBehindOne].translated
                    self.moveBackInDeckOutlet.center = CGPoint(x: self.view.bounds.width / 4, y: self.view.bounds.height / 2)
                    self.moveBackInDeckOutlet.center.x += self.view.bounds.width / 4
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.cardBackSide = false
                    self.flashCardOutlet.text = self.wordsToStudy[self.counter].translated
                    
                    self.moveBackInDeckOutlet.center.x -= self.view.bounds.width
                    self.view.sendSubview(toBack: self.moveBackInDeckOutlet)
                })
            }
        }
        
        if gestureRec.velocity(in: self.view).x < 0 || gestureRec.velocity(in: self.view).y < -700{
            let labelPoint = gestureRec.translation(in: view)
            flashCardOutlet.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y)
            
            let xFromCenter = view.bounds.width / 2 - flashCardOutlet.center.x
        }
        
        if counter == wordsToStudy.count - 1 {
            moveBackInDeckOutlet.isHidden = true
            secondInDeckFlashCardOutlet.isHidden = true
        }
        
        if gestureRec.state == .ended {
            if counterBehindOne != 0 {
                counterBehindOne = counter - 1
            }
            
            func resetCardCenter() {
                flashCardOutlet.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
            }
            
            if flashCardOutlet.center.x < (view.bounds.width / 2 - 100) {
                if counter < wordsToStudy.count - 1 {
                    //moves deck forward
                    counter = counter + 1
                    counterBehindOne = counter - 1
                    if (counter + 1) != wordsToStudy.count {
                        secondInDeckFlashCardOutlet.text = wordsToStudy[counter + 1].translated
                    }
                    flashCardOutlet.text = wordsToStudy[counter].translated
                }
                resetCardCenter()
            }
            
            if flashCardOutlet.center.y < (view.bounds.width / 2 - 100) {
                print("get out of here")
                doubleTapped()
            }
            
            if gestureRec.velocity(in: self.view).y < (view.bounds.width / 2 - 100) || gestureRec.velocity(in: self.view).y > (view.bounds.width / 2 - 100) {
                resetCardCenter()
            }
        }
    }
}
