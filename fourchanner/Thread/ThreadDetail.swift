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
                var errorThread = Thread(
                    no: 404,
                    now: "00/00/00(---)00:00:00",
                    sticky: 1,
                    name: "Oops",
                    sub: nil,
                    com: nil,
                    tim: nil,
                    replies: 123456,
                    ext: nil,
                    capcode: "",
                    resto: 0
                )
                
                do {
                    let posts : PostList =  try load("https://a.4cdn.org/\(board.board)/thread/\(threadno).json")
                    return posts.posts
                } catch fourchannerError.URLNotFound(let url) {
                    errorThread.sub = "URL \(url) not found :))"
                    return [errorThread]
                } catch fourchannerError.DataNotRetrieved(let url) {
                    errorThread.sub = "Couldn't retrieve data from \(url)"
                    return [errorThread]
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
