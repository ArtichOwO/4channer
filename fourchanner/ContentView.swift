//
//  ContentView.swift
//  fourchanner
//
//  Created by Artichaut on 16/01/2022.
//

import SwiftUI

struct ContentView: View {
    let boards: [Board]
    
    var body: some View {
        NavigationView {
            List(boards) { board in
                NavigationLink(destination: BoardDetail(board: board)) {
                    BoardRow(board: board)
                }
            }
            
            .navigationBarTitle("4channer")
            .navigationBarItems(trailing:
                HStack {
                    ForEach(0..<4) { _ in
                        Image(systemName: "leaf")
                            .foregroundColor(Color.green)
                            .imageScale(.small)
                    }
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(boards: [Board(board: "p", title: "Preview", meta_description: "A preview board")])
    }
}
