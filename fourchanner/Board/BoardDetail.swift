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
                var errorPage = Page(
                    page: 0,
                    threads: [Thread(
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
                    )]
                )
                
                do {
                    return try load("https://a.4cdn.org/\(board.board)/catalog.json")
                } catch fourchannerError.URLNotFound(let url) {
                    errorPage.threads[0].sub = "URL \(url) not found :))"
                    return [errorPage]
                } catch fourchannerError.DataNotRetrieved(let url) {
                    errorPage.threads[0].sub = "Couldn't retrieve data from \(url)"
                    return [errorPage]
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
