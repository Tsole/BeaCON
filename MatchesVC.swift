//
//  HistoryVC.swift
//  Beacon Social Matching
//
//  Created by Tsole on 17/9/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import RealmSwift

class MatchesVC: PFQueryTableViewController {

    //var matchedUser = PFUser()


    override init(style: UITableViewStyle, className: String?) {
        super.init(style: style, className: className)
        parseClassName = "Match"
        pullToRefreshEnabled = true
        paginationEnabled = true
        objectsPerPage = 250
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        parseClassName = "Match"
        pullToRefreshEnabled = true
        paginationEnabled = true
        objectsPerPage = 50
    }

    override func queryForTable() -> PFQuery {
        //let query = PFQuery(className: self.parseClassName!)
        //query.whereKey("matchOwner1", equalTo: PFUser.currentUser()!)

        let predicate = NSPredicate(format:"matchOwner1Minor = %@ OR matchOwner2Minor = %@", PFUser.currentUser()?["minor"] as! NSNumber, PFUser.currentUser()?["minor"] as! NSNumber)
        let query = PFQuery(className: self.parseClassName!, predicate: predicate)

        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if self.objects!.count == 0 {
            query.cachePolicy = .CacheThenNetwork
        }

        query.orderByDescending("updatedAt")

        return query
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let dimensions = NSDictionary()
        PFAnalytics.trackEvent("MatchesViewLoaded", dimensions:(dimensions as! [String : String]))
    }

    override func viewDidAppear(animated: Bool) {
        let dimensions = NSDictionary()
        PFAnalytics.trackEvent("MatchesViewAppeared", dimensions:(dimensions as! [String : String]))
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {

        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine

        let cellIdentifier = "MatchCell"

        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? MatchCell
        if cell == nil {
            cell = MatchCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }

        // Configure the cell to show the matches
        if let object = object {

            var image = UIImage(named: object.objectForKey("interestType") as! String)

            if object.objectForKey("interestType") as! String == InterestType.Sport.rawValue {
                image = UIImage(named: object.objectForKey("title") as! String)
            }

            //use Poker or BoardGames Icon?
            if object.objectForKey("interestType") as! String == InterestType.BoardGames.rawValue {
                image = UIImage(named: "Board Games")
                if object.objectForKey("title") as! String == "Poker" {
                    image = UIImage(named: "Poker")
                }
            }

            cell?.interestTypeImage.image = image
            cell?.interestTitle.text = object.objectForKey("identifier") as? String

            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "H:mm EEEE"
            cell?.dateLabel.text = "Matched at " + dateFormatter.stringFromDate(object.createdAt!)

            if (object.objectForKey("matchOwner1UserName") as! String) == PFUser.currentUser()?.username  {
                cell?.matchUserName.text = (object.objectForKey("matchOwner2UserName") as! String)

                if cell?.matchUserName.text == "Unknown" {
                    let minorToRetrieve:NSNumber = object.objectForKey("matchOwner2Minor") as! NSNumber
                    self.retrieveUserNameFromMinorForMatch(minorToRetrieve, match: object)
                }
            } else {
                cell?.matchUserName.text = (object.objectForKey("matchOwner1UserName") as! String)

                if cell?.matchUserName.text == "Unknown" {
                    let minorToRetrieve:NSNumber = object.objectForKey("matchOwner1Minor") as! NSNumber
                    self.retrieveUserNameFromMinorForMatch(minorToRetrieve, match: object)
                }

            }
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("Match Selected", sender: indexPath)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let matchDetailVC = segue.destinationViewController as! MatchDetailsVC
            matchDetailVC.selectedMatch = self.objectAtIndexPath((sender as! NSIndexPath))!
    }


    func retrieveUserNameFromMinorForMatch (minor: NSNumber, match: PFObject) {

        let query = PFUser.query()
        query!.whereKey("minor", equalTo:minor)
        query!.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in

            if error == nil {
                // The find succeeded
                print(objects![0])
                match["matchOwner2UserName"] = objects![0].objectForKey("username")
                match["matchOwner2"] = objects![0]
                match.saveInBackground()//also adds the 
                self.loadObjects()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {

            /*let dimensions = ["user": (PFUser.currentUser()?.username)! as String, "Interest type": objectAtIndexPath(indexPath)!.objectForKey("interestType") as! String,"Interest title": objectAtIndexPath(indexPath)!.objectForKey("title") as! String]
            PFAnalytics.trackEvent("InterestDeleted", dimensions: dimensions)*/

            //delete this interest from realm
            let realm = try! Realm()

            let matchToDelete = realm.objectForPrimaryKey(Match.self, key: objectAtIndexPath(indexPath)!.objectForKey("keyBroadcasterMinorIdentifier") as! String)
            try! realm.write {
                if matchToDelete != nil {
                    realm.delete(matchToDelete!)
                    print("deleted interest from realm")
                } else {

                }
            }

            self.removeObjectAtIndexPath(indexPath, animated: true)
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.loadObjects()
    }
}