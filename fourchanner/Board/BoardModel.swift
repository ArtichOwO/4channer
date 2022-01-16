//
//  BoardModel.swift
//  fourchanner
//
//  Created by Artichaut on 16/01/2022.
//

import Foundation

struct Board: Hashable, Codable, Identifiable {
    let id = UUID()
    
    let board : String
    let title : String
    let meta_description : String
}

struct BoardList: Hashable, Codable {
    let boards : [Board]
}

struct Thread: Hashable, Codable, Identifiable {
    let id = UUID()
    
    let no : Int
    let now : String
}

struct Page: Hashable, Codable, Identifiable {
    let id = UUID()
    
    let page : Int
    let threads : [Thread]
}
