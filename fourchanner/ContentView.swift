//
//  ContentView.swift
//  fourchanner
//
//  Created by Artichaut on 16/01/2022.
//

import SwiftUI

struct ContentView: View {
    var boards: [Board]
    
    var body: some View {
        NavigationView {
            List(boards, id: \.self) { board in
                NavigationLink(destination: Text(board.title)) {
                    Text(board.board)
                }
            }
            
            .navigationBarTitle("4channer")
            .navigationBarItems(trailing:
                HStack {
                    ForEach(0..<4) { _ in
                        Image(systemName: "leaf")
                            .foregroundColor(Color.green)
                            .imageScale(/*@START_MENU_TOKEN@*/.small/*@END_MENU_TOKEN@*/)
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
