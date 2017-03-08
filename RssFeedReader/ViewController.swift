//
//  ViewController.swift
//  RssFeedReader
//
//  Created by Eric Rosas on 11/25/16.
//  Copyright (c) 2016 EmpireAppDesignz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate {
    
    var xmlParser: XMLParser!
    var entryTitle: String!
    var entryDescription: String!
    var entryLink: String!
    var currentParsedElement:String! = String()
    var entryDictionary: [String:String]! = Dictionary()
    var entriesArray:[Dictionary<String, String>]! = Array()
    
    @IBOutlet var titlesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.titlesTableView.estimatedRowHeight = 40.0
        let urlString = URL(string: "http://themfceo.com/feed/")
        let rssUrlRequest:URLRequest = URLRequest(url:urlString!)
        
        let queue:OperationQueue = OperationQueue()
        NSURLConnection.sendAsynchronousRequest(rssUrlRequest, queue: queue) {
            (response, data, error) -> Void in
            
            self.xmlParser = XMLParser(data: data!)
            self.xmlParser.delegate = self
            self.xmlParser.parse()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: NSXMLParserDelegate
    func parser(_ parser: XMLParser!,
        didStartElement elementName: String!,
        namespaceURI: String!,
        qualifiedName: String!,
        attributes attributeDict: [AnyHashable: Any]!){
            if elementName == "title"{
                entryTitle = String()
                currentParsedElement = "title"
            }
            if elementName == "description"{
                entryDescription = String()
                currentParsedElement = "description"
            }
            if elementName == "link"{
                entryLink = String()
                currentParsedElement = "link"
            }
    }

    func parser(_ parser: XMLParser,
        foundCharacters string: String!){
            if currentParsedElement == "title"{
                entryTitle = entryTitle + string
            }
            if currentParsedElement == "description"{
                entryDescription = entryDescription + string
            }
            if currentParsedElement == "link"{
                entryLink = entryLink + string
            }
    }

    func parser(_ parser: XMLParser,
        didEndElement elementName: String!,
        namespaceURI: String!,
        qualifiedName qName: String!){
            if elementName == "title"{
                entryDictionary["title"] = entryTitle
            }
            if elementName == "link"{
                entryDictionary["link"] = entryLink
            }
            if elementName == "description"{
                entryDictionary["description"] = entryDescription
                entriesArray.append(entryDictionary)
            }
    }
    
    func parserDidEndDocument(_ parser: XMLParser){
        DispatchQueue.main.async(execute: { () -> Void in
            self.titlesTableView.reloadData()
        })
    }
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView,
        cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
            
            var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")
            
            if (nil == cell){
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cellIdentifier")
            }
            cell!.textLabel?.text = entriesArray[(indexPath as NSIndexPath).row]["title"]
            cell!.textLabel?.numberOfLines = 0
            cell!.detailTextLabel?.text = entriesArray[(indexPath as NSIndexPath).row]["description"]
            cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell!
    }
    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int{
            return entriesArray.count
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView,
        didSelectRowAtIndexPath indexPath: IndexPath){
            let detailsVC = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
            detailsVC.entryUrl = entriesArray[(indexPath as NSIndexPath).row]["link"]
            detailsVC.entryTitle = entriesArray[(indexPath as NSIndexPath).row]["title"]
            self.navigationController?.pushViewController(detailsVC, animated: true)
    }

}

