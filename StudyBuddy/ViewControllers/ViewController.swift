//
//  ViewController.swift
//  StudyBuddy
//
//  Created by Peter Aguilar on 10/28/17.
//  Copyright © 2017 Aguilar Technology Solutions. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var chooseUserLanguageOutlet: UILabel!
    @IBOutlet weak var chooseLanguageStudyingOutlet: UILabel!
    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var lastNameOutlet: UITextField!
    var languagePickerData: [String] = [String]()
    let languagePicker = UIPickerView()
    var chosenLabelTag = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pickerRect = languagePicker.frame
        pickerRect.origin.x = 20.0// some desired value
            pickerRect.origin.y = 300.0// some desired value
            languagePicker.frame = pickerRect
        languagePicker.delegate = self
        languagePicker.dataSource = self
        languagePicker.isHidden = true
        view.addSubview(languagePicker)

        languagePickerData = [
            " ",
            "Spanish",
            "French",
            "English",
            "Chinese",
            "Hindi",
            "Arabic",
            "Portuguese",
            "Russian",
            "Japanese"
        ]
        languagePicker.delegate = self

        let languageStudyingTapped = UITapGestureRecognizer(target: self, action: #selector(tap(gestureRecognizer:)))
        chooseLanguageStudyingOutlet.addGestureRecognizer(languageStudyingTapped)
        chooseLanguageStudyingOutlet.isUserInteractionEnabled = true

        let userLanguageTapped = UITapGestureRecognizer(target: self, action: #selector(tap(gestureRecognizer:)))
        chooseUserLanguageOutlet.addGestureRecognizer(userLanguageTapped)
        chooseUserLanguageOutlet.isUserInteractionEnabled = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userReq = Utils.requestToDatabase(entityName: "User")
        if let user = userReq[0].value(forKey: "firstName") {
            print("first \(user)")
            performSegue(withIdentifier: "showDashBoard", sender: nil)
        }
        

    }
    
    @objc
    func tap(gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.view?.tag == 1 {
            chosenLabelTag = 1
        } else if gestureRecognizer.view?.tag == 2 {
            chosenLabelTag = 2
        }
        languagePicker.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languagePickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languagePickerData[row]
    }
    
    //implement a better picker setup. Should be able to search for language, and not dismiss till after clicking the language of choice
    //also make it so that the language picker looks better
    //fix spacing of picker buttons
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if chosenLabelTag == 1 {
            chooseUserLanguageOutlet.text = languagePickerData[row]
        } else if chosenLabelTag == 2 {
             chooseLanguageStudyingOutlet.text = languagePickerData[row]
        }
       
        self.view.endEditing(true)
        languagePicker.isHidden = true
    }
    
    @IBAction func acceptSettingsAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if let firstName = firstNameOutlet.text {
            if let lastName = lastNameOutlet.text {
                if let userLanguage = chooseUserLanguageOutlet.text {
                    if let languageStudying = chooseLanguageStudyingOutlet.text {
                        Utils.addUserTodataBase(entityName: "User", firstName: firstName, lastName: lastName, userLanguage: userLanguage, studyingLanguage: languageStudying, context: context)
                        performSegue(withIdentifier: "showDashBoard", sender: nil)
                    }
                }
            }
        }
    }
}

