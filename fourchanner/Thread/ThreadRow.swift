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
            }
            
            Text((thread.sub ?? "").replacingOccurrences(of: "&amp;", with: "&"))
                .fontWeight(.heavy)
            
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
                        tim: nil
                    )
        )
    }
}
