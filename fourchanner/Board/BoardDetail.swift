//
//  BoardDetail.swift
//  fourchanner
//
//  Created by Artichaut on 16/01/2022.
//

import SwiftUI

struct BoardDetail: View {
    let board : Board
    
    var body: some View {
        TabView {
            ForEach({ () -> [Page] in
                do {
                    return try load("https://a.4cdn.org/\(board.board)/catalog.json")
                } catch fourchannerError.URLNotFound(let url) {
                    return [Page(
                        page: 404,
                        threads: [Thread(
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
                    )]
                } catch {
                    fatalError()
                }
            }()) { page in
                List(page.threads) { thread in
                    NavigationLink(destination: ThreadDetail(
                        board: board,
                        threadno: thread.no
                    )) {
                        ThreadRow(board: board, thread: thread)
                    }
                }
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        )
        .tabViewStyle(PageTabViewStyle())
        .navigationBarTitle("/\(board.board)/ - \(board.title)", displayMode: .inline)
    }
}

struct BoardDetail_Previews: PreviewProvider {
    static var previews: some View {
        BoardDetail(board: Board(board: "p", title: "Preview", meta_description: "A preview board"))
    }
}
