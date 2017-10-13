//
//  InterestHistoryTVC.swift
//  Beacon Social Matching
//
//  Created by Tsole on 22/9/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import Foundation
import UIKit

class InterestHistoryTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        //let cell = tableView.dequeueReusableCellWithIdentifier("Seppo", forIndexPath: indexPath) as! MatchingCell

        var cell = UITableViewCell()

        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("Seppo", forIndexPath: indexPath) as! MatchCell
        }

        if indexPath.row == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("Thomas", forIndexPath: indexPath) as! MatchCell
        }


        return cell
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180
    }
}

