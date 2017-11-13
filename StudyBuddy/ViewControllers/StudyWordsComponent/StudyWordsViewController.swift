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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.sendSubview(toBack: self.moveBackInDeckOutlet)
        //        self.moveBackInDeckOutlet.center.x -= self.view.bounds.width
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func doubleTapped() {
        if wordsToStudy.count - 1 > 0 {
            wordsLearned.append(wordsToStudy[counter])
            Utils.makeChangeToDatabase(entityName: "VocabWord", forKey: "learnedStatus", newValue: 1, predicate: "translated", predicateVal: wordsToStudy[counter].translated)
            wordsToStudy.remove(at: counter)
            UIView.animate(withDuration: 1.0) {
                self.flashCardOutlet.center.y -= self.view.bounds.width * 2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.flashCardOutlet.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
                if self.wordsToStudy.count > 1 {
                    if self.counter < self.wordsToStudy.count - 1 {
                        if (self.counter + 1) != self.wordsToStudy.count {
                            self.secondInDeckFlashCardOutlet.text = self.wordsToStudy[self.counter + 1].translated
                        }
                        self.flashCardOutlet.text = self.wordsToStudy[self.counter].translated
                    }
                } else {
                    self.secondInDeckFlashCardOutlet.text = self.wordsToStudy[self.counter].translated
                    self.flashCardOutlet.text = self.wordsToStudy[self.counter].translated
                }
            })
        } else {
            flashCardOutlet.isHidden = true
            secondInDeckFlashCardOutlet.isHidden = true
            moveBackInDeckOutlet.isHidden = true
            endOfDeckLabelOutlet.isHidden = false
        }
    }
    
    @objc
    func wasDragged(gestureRec: UIPanGestureRecognizer) {
        
        let labelPoint = gestureRec.translation(in: view)
        flashCardOutlet.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y)
        
        let xFromCenter = view.bounds.width / 2 - flashCardOutlet.center.x
        
        if gestureRec.velocity(in: self.view).x > 0 {
            moveBackInDeckOutlet.isHidden = false
            secondInDeckFlashCardOutlet.isHidden = false
            
            flashCardOutlet.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
            if counter != 0 {
                counter = counterBehindOne
                
                if (counter + 1) != wordsToStudy.count {
                    secondInDeckFlashCardOutlet.text = wordsToStudy[counter + 1].translated
                }
                
                self.moveBackInDeckOutlet.center.x -= self.view.bounds.width
                
                
                self.view.bringSubview(toFront: moveBackInDeckOutlet)
                
                UIView.animate(withDuration: 1.0) {
                    self.moveBackInDeckOutlet.text = self.wordsToStudy[self.counterBehindOne].translated
                    self.moveBackInDeckOutlet.center = CGPoint(x: self.view.bounds.width / 3, y: self.view.bounds.height / 2)
                    self.moveBackInDeckOutlet.center.x += self.view.bounds.width / 4
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    
                    self.flashCardOutlet.text = self.wordsToStudy[self.counter].translated
                    
                    self.moveBackInDeckOutlet.center.x -= self.view.bounds.width
                    self.view.sendSubview(toBack: self.moveBackInDeckOutlet)
                })
            }
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
            
            if gestureRec.velocity(in: self.view).y < (view.bounds.width / 2 - 100) || gestureRec.velocity(in: self.view).y > (view.bounds.width / 2 - 100) {
                resetCardCenter()
            }
        }
    }
}
