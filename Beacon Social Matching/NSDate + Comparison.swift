//
//  NSDate + Comparison.swift
//  
//
//  Created by Tsole on 3/12/15.
//
//

import Foundation

extension NSDate {
    // new functionality to add to NSDate goes here

    class func equal(firstDate: NSDate, secondDate: NSDate) -> Bool {
        return firstDate === secondDate || firstDate.compare(secondDate) == .OrderedSame
    }

    class func smaller(firstDate: NSDate, secondDate: NSDate) -> Bool {
        return firstDate.compare(secondDate) == .OrderedAscending
    }

    class func larger(firstDate: NSDate, secondDate: NSDate) -> Bool {
        return firstDate.compare(secondDate) == .OrderedDescending
    }
    
}