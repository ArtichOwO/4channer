//
//  BoardRow.swift
//  fourchanner
//
//  Created by Artichaut on 16/01/2022.
//

import SwiftUI
import SwiftSoup

struct BoardRow: View {
    let board : Board
    let favorite : Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if (favorite) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                Text(board.title)
                    .fontWeight(.bold)
            }
            
            Text((try? SwiftSoup.parseBodyFragment(board.meta_description).text()) ?? "error")
                .fontWeight(.thin)
        }
        .padding(.vertical)
    }
}

struct BoardRow_Previews: PreviewProvider {
    static var previews: some View {
        BoardRow(
            board: Board(board: "p", title: "Preview", meta_description: "A preview board"),
            favorite: true
        )
    }
}
