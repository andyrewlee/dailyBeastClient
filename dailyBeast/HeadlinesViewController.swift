//
//  ViewController.swift
//  dailyBeast
//
//  Created by Jae Hoon Lee on 8/18/15.
//  Copyright © 2015 Jae Hoon Lee. All rights reserved.
//

import UIKit

class HeadlinesViewController: UITableViewController {
    var lastIndexTapped: Int = 0
    var news = [String]()
    var links = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getNews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NewsSegue" {
            let controller = segue.destinationViewController as! NewsViewController
            
            controller.url = links[lastIndexTapped]
            controller.headline = news[lastIndexTapped]
        }
    }

    func getNews() {
        if let urlToReq = NSURL(string: "http://localhost:4567/titles") {
            if let data = NSData(contentsOfURL: urlToReq) {
                let arrOfNewsTitles = parseJSON(data)
                for title in arrOfNewsTitles! {
                    news.append(title as! String)
                }
            }
        }
        
        if let urlToReq = NSURL(string: "http://localhost:4567/links") {
            if let data = NSData(contentsOfURL: urlToReq) {
                let arrOfNewsLinks = parseJSON(data)
                for link in arrOfNewsLinks! {
                    links.append(link as! String)
                }
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            print(NSThread.isMainThread() ? "Main Thread" : "Not on Main Thread")
            self.tableView.reloadData()
        })
    }
    
    func parseJSON(inputData: NSData) -> NSArray? {
        do {
            let arrOfObjects = try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers)
            return arrOfObjects as? NSArray
        } catch {
            return nil
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell")!
        cell.textLabel?.text = news[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        lastIndexTapped = indexPath.row
        
        performSegueWithIdentifier("NewsSegue", sender: self)
    }

}

