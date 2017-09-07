//
//  ViewController.swift
//  XMLParsing
//
//  Created by Nimblechapps - iOS on 30/08/17.
//  Copyright © 2017 Nimblechapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate {
    
    var ipAddr:String = ""
    var countryCode:String = ""
    var countryName:String = ""
    var latitude:String = ""
    var longitude:String = ""
    
    var currentParsingElement:String = ""
    
    @IBOutlet weak var ipAddressLabel:UILabel!
    @IBOutlet weak var countryCodeLabel:UILabel!
    @IBOutlet weak var countryNameLabel:UILabel!
    @IBOutlet weak var latitudeLabel:UILabel!
    @IBOutlet weak var longitudeLabel:UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        getXMLDataFromServer()
    }

    //MARK:- Custom methods
    func getXMLDataFromServer(){
        let url = NSURL(string: "https://freegeoip.net/xml/4.2.2.2")
        
        //Creating data task
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
            
            if data == nil {
                print("dataTaskWithRequest error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            let parser = XMLParser(data: data!)
            parser.delegate = self
            parser.parse()
            
        }
        
        task.resume()

    }
    
    func displayOnUI(){
        ipAddressLabel.text = ipAddr
        countryCodeLabel.text = countryCode
        countryNameLabel.text = countryName
        latitudeLabel.text = latitude
        longitudeLabel.text = longitude
    }
    
    //MARK:- XML Delegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentParsingElement = elementName
        if elementName == "Response" {
            print("Started parsing...")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            if currentParsingElement == "IP" {
                ipAddr += foundedChar
            }
            else if currentParsingElement == "CountryCode" {
                countryCode += foundedChar
            }
            else if currentParsingElement == "CountryName" {
                countryName += foundedChar
            }
            else if currentParsingElement == "Latitude" {
                latitude += foundedChar
            }
            else if currentParsingElement == "Longitude" {
                longitude += foundedChar
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Response" {
            print("Ended parsing...")
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            // Update UI
            self.displayOnUI()
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }

}

