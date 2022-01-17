//
//  ContentView.swift
//  fourchanner
//
//  Created by Artichaut on 16/01/2022.
//

import SwiftUI

struct ContentView: View {
    let boards: [Board]
    
    @AppStorage("favorites") var favorites : Data = saveStringArrayUserSetting([])
    
    var body: some View {
        NavigationView {
            List {
                if (loadStringArrayUserSetting(favorites) != []) {
                    Section(header: Text("Favorites")) {
                        ForEach(loadStringArrayUserSetting(favorites), id: \.self) { favorite in
                            if let favoriteBoard = boards.first(where: { $0.board == favorite }) {
                                NavigationLink(destination: BoardDetail(board: favoriteBoard)) {
                                    BoardRow(board: favoriteBoard, favorite: true)
                                    .contextMenu {
                                        Button(action: {
                                            self.favorites = saveStringArrayUserSetting(loadStringArrayUserSetting(favorites).filter { $0 != favoriteBoard.board })
                                        }, label: {
                                            Label("Unfavorite", systemImage: "star.slash.fill")
                                                .foregroundColor(.yellow)
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Boards")) {
                    ForEach(boards) { board in
                        NavigationLink(destination: BoardDetail(board: board)) {
                            // https://stackoverflow.com/questions/70159437/context-menu-not-updating-in-swiftui
                            if (loadStringArrayUserSetting(favorites).contains(board.board)) {
                                BoardRowContextMenu(board, favorite: true)
                            } else {
                                BoardRowContextMenu(board)
                            }
                        }
                    }
                }
            }
            
            Text("Welcome on 4channer :D")
            
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
    
    private func BoardRowContextMenu(_ board: Board, favorite: Bool = false) -> some View {
        BoardRow(board: board, favorite: favorite)
        .contextMenu {
            Button(action: {
                if (loadStringArrayUserSetting(favorites).contains(board.board)) {
                    self.favorites = saveStringArrayUserSetting(loadStringArrayUserSetting(favorites).filter { $0 != board.board })
                } else {
                    self.favorites = saveStringArrayUserSetting(loadStringArrayUserSetting(favorites) + [board.board])
                }
            }, label: {
                Label(
                    loadStringArrayUserSetting(favorites).contains(board.board) ? "Unfavorite" : "Favorite",
                    systemImage: loadStringArrayUserSetting(favorites).contains(board.board) ? "star.slash.fill" : "star.fill")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(boards: [Board(board: "p", title: "Preview", meta_description: "A preview board")])
    }
}
