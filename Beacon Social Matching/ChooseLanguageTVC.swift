//
//  ChooseLanguageTVC.swift
//  Beacon Social Matching
//
//  Created by Tsole on 23/9/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import Foundation
import UIKit

class ChooseLanguageTVC: UITableViewController {

    var comingFrom: String = ""

    // @property (nonatomic, copy) void (^somethingHappenedInModalVC)(NSString *response);
    var languageChosen: ((NSString) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = self.comingFrom as String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("Test", forIndexPath: indexPath) as! MatchingCell

        var cell = UITableViewCell()


        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("Spanish", forIndexPath: indexPath)
        }

        if indexPath.row == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("German", forIndexPath: indexPath)
        }

        if indexPath.row == 2 {
            cell = tableView.dequeueReusableCellWithIdentifier("French", forIndexPath: indexPath)
        }

        if indexPath.row == 3 {
            cell = tableView.dequeueReusableCellWithIdentifier("Chinese", forIndexPath: indexPath)
        }

        if indexPath.row == 4 {
            cell = tableView.dequeueReusableCellWithIdentifier("Italian", forIndexPath: indexPath)
        }

        if indexPath.row == 5 {
            cell = tableView.dequeueReusableCellWithIdentifier("English", forIndexPath: indexPath)
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
        //self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        let cellSelected = tableView.cellForRowAtIndexPath(indexPath)
        let languageSelected = cellSelected?.reuseIdentifier

        if self.title == "I want to practice: " {
            NSNotificationCenter.defaultCenter().postNotificationName("Selected language I want To Practice", object: languageSelected)
        } else if self.title == "I am offering: " {
            NSNotificationCenter.defaultCenter().postNotificationName("Selected language I want To Offer", object: languageSelected)
        }

        self.navigationController?.popViewControllerAnimated(true)
    }

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
    }

    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        //self.navigationController?.navigationBar.hidden = true
    }
}