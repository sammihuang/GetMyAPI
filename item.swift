//
//  item.swift
//  GetMyAPI
//
//
//

import Foundation



struct ItemData: Codable {
    var data: [Item]
}


struct Item: Codable {
    
    var latitude: String
    var longitude: String
}
