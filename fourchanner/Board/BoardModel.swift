//
//  BoardModel.swift
//  fourchanner
//
//  Created by Artichaut on 16/01/2022.
//

import Foundation

struct Board: Hashable, Codable {
    var board : String
    var title : String
    var meta_description : String
}

struct BoardList: Hashable, Codable {
    var boards : [Board]
}
