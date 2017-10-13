//
//  InterestToSignalTransformer.swift
//  BeaCON
//
//  Created by Tsole on 27/11/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit
import Parse

class InterestToSignalTransformer: NSObject {

    func transformInterestToSIgnal(interest: PFObject) -> InterestSignal {

        var first = 0
        var second = 0
        var third = 0
        var fourth = 0
        var fifth = 0
        let interestSignalToReturn = InterestSignal()

        if interest.objectForKey("interestType") as! String == InterestType.Sport.rawValue {
            first = intFromSportType(interest.objectForKey("title") as! String)
            second = intFromFrequency(interest.objectForKey("frequency") as! String)
            third = intFromAge(interest.objectForKey("myAge") as! String)
            fourth = intFromOpenness(interest.objectForKey("openness") as! String)
            fifth = intFromLanguages(interest.objectForKey("languagesISpeak") as! String)
        }

        if interest.objectForKey("interestType") as! String == InterestType.BoardGames.rawValue {
            first = intFromGameType(interest.objectForKey("title") as! String)
            second = intFromFrequency(interest.objectForKey("frequency") as! String)
            third = intFromAge(interest.objectForKey("myAge") as! String)
            fourth = intFromOpenness(interest.objectForKey("openness") as! String)
            fifth = intFromLanguages(interest.objectForKey("languagesISpeak") as! String)
        }

        if interest.objectForKey("interestType") as! String == InterestType.Language.rawValue {
            first = intFromLanguage(interest.objectForKey("languageIWantToPractice") as! String)
            fifth = intFromLanguage(interest.objectForKey("languageISpeak") as! String)
            second = intFromLanguageSkill(interest.objectForKey("languageIWantToPracticeSkillLevel") as! String)
            third = intFromLanguageSkill(interest.objectForKey("languageISpeakSkillLevel") as! String)
            fourth = intFromOpenness(interest.objectForKey("openness") as! String)
        }

        if interest.objectForKey("interestType") as! String == InterestType.SmallTalk.rawValue {
            first = intFromTopic(interest.objectForKey("topic") as! String)
            second = intFromAge(interest.objectForKey("myAge") as! String)
            third = intFromOpenness(interest.objectForKey("openness") as! String)
            fourth = intFromMyGender(interest.objectForKey("myGender") as! String)
            fifth = intFromLanguages(interest.objectForKey("languagesISpeak") as! String)
        }

        if interest.objectForKey("interestType") as! String == InterestType.Partner.rawValue {
            first = intFromAge(interest.objectForKey("myAge") as! String)
            second = intFromPartnering(interest.objectForKey("myGender") as! String, interestedInGender: interest.objectForKey("interestedIn") as! String)
            third = intFromMyAppearance(interest.objectForKey("myApperance") as! String)
            fourth = intFromOpenness(interest.objectForKey("openness") as! String)
            fifth = intFromHeight(interest.objectForKey("myHeight") as! String)
        }

        //build major
        let partofmajor = String(first) + String(second)
        let major =  partofmajor + String(third) + String(fourth) + String(fifth)

        //assing beacon values
        interestSignalToReturn.minor = PFUser.currentUser()!["minor"] as! Int
        interestSignalToReturn.major = Int(major)!
        interestSignalToReturn.identifier = interest.objectForKey("interestType") as! String + String(interest.objectForKey("title"))
        interestSignalToReturn.uuid = UUIDFromInterestType(interest.objectForKey("interestType") as! String)
        return interestSignalToReturn
    }

    func UUIDFromInterestType(type: String) -> NSUUID {
        var uuidToReturn = NSUUID()

        switch type {
        case InterestType.Sport.rawValue: uuidToReturn = NSUUID.init(UUIDString: "78019DB1-B7CA-4DFB-BAB6-1B0576BE6B91")!
        case InterestType.Partner.rawValue: uuidToReturn = NSUUID.init(UUIDString: "1184abbd-10c0-435e-8bdc-b53fe77ffb21")!
        case InterestType.BoardGames.rawValue: uuidToReturn = NSUUID.init(UUIDString: "b3e13539-91fc-4dce-9f1f-71acaf2197bb")!
        case InterestType.SmallTalk.rawValue: uuidToReturn = NSUUID.init(UUIDString: "73310a6f-4998-422c-9773-7b2d92d98006")!
        case InterestType.Language.rawValue: uuidToReturn = NSUUID.init(UUIDString: "26602d78-460c-4f43-ac3a-ed949ac14fc6")!

        default: break
        }

        return uuidToReturn
    }

    func intFromSportType(sportType: String) -> Int {

        var valueToReturn:Int = 0

        switch sportType {
        case "Football": valueToReturn = 1
        case "Basketball": valueToReturn = 2
        case "Tennis": valueToReturn = 3
        case "Running": valueToReturn = 4
        case "Volleyball": valueToReturn = 5
        case "All Sports": valueToReturn = 6

        default: break
        }

        return valueToReturn
    }

    func intFromMyAppearance(apperance: String) -> Int {

        var valueToReturn:Int = 0

        switch apperance {
        case "No Selection": valueToReturn = 0
        case "Slim": valueToReturn = 1
        case "Normal": valueToReturn = 2
        case "Muscular": valueToReturn = 3
        case "Large": valueToReturn = 4

        default: break
        }
        
        return valueToReturn
    }

    func intFromHeight(height: String) -> Int {

        var valueToReturn:Int = 0

        switch height {
        case "No Selection": valueToReturn = 0
        case "0-160cm": valueToReturn = 1
        case "160-165cm": valueToReturn = 2
        case "165-170cm": valueToReturn = 3
        case "170-175cm": valueToReturn = 4
        case "175-180cm": valueToReturn = 5
        case "185+cm": valueToReturn = 6

        default: break
        }

        return valueToReturn
    }

    func intFromLanguage(language: String) -> Int {

        var valueToReturn:Int = 0

        switch language {
        case "Spanish": valueToReturn = 1
        case "German": valueToReturn = 2
        case "French": valueToReturn = 3
        case "Chinese": valueToReturn = 4
        case "Italian": valueToReturn = 5
        case "English": valueToReturn = 6

        default: break
        }

        return valueToReturn
    }

    func intFromLanguageSkill(languageSkill: String) -> Int {

        var valueToReturn:Int = 0

        switch languageSkill {
        case "No Selection": valueToReturn = 0
        case "Basic": valueToReturn = 1
        case "Good": valueToReturn = 2
        case "Very Good": valueToReturn = 3
        case "Excellent": valueToReturn = 4

        default: break
        }

        return valueToReturn
    }

    func intFromGameType(gameType: String) -> Int {

        var valueToReturn:Int = 0

        switch gameType {
        case "Poker": valueToReturn = 1
        case "Chess": valueToReturn = 2
        case "Carcassone": valueToReturn = 3
        case "Dominion": valueToReturn = 4
        case "Settlers of Catan": valueToReturn = 5
        case "All Games": valueToReturn = 6

        default: break
        }

        return valueToReturn
    }

    func intFromFrequency(frequency: String) -> Int {

        var valueToReturn:Int = 0

        switch frequency {
        case "No Selection": valueToReturn = 0
        case "I want to start": valueToReturn = 1
        case "Monthly": valueToReturn = 2
        case "Weekly": valueToReturn = 3
        case "Almost Daily": valueToReturn = 4
        case "Daily": valueToReturn = 5

        default: break
        }

        return valueToReturn
    }


    func intFromAge(age: String) -> Int {

        var valueToReturn:Int = 0

        switch age {
        case "No Selection": valueToReturn = 0
        case "18-25": valueToReturn = 1
        case "25-35": valueToReturn = 2
        case "35-45": valueToReturn = 3
        case "45+": valueToReturn = 4

        default: break
        }

        return valueToReturn
    }


    func intFromOpenness(openness: String) -> Int {

        var valueToReturn:Int = 0

        switch openness {
        case "No Selection": valueToReturn = 0
        case "Not Very Open": valueToReturn = 1
        case "Somewhat Open": valueToReturn = 2
        case "Open": valueToReturn = 3
        default: break
        }

        return valueToReturn
    }


    func intFromLanguages(languages: String) -> Int {

        var valueToReturn:Int = 0

        switch languages {
        case "German": valueToReturn = 1
        case "English": valueToReturn = 2
        case "German, English": valueToReturn = 3
        case "German, other": valueToReturn = 4
        case "English, other": valueToReturn = 5
        case "German, English, other": valueToReturn = 6
        default: break
        }

        return valueToReturn
    }


    func intFromTopic(topic: String) -> Int {

        var valueToReturn:Int = 0

        switch topic {
        case "Politics": valueToReturn = 1
        case "TV Series, Movies": valueToReturn = 2
        case "Lifestyle News": valueToReturn = 3
        case "Sport News": valueToReturn = 4
        case "Anything": valueToReturn = 5

        default: break
        }

        return valueToReturn
    }


    func intFromMyGender(gender: String) -> Int {

        var valueToReturn:Int = 0

        switch gender {
        case "Man": valueToReturn = 1
        case "Woman": valueToReturn = 2
        default: break
        }

        return valueToReturn
    }

    func intFromPartnering(myGender: String, interestedInGender: String) -> Int {

        var valueToReturn:Int = 0
        
        if myGender == "Woman" && interestedInGender == "Men" {
            valueToReturn = 1
        } else if myGender == "Woman" && interestedInGender == "Women" {
            valueToReturn = 2
        } else if myGender == "Man" && interestedInGender == "Women" {
            valueToReturn = 3
        } else if myGender == "Man" && interestedInGender == "Men" {
            valueToReturn = 4
        }
        
        return valueToReturn
    }
}
