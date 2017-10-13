//
//  TutorialVC.swift
//  BeaCON
//
//  Created by Tsole on 24/11/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController {

    @IBOutlet var tutorialWebVC: UIWebView!


    override func viewDidLoad() {
        let pdfLoc = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("Tutorial", ofType:"pdf")!) //replace PDF_file with your pdf die name
        let request = NSURLRequest(URL: pdfLoc);
        self.tutorialWebVC.loadRequest(request);
    }
}
