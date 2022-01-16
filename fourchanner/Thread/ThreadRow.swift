//
//  ThreadRow.swift
//  fourchanner
//
//  Created by Artichaut on 16/01/2022.
//

import SwiftUI

struct ThreadRow: View {
    let board : Board
    let thread : Thread
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if ((thread.sticky ?? 0) != 0) {
                    Image(systemName: "pin.circle.fill")
                        .foregroundColor(Color.green)
                }
                Text(verbatim: "\(thread.no)")
                    .fontWeight(.light)
                Text(thread.name ?? "[NO NAME]")
                if (thread.capcode != nil) {
                    Text("[\(thread.capcode!)]")
                        .foregroundColor(Color.red)
                }
            }
            
            Text((thread.sub ?? "").replacingOccurrences(of: "&amp;", with: "&"))
                .fontWeight(.heavy)
            
            VStack {
                if (((thread.tim ?? -1) > 0) && thread.ext != nil) {
                    AsyncImage(url: URL(string: "https://i.4cdn.org/\(board.board)/\(thread.tim!)\(thread.ext!)")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: ContentMode.fit)
                    } placeholder: {
                        ProgressView()
                            .frame(
                                width: 30,
                                height: 30
                            )
                    }
                }
                
                htmlToText(thread.com ?? "")
                
                Text("\(thread.replies) replies")
                    .fontWeight(.thin)
            }
        }
        .padding(.bottom)
    }
}

struct ThreadRow_Previews: PreviewProvider {
    static var previews: some View {
        ThreadRow(board:
                    Board(board: "p", title: "Preview", meta_description: "A preview board"),
                  thread:
                    Thread(
                        no: 69420,
                        now: "00/00/00(---)00:00:00",
                        sticky: 1,
                        name: "Anonymous",
                        sub: "Preview",
                        com: "A preview thread",
                        tim: 1546293948883,
                        replies: 123456,
                        ext: nil,
                        capcode: nil
                    )
        )
    }
}
