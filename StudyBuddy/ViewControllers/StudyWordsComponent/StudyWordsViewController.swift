//
//  StudyWordsViewController.swift
//  StudyBuddy
//
//  Created by Peter Aguilar on 11/3/17.
//  Copyright © 2017 Aguilar Technology Solutions. All rights reserved.
//

import UIKit

class StudyWordsViewController: UIViewController {
    var wordsToStudy = [FlashCardsTableViewController.wordsObject]()
    var counter = 0
    @IBOutlet weak var flashCardOutlet: UILabel!
    @IBOutlet weak var secondInDeckFlashCardOutlet: UILabel!
    
    @IBOutlet weak var moveBackInDeckOutlet: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRec:)))
        flashCardOutlet.addGestureRecognizer(gesture)
        
        flashCardOutlet.text = wordsToStudy[counter].translated
        secondInDeckFlashCardOutlet.text = wordsToStudy[counter + 1].translated
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.sendSubview(toBack: self.moveBackInDeckOutlet)
        self.moveBackInDeckOutlet.center.x -= self.view.bounds.width


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func swipedRight() {
        print("right on")
    }
    
    @objc
    func wasDragged(gestureRec: UIPanGestureRecognizer) {
        
        let labelPoint = gestureRec.translation(in: view)
        flashCardOutlet.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y)
        
        let xFromCenter = view.bounds.width / 2 - flashCardOutlet.center.x
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        let scale = min(100 / abs(xFromCenter), 1)
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale)
        
        flashCardOutlet.transform = scaledAndRotated
        
        // have to make the transition animation happen...
        if gestureRec.velocity(in: self.view).x > 0 {
        
         
            rotation = CGAffineTransform(rotationAngle: 0)
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
            flashCardOutlet.transform = scaledAndRotated
            flashCardOutlet.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
            self.view.bringSubview(toFront: moveBackInDeckOutlet)

            UIView.animate(withDuration: 2.0) {
                self.moveBackInDeckOutlet.center = CGPoint(x: self.view.bounds.width / 3, y: self.view.bounds.height / 2)

                self.moveBackInDeckOutlet.center.x += self.view.bounds.width / 4
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                 self.moveBackInDeckOutlet.center.x -= self.view.bounds.width
                self.view.sendSubview(toBack: self.moveBackInDeckOutlet)

            })
           
        }
        
        if gestureRec.state == .ended {
            
            func resetCardCenter() {
                rotation = CGAffineTransform(rotationAngle: 0)
                scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
                flashCardOutlet.transform = scaledAndRotated
                flashCardOutlet.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
            }
            
            
            if flashCardOutlet.center.x < (view.bounds.width / 2 - 100) {
                if counter < wordsToStudy.count - 1 {
                    //moves deck forward
                    counter = counter + 1
                    if (counter + 1) != wordsToStudy.count {
                        secondInDeckFlashCardOutlet.text = wordsToStudy[counter + 1].translated as? String
                    }
                    flashCardOutlet.text = wordsToStudy[counter].translated as? String

                }
                resetCardCenter()
            }
            if flashCardOutlet.center.x > (view.bounds.width / 2 + 100) {
                //moves deck back
                if counter > 0 {
                    counter = counter - 1
                    flashCardOutlet.text = wordsToStudy[counter].translated as? String
                }
                resetCardCenter()
            }
            
            if flashCardOutlet.center.y < (view.bounds.height / 2 - 100) {
                //moves card to learned deck
                if counter < wordsToStudy.count - 1 {
                    counter = counter + 1
                    if (counter + 1) != wordsToStudy.count {
                        secondInDeckFlashCardOutlet.text = wordsToStudy[counter + 1].translated as? String
                    }
                    
                        resetCardCenter()
                        self.flashCardOutlet.text = self.wordsToStudy[self.counter].translated as? String
                    
                }
            }
        }
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
