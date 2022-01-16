//
//  BoardModel.swift
//  fourchanner
//
//  Created by Artichaut on 16/01/2022.
//

import Foundation

struct Board: Hashable, Codable {
    let board : String
    let title : String
    let meta_description : String
}

struct BoardList: Hashable, Codable {
    let boards : [Board]
}
