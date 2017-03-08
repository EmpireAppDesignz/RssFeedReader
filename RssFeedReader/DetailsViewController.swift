//
//  DetailsViewController.swift
//  RssFeedReader
//
//  Created by Eric Rosas on 11/25/16.
//  Copyright (c) 2016 EmpireAppDesignz. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UIWebViewDelegate{

    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var entryTitleLabel: UILabel!
    @IBOutlet var webView: UIWebView!
    @IBAction func backAction(_ sender: AnyObject) {
    self.navigationController?.popToRootViewController(animated: true)
    }
    var entryUrl:String!
    var entryTitle:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        entryTitleLabel.text = entryTitle
        let url:URL = URL(string: entryUrl)!
        self.webView.loadRequest(URLRequest(url:url))
        self.webView.delegate = self
        activityIndicatorView.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIWebViewDelegate
    func webViewDidFinishLoad(_ webView: UIWebView){
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
