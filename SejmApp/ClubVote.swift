//
//  ClubVote.swift
//  SejmApp
//
//  Created by Dawid Paćkowski on 22/01/2024.
//

import Foundation

struct ClubVote: Hashable {
    var club: String
    var yes: Int
    var no: Int
    var absent: Int
    var abstain: Int
    var id = UUID()
}


