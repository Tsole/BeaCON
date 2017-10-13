//
//  MatchingDetailVC.swift
//  Beacon Social Matching
//
//  Created by Tsole on 16/9/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import Foundation

import UIKit

class MatchingDetailVC: UIViewController {

    @IBOutlet var matchingIcon: UIImageView!
    @IBOutlet var matchingInterest: UILabel!
    @IBOutlet var matchingInformation: UILabel!
    @IBOutlet var contactButton: UIButton!



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
        self.matchingInformation.text = "You have matched with " + "Kostas" + "\n5 seconds ago." + "\nInformation about Kostas: " + "\nAge: 21 years" + "\nInterested for Spanish" + "\nProficient in Greek"
    }


    @IBAction func contactButtonPressed(sender: AnyObject) {
    }

}
