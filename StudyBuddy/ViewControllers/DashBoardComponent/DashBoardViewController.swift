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
            translateWord(word: wordToAddTextOutlet.text!)
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
    
    func translateWord(word: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let apiPath = "https://api.microsofttranslator.com/V2/Http.svc/Translate?text=\(word)&from=en&to=es"
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
                        Utils.addWordToDataBase(word: word, translatedWord: self.stringBuilder,  context: context)
                        self.stringBuilder = ""
                    }
                }
            }
        }
        task.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        if(elementName=="string")
        {
            passName=true;
            passData=true;
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        if(elementName=="string")
        {
            passName=false;
            passData=false;
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
