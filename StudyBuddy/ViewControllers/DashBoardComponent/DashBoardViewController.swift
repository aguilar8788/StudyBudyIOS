//
//  DashBoardViewController.swift
//  StudyBuddy
//
//  Created by Peter Aguilar on 10/31/17.
//  Copyright © 2017 Aguilar Technology Solutions. All rights reserved.
//

import UIKit

class DashBoardViewController: UIViewController, XMLParserDelegate {
    var strXMLData:String = ""
    var currentElement:String = ""
    var passData:Bool=false
    var passName:Bool=false
    var stringBuilder = ""
    var success:Bool = false
    
    var parser = XMLParser()
    @IBOutlet weak var wordToAddTextOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addWordAction(_ sender: Any) {
        if wordToAddTextOutlet.text != "" {
            identifyLanguage(word: wordToAddTextOutlet.text!)
            //************ this needs to be changed to only notify if the add was actually successful ******************
            
            wordToAddTextOutlet.text = ""
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
    
    //*********************** refactor to make dry ***************************
    func identifyLanguage(word: String) {
        let apiPath = "https://api.microsofttranslator.com/v2/Http.svc/Detect?text=\(word)"
        let encodeString = apiPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: encodeString!)
        
        var request = URLRequest(url: url!)
        request.setValue("ea1eedd1bf3844f59607d292a1de43b7", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                if let urlContent = data {
                    self.parser = XMLParser(data: urlContent)
                    self.parser.delegate = self
                    self.success = self.parser.parse()
                    if word != "" {
                        self.translateWord(word: word, language: self.stringBuilder)
                    }
                }
            }
        }
        task.resume()
    }
    
    func translateWord(word: String, language: String) {
        
        var apiPath = ""
        
        if language == "en" {
            apiPath = "https://api.microsofttranslator.com/V2/Http.svc/Translate?text=\(word)&from=en&to=es"
        } else {
            apiPath = "https://api.microsofttranslator.com/V2/Http.svc/Translate?text=\(word)&from=es&to=en"
        }
        let encodeString = apiPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: encodeString!)
        
        var request = URLRequest(url: url!)
        request.setValue("ea1eedd1bf3844f59607d292a1de43b7", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                if let urlContent = data {
                    self.parser = XMLParser(data: urlContent)
                    self.parser.delegate = self
                    self.success = self.parser.parse()
                    if word != "" {
                        DispatchQueue.main.async(execute: {
                           
                            let removeLanguageFromString = self.stringBuilder[self.stringBuilder.index(self.stringBuilder.startIndex, offsetBy: 2) ..< self.stringBuilder.index(self.stringBuilder.endIndex, offsetBy: 0)]
                     
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            let context = appDelegate.persistentContainer.viewContext
                            let addWordStatus = Utils.addWordToDataBase(word: word, translatedWord: String(removeLanguageFromString),  context: context)
                                self.stringBuilder = ""
                            for status in addWordStatus {
                                print(status)
                                if status.key == "Success" {
                                    let addedCardSuccessModal = Utils.modalPopUp(title: status.key, message: status.value, duration: 1)
                                    self.present(addedCardSuccessModal, animated: true, completion: nil)
                                } else if status.key == "Error" {
                                    let addedCardFailedModal = Utils.modalPopUp(title: status.key, message: status.value, duration: 1)
                                    self.present(addedCardFailedModal, animated: true, completion: nil)
                                }
                            }
                        })
                      
                    }
                }
            }
        }
        task.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName
        if(elementName=="string")
        {
            passName=true
            passData=true
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement=""
        if(elementName=="string")
        {
            passName=false
            passData=false
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if(passData)
        {
            stringBuilder += string
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
}
