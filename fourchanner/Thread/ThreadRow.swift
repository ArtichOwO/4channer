//
//  ThreadRow.swift
//  fourchanner
//
//  Created by Artichaut on 16/01/2022.
//

import SwiftUI
import WrappingHStack
import SwiftSoup
import HTMLEntities

struct ThreadRow: View {
    let board : Board
    let thread : Thread
    
    var body: some View {
        VStack(alignment: .leading) {
            WrappingHStack {
                if ((thread.sticky ?? 0) != 0) {
                    Image(systemName: "pin.circle.fill")
                        .foregroundColor(Color.green)
                }
                
                if (thread.capcode != nil) {
                    Image(systemName: "leaf.circle")
                        .foregroundColor(Color.red)
                }
                
                Text(verbatim: "\(thread.no)")
                    .fontWeight(.light)
                Text(thread.name ?? "[NO NAME]")
            }
            
            if let html = thread.sub {
                Text(html.htmlUnescape())
                    .fontWeight(.heavy)
            }
            
            VStack {
                if (((thread.tim ?? -1) > 0) && thread.ext != nil) {
                    AsyncImage(url: URL(string: "https://i.4cdn.org/\(board.board)/\(thread.tim!)\(thread.ext!)")) { phase in
                       if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: ContentMode.fit)
                                .padding(.top)
                        } else if phase.error != nil {
                            Text(verbatim: "Error loading file \(thread.tim!)\(thread.ext!)")
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.red)
                        } else {
                            ProgressView()
                                .frame(
                                    width: 30,
                                    height: 30
                                )
                        }
                    }
                }
                
                htmlToText(thread.com ?? "", opNum: String(thread.resto))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top)
                
                if let replies = thread.replies {
                    Text("\(replies) replies")
                        .fontWeight(.thin)
                        .padding(.top)
                }
            }
        }
        .padding(.bottom)
        .contextMenu {
            Button(action: { ShareSheetURL("https://boards.4channel.org/\(board.board)/thread/\(thread.resto == 0 ? thread.no : thread.resto)#p\(thread.no)")
            }, label: {
                Label("Share post", systemImage: "square.and.arrow.up")
            })
            
            if (thread.tim != nil) {
                Button(action: {
                    UIImageWriteToSavedPhotosAlbum(
                        UIImage(data: try! Data(contentsOf: URL(string: "https://i.4cdn.org/\(board.board)/\(thread.tim!)\(thread.ext!)")!))!,
                        nil, nil, nil)
                }, label: {
                    Label("Download image", systemImage: "square.and.arrow.down")
                })
            }
            
            if let html = thread.com {
                Button(action: {
                    UIPasteboard.general.string = html.htmlUnescape()
                }, label: {
                    Label("Copy text", systemImage: "doc.on.clipboard")
                })
            }
            
            Button(action: {
                UIPasteboard.general.string = "https://boards.4channel.org/\(board.board)/thread/\(thread.resto == 0 ? thread.no : thread.resto)#p\(thread.no)"
            }, label: {
                Label("Copy link", systemImage: "link")
            })
        }
    }
    
    private func ShareSheetURL(_ url: String) {
        let av = UIActivityViewController(
            activityItems: [URL(string: url)!],
            applicationActivities: nil
        )
        
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
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
                        capcode: nil,
                        resto: 0
                    )
        )
    }
}
