//
//  InterestCell.swift
//  Beacon Social Matching
//
//  Created by Tsole on 17/9/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import Foundation
import UIKit
import ParseUI

class InterestCell: PFTableViewCell  {

    @IBOutlet var interestTitle: UILabel!

    @IBOutlet var newMatchesLabel: UILabel!
    @IBOutlet var interestActivityStatus: UILabel!

    @IBOutlet var countryFlag: UIImageView!
    @IBOutlet var interestButton: UIButton!
}

