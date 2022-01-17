//
//  BoardRow.swift
//  fourchanner
//
//  Created by Artichaut on 16/01/2022.
//

import SwiftUI

struct BoardRow: View {
    let board : Board
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(board.title)
                    .fontWeight(.bold)
            }
            
            htmlToText(board.meta_description)
                .fontWeight(.thin)
        }
        .padding(.vertical)
    }
}

struct BoardRow_Previews: PreviewProvider {
    static var previews: some View {
        BoardRow(board: Board(board: "p", title: "Preview", meta_description: "A preview board"))
    }
}
