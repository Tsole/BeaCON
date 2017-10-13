//
//  SignalToInterestTransformer.swift
//  BeaCON
//
//  Created by Tsole on 28/11/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import Foundation
import Parse

class SignalToInterestTransformer: NSObject {

    func transformSignalToInterest(interestSignal: InterestSignal) -> MegaInterest {

        let interestToReturn = MegaInterest()

        let major = String(interestSignal.major)
        let first = major[major.startIndex]
        let second = major[major.startIndex.advancedBy(1)]
        let third = major[major.startIndex.advancedBy(2)]
        let fourth = major[major.startIndex.advancedBy(3)]
        let fifth = major[major.startIndex.advancedBy(4)]

        //interestToReturn.sportType = self.sportTypeFromCharacter(first)
        interestToReturn.interestType = interestTypeFromUUID(interestSignal.uuid!)

        if interestToReturn.interestType == InterestType.Sport.rawValue {
            interestToReturn.title = self.sportTypeFromCharacter(first)
            interestToReturn.frequency = self.frequencyFromCharacter(second)
            interestToReturn.myAge = self.myAgeFromCharacter(third)
            interestToReturn.openness = self.oppennessFromCharacter(fourth)
            interestToReturn.languagesISpeak = self.languagesFromCharacter(fifth)
        }

        if interestToReturn.interestType == InterestType.BoardGames.rawValue {
            interestToReturn.title = self.gamesTypeFromCharacter(first)
            interestToReturn.frequency = self.frequencyFromCharacter(second)
            interestToReturn.myAge = self.myAgeFromCharacter(third)
            interestToReturn.openness = self.oppennessFromCharacter(fourth)
            interestToReturn.languagesISpeak = self.languagesFromCharacter(fifth)
        }

        if interestToReturn.interestType == InterestType.SmallTalk.rawValue {
            interestToReturn.title = self.topicFromCharacter(first)
            interestToReturn.myAge = self.myAgeFromCharacter(second)
            interestToReturn.openness = self.oppennessFromCharacter(third)
            interestToReturn.myGender = self.myGenderFromCharacter(fourth)
            interestToReturn.languagesISpeak = self.languagesFromCharacter(fifth)
        }

        if interestToReturn.interestType == InterestType.Language.rawValue {
            interestToReturn.title = self.languageFromCharacter(first)
            interestToReturn.languageIwantToPractice = self.languageFromCharacter(first)
            interestToReturn.languageISpeak = self.languageFromCharacter(fifth)
            interestToReturn.skillLanguageIWantToPractice = self.skilllevelLanguageFromCharacter(second)
            interestToReturn.skillLanguageISpeak = self.skilllevelLanguageFromCharacter(third)
            interestToReturn.openness = self.oppennessFromCharacter(fourth)
        }

        if interestToReturn.interestType == InterestType.Partner.rawValue {
            interestToReturn.myAge = self.myAgeFromCharacter(first)
            interestToReturn.genderMatch = self.genderMatchFromCharacter(second)
            interestToReturn.appearanceBody = self.appearanceBodyFromCharacter(third)
            interestToReturn.openness = self.oppennessFromCharacter(fourth)
            interestToReturn.appearanceHeight = self.appearanceHeightFromCharacter(fifth)
        }

        interestToReturn.identifier = interestToReturn.interestType + " " + interestToReturn.title


        return interestToReturn
    }


    func interestTypeFromUUID(uuid: NSUUID) -> String {

        //print(uuid.UUIDString)
        var valueToReturn = ""
        switch uuid.UUIDString {
        case "78019DB1-B7CA-4DFB-BAB6-1B0576BE6B91": valueToReturn = InterestType.Sport.rawValue
        case "1184ABBD-10C0-435E-8BDC-B53FE77FFB21": valueToReturn = InterestType.Partner.rawValue
        case "B3E13539-91FC-4DCE-9F1F-71ACAF2197BB": valueToReturn = InterestType.BoardGames.rawValue
        case "73310A6F-4998-422C-9773-7B2D92D98006": valueToReturn = InterestType.SmallTalk.rawValue
        case "26602D78-460C-4F43-AC3A-ED949AC14FC6": valueToReturn = InterestType.Language.rawValue

        default: break
        }

        return valueToReturn
    }

    func sportTypeFromCharacter(character:Character) -> String {

        var valueToReturn = ""

        switch character {
        case "1": valueToReturn = "Football"
        case "2": valueToReturn = "Basketball"
        case "3": valueToReturn = "Tennis"
        case "4": valueToReturn = "Running"
        case "5": valueToReturn = "Volleyball"
        case "6": valueToReturn = "All Sports"

        default: break
        }

        return valueToReturn
    }

    func genderMatchFromCharacter(character:Character) -> String {

        var valueToReturn = ""

        switch character {
        case "1": valueToReturn = "Woman interested in men"
        case "2": valueToReturn = "Woman interested in women"
        case "3": valueToReturn = "Man interested in women"
        case "4": valueToReturn = "Man interested in men"

        default: break
        }

        return valueToReturn
    }

    func appearanceBodyFromCharacter(character:Character) -> String {

        var valueToReturn = ""

        switch character {
        case "0": valueToReturn = "No Selection"
        case "1": valueToReturn = "Slim"
        case "2": valueToReturn = "Normal"
        case "3": valueToReturn = "Muscular"
        case "4": valueToReturn = "Large"

        default: break
        }

        return valueToReturn
    }


    func appearanceHeightFromCharacter(character:Character) -> String {

        var valueToReturn = ""

        switch character {
        case "0": valueToReturn = "No Selection"
        case "1": valueToReturn = "0-160cm"
        case "2": valueToReturn = "160-165cm"
        case "3": valueToReturn = "165-170cm"
        case "4": valueToReturn = "170-175cm"
        case "5": valueToReturn = "175-180cm"
        case "6": valueToReturn = "185+cm"

        default: break
        }

        return valueToReturn
    }

    func skilllevelLanguageFromCharacter(character:Character) -> String {

        var valueToReturn = ""

        switch character {
        case "0": valueToReturn = "No Selection"
        case "1": valueToReturn = "Basic"
        case "2": valueToReturn = "Good"
        case "3": valueToReturn = "Very Good"
        case "4": valueToReturn = "Excellent"

        default: break
        }

        return valueToReturn
    }

    func gamesTypeFromCharacter(character:Character) -> String {

        var valueToReturn = ""

        switch character {
        case "1": valueToReturn = "Poker"
        case "2": valueToReturn = "Chess"
        case "3": valueToReturn = "Carcassone"
        case "4": valueToReturn = "Dominion"
        case "5": valueToReturn = "Settlers of Catan"
        case "6": valueToReturn = "All Games"

        default: break
        }

        return valueToReturn
    }


    func topicFromCharacter(character:Character) -> String {

        var valueToReturn = ""

        switch character {
        case "1": valueToReturn = "Politics"
        case "2": valueToReturn = "TV Series, Movies"
        case "3": valueToReturn = "Lifestyle News"
        case "4": valueToReturn = "Sport News"
        case "5": valueToReturn = "Anything"

        default: break
        }

        return valueToReturn
    }

    func languageFromCharacter(character:Character) -> String {

        var valueToReturn = ""

        switch character {
        case "1": valueToReturn = "Spanish"
        case "2": valueToReturn = "German"
        case "3": valueToReturn = "French"
        case "4": valueToReturn = "Chinese"
        case "5": valueToReturn = "Italian"
        case "6": valueToReturn = "English"

        default: break
        }

        return valueToReturn
    }

    func frequencyFromCharacter(character:Character) -> String {

        var valueToReturn = ""

        switch character {
        case "0": valueToReturn = "No Selection"
        case "1": valueToReturn = "I want to start"
        case "2": valueToReturn = "Monthly"
        case "3": valueToReturn = "Weekly"
        case "4": valueToReturn = "Almost Daily"
        case "5": valueToReturn = "Daily"

        default: break
        }

        return valueToReturn
    }


    func myAgeFromCharacter(character:Character) -> String {

        var valueToReturn = ""

        switch character {
        case "0": valueToReturn = "No Selection"
        case "1": valueToReturn = "18-25"
        case "2": valueToReturn = "25-35"
        case "3": valueToReturn = "35-45"
        case "4": valueToReturn = "45+"

        default: break
        }

        return valueToReturn
    }

    func myGenderFromCharacter(character:Character) -> String {

        var valueToReturn = ""

        switch character {
        case "1": valueToReturn = "Man"
        case "2": valueToReturn = "Woman"
        default: break
        }

        return valueToReturn
    }


    func oppennessFromCharacter(character:Character) -> String {

        var valueToReturn = ""

        switch character {
        case "0": valueToReturn = "No Selection"
        case "1": valueToReturn = "Not Very Open"
        case "2": valueToReturn = "Somewhat Open"
        case "3": valueToReturn = "Open"

        default: break
        }

        return valueToReturn
    }

    func languagesFromCharacter(character:Character) -> String {

        var valueToReturn = ""

        switch character {
        case "0": valueToReturn = "No Selection"
        case "1": valueToReturn = "German"
        case "2": valueToReturn = "English"
        case "3": valueToReturn = "German, English"
        case "4": valueToReturn = "German, other"
        case "5": valueToReturn = "English, other"
        case "6": valueToReturn = "German, English, other"

        default: break
        }

        return valueToReturn
    }

}
