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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRec:)))
        flashCardOutlet.addGestureRecognizer(gesture)
        
        flashCardOutlet.text = wordsToStudy[counter].translated as? String
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        if gestureRec.state == .ended {
            
            
            if flashCardOutlet.center.x < (view.bounds.width / 2 - 100) {
                if counter < wordsToStudy.count - 1 {
                    counter = counter + 1
                    flashCardOutlet.text = wordsToStudy[counter].translated as? String
                }
            }
            if flashCardOutlet.center.x > (view.bounds.width / 2 + 100) {
                if counter > 0 {
                counter = counter - 1
                flashCardOutlet.text = wordsToStudy[counter].translated as? String
                }
            }
            
            if flashCardOutlet.center.y < (view.bounds.height / 2 - 100) {
                print("get outta here")
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
            flashCardOutlet.transform = scaledAndRotated
            flashCardOutlet.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
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
