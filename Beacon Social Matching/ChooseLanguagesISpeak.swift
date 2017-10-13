//
//  ChooseLanguagesISpeak.swift
//  BeaCON
//
//  Created by Tsole on 15/11/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit

class ChooseLanguagesISpeak: UITableViewController {

    var languageChosen: ((NSString) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Languages I Speak:"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("Test", forIndexPath: indexPath) as! MatchingCell

        var cell = UITableViewCell()


        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("German", forIndexPath: indexPath)
        }

        if indexPath.row == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("English", forIndexPath: indexPath)
        }

        if indexPath.row == 2 {
            cell = tableView.dequeueReusableCellWithIdentifier("German, English", forIndexPath: indexPath)
        }

        if indexPath.row == 3 {
            cell = tableView.dequeueReusableCellWithIdentifier("German, other", forIndexPath: indexPath)
        }

        if indexPath.row == 4 {
            cell = tableView.dequeueReusableCellWithIdentifier("English, other", forIndexPath: indexPath)
        }

        if indexPath.row == 5 {
            cell = tableView.dequeueReusableCellWithIdentifier("German, English, other", forIndexPath: indexPath)
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
        let languages = cellSelected?.reuseIdentifier

        NSNotificationCenter.defaultCenter().postNotificationName("Selected Languages I Speak", object: languages)

        self.navigationController?.popViewControllerAnimated(true)
    }

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }


}
