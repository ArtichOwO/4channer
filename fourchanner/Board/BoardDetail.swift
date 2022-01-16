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
                            tim: nil
                        )]
                    )]
                } catch {
                    fatalError()
                }
            }()) { page in
                List(page.threads) { thread in
                    VStack(alignment: .leading) {
                        HStack {
                            if ((thread.sticky ?? 0) != 0) {
                                Image(systemName: "pin.circle.fill")
                                    .foregroundColor(Color.green)
                            }
                            Text(verbatim: "\(thread.no)")
                            Text(thread.name ?? "[NO NAME]")
                                .fontWeight(.bold)
                        }
                        
                        Text(thread.sub ?? "")
                        
                        HStack {
                            if ((thread.tim ?? -1) > 0) {
                                AsyncImage(url: URL(string: "https://i.4cdn.org/\(board.board)/\(thread.tim!)s.jpg")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: ContentMode.fit)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            
                            Text(thread.com ?? "")
                                .frame(maxHeight: 100)
                                .truncationMode(.tail)
                        }
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
        .navigationBarTitle("/\(board.board)/", displayMode: .inline)
    }
}

struct BoardDetail_Previews: PreviewProvider {
    static var previews: some View {
        BoardDetail(board: Board(board: "p", title: "Preview", meta_description: "A preview board"))
    }
}
