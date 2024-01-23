//
//  Vote.swift
//  SejmApp
//
//  Created by Dawid Paćkowski on 17/01/2024.
//

import Foundation

struct Vote: Decodable, Hashable {
    var abstain: Int
    var date: String
    //var description: String
    var kind:String
    var no:  Int
    var notParticipating: Int
    var sitting: Int
    //var sittingDay: Int
    //var term: Int
    var title: String
    var topic: String?
    var totalVoted: Int
    var votingNumber: Int
    var yes: Int
    var votingOptions: [Options]?
    var votes: [VoteDetails]?
}

struct Options: Decodable, Hashable {
    var option: String
    var optionIndex: Int
    var votes: Int
}

struct VoteDetails: Decodable, Hashable {
    var MP: Int
    var club: String
    var vote: String
}
