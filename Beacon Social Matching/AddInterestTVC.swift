//
//  AddInterestTVC.swift
//  Beacon Social Matching
//
//  Created by Tsole on 21/9/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import Foundation
import UIKit

class AddInterestTVC: UITableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel:")
        self.navigationItem.leftBarButtonItem = cancelButton
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        if indexPath.row == 0 {

            cell = tableView.dequeueReusableCellWithIdentifier("boardGamesAndPoker", forIndexPath: indexPath)
        }

        if indexPath.row == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("languageTandempartner", forIndexPath: indexPath)
        }

        if indexPath.row == 2 {
            cell = tableView.dequeueReusableCellWithIdentifier("sports", forIndexPath: indexPath)
        }

        if indexPath.row == 3 {
            cell = tableView.dequeueReusableCellWithIdentifier("romanticPartner", forIndexPath: indexPath)
        }

        if indexPath.row == 4 {
            cell = tableView.dequeueReusableCellWithIdentifier("smallTalk", forIndexPath: indexPath)
        }

        if indexPath.row == 5 {
            cell = tableView.dequeueReusableCellWithIdentifier("newBie", forIndexPath: indexPath)
        }


        return cell
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.toolbarHidden = true
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

     func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }

}
