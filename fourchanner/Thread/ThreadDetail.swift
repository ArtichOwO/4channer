//
//  ThreadDetail.swift
//  fourchanner
//
//  Created by Artichaut on 16/01/2022.
//

import SwiftUI

struct ThreadDetail: View {
    let board : Board
    let threadno : Int
    
    var body: some View {
        List {
            ForEach ({ () -> [Thread] in
                do {
                    let posts : PostList =  try load("https://a.4cdn.org/\(board.board)/thread/\(threadno).json")
                    return posts.posts
                } catch fourchannerError.URLNotFound(let url) {
                    return [Thread(
                        no: 69,
                        now: "00/00/00(---)00:00:00",
                        sticky: 1,
                        name: "Oops",
                        sub: "URL \(url) not found :))",
                        com: "",
                        tim: nil,
                        replies: 123456,
                        ext: nil,
                        capcode: nil,
                        resto: 0
                    )]
                } catch {
                    fatalError()
                }
            }()) { post in
                ThreadRow(board: board, thread: post)
            }
        }
    }
}

struct ThreadDetail_Previews: PreviewProvider {
    static var previews: some View {
        ThreadDetail(board: Board(
            board: "p",
            title: "Preview",
            meta_description: "Preview thread"
        ), threadno: 123456)
    }
}

struct PostList: Hashable, Codable {
    let posts : [Thread]
}
