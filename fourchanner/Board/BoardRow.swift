//
//  BoardRow.swift
//  fourchanner
//
//  Created by Artichaut on 16/01/2022.
//

import SwiftUI

struct BoardRow: View {
    var board : Board
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(board.title)
                    .fontWeight(.bold)
            }
            
            Text(board.meta_description.replacingOccurrences(of: "&quot;", with: "\"").replacingOccurrences(of: "&amp;", with: "&"))
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
