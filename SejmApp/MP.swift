//
//  MP.swift
//  SejmApp
//
//  Created by Dawid Paćkowski on 23/01/2024.
//

import Foundation

struct MP: Decodable, Identifiable {
    var active:Bool
    var birthDate:String
    var birthLocation:String
    var club:String
    var districtName:String
    var districtNum:Int
    var educationLevel:String
    var email:String
    var firstLastName:String
    //var firstName:String
    var id:Int
    //var lastFirstName:String
    //var lastName:String
    var numberOfVotes:Int
    //var secondName:String
    var voivodeship:String
}
