//
//  MatchingCell.swift
//  Beacon Social Matching
//
//  Created by Tsole on 16/9/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import Foundation
import UIKit
import ParseUI

class MatchCell: PFTableViewCell {

    @IBOutlet var interestTypeImage: UIImageView!
    @IBOutlet var matchUserName: UILabel!
    @IBOutlet var interestTitle: UILabel!
    @IBOutlet var countryFlag: UIImageView!
    @IBOutlet var dateLabel: UILabel!
}