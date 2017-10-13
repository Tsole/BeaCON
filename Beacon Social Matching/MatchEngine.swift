//
//  File.swift
//  BeaCON
//
//  Created by Tsole on 9/12/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import Foundation
import RealmSwift

class MatchEngine: NSObject {

    func isItAMatch(receivedInterest: MegaInterest)->String { //will return the Major of the matched interest, if such an interest exists

        var valueToReturn = "No"
        let realm = try! Realm()

        //let predicate = NSPredicate(format: "interestType = %@ AND status = %@", receivedInterest.interestType, "Active")
        let predicate = NSPredicate(format: "interestType = %@", receivedInterest.interestType)
        let myInterestsOfThisType = realm.objects(SavedInterest).filter(predicate)
        //print(myInterestsOfThisType.count)

        if receivedInterest.interestType == InterestType.Sport.rawValue {
            for myInterest in myInterestsOfThisType {
                if myInterest.title == "All Sports" || receivedInterest.title == "All Sports" {
                    return myInterest.major
                } else {
                    if myInterest.title == receivedInterest.title {
                        return myInterest.major
                    }
                }
            }
        }

        if receivedInterest.interestType == InterestType.BoardGames.rawValue {
            for myInterest in myInterestsOfThisType {
                //print(myInterest.title)
                //print(receivedInterest.title)
                if myInterest.title == "All Games" || receivedInterest.title == "All Games" {
                    return myInterest.major
                } else {
                    if myInterest.title == receivedInterest.title {
                        return myInterest.major
                    }
                }
            }
        }

        if receivedInterest.interestType == InterestType.SmallTalk.rawValue {
            for myInterest in myInterestsOfThisType {
                print("My " + myInterest.identifier)
                print("Received " + receivedInterest.identifier)
                if myInterest.identifier == "Smalltalk Topic: Anything" || receivedInterest.identifier == "Smalltalk Topic: Anything" {
                    return myInterest.major
                } else {
                    if myInterest.title == receivedInterest.identifier {
                        return myInterest.major
                    }
                }
            }
        }

        if receivedInterest.interestType == InterestType.Language.rawValue {

            for myLanguageTandemInterest in myInterestsOfThisType {
                let myMajor = String(myLanguageTandemInterest.major)
                let languageISpeak = myMajor[myMajor.startIndex]
                let languageIWantToPractice = myMajor[myMajor.startIndex.advancedBy(4)]

                let broadcastersMajor = String(receivedInterest.major)
                let languageBroadcasterSpeaks = broadcastersMajor[broadcastersMajor.startIndex]
                let languageBroadcasterWantsToPractice = broadcastersMajor[broadcastersMajor.startIndex.advancedBy(4)]

                if languageISpeak == languageBroadcasterWantsToPractice && languageIWantToPractice == languageBroadcasterSpeaks {
                    valueToReturn = myLanguageTandemInterest.major
                }
            }
        }

        if receivedInterest.interestType == InterestType.Partner.rawValue {

            for partnerInterest in myInterestsOfThisType {
                let myMajor = String(partnerInterest.major)
                let myPartneringInterest = myMajor[myMajor.startIndex.advancedBy(1)]

                let broadcastersMajor = String(receivedInterest.major)
                let broadcastersPartneringInterest = broadcastersMajor[broadcastersMajor.startIndex.advancedBy(1)]

                if myPartneringInterest == broadcastersPartneringInterest && (myPartneringInterest == "2" || myPartneringInterest == "4"){
                    //valueToReturn = true
                    valueToReturn = partnerInterest.major
                }

                if myPartneringInterest == "1" && broadcastersPartneringInterest == "3" {
                    //valueToReturn = true
                    valueToReturn = partnerInterest.major
                }

                if myPartneringInterest == "3" && broadcastersPartneringInterest == "1" {
                    //valueToReturn = true
                    valueToReturn = partnerInterest.major
                }
            }
        }
        return valueToReturn
    }
}