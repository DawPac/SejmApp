//
//  Print.swift
//  SejmApp
//
//  Created by Dawid Paćkowski on 17/01/2024.
//

import Foundation

struct Print: Codable, Hashable {
    var number:String
    var deliveryDate:String
    var title:String
    var attachments:[String]
}
