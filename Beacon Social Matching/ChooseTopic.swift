//
//  UIKit.swift
//  BeaCON
//
//  Created by Tsole on 18/11/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit

class ChooseTopic: UITableViewController {

    var languageChosen: ((NSString) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "I would like to talk about..."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = UITableViewCell()


        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("Politics", forIndexPath: indexPath)
        }

        if indexPath.row == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("TV Series, Movies", forIndexPath: indexPath)
        }

        if indexPath.row == 2 {
            cell = tableView.dequeueReusableCellWithIdentifier("Lifestyle News", forIndexPath: indexPath)
        }

        if indexPath.row == 3 {
            cell = tableView.dequeueReusableCellWithIdentifier("Sport News", forIndexPath: indexPath)
        }

        if indexPath.row == 4 {
            cell = tableView.dequeueReusableCellWithIdentifier("Anything", forIndexPath: indexPath)
        }

        return cell
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        let cellSelected = tableView.cellForRowAtIndexPath(indexPath)
        let topicSelected = cellSelected?.reuseIdentifier

        NSNotificationCenter.defaultCenter().postNotificationName("Selected Topic", object: topicSelected)

        self.navigationController?.popViewControllerAnimated(true)
    }

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    
    
}
