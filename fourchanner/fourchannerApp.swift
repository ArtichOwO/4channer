//
//  fourchannerApp.swift
//  fourchanner
//
//  Created by Artichaut on 16/01/2022.
//

import SwiftSoup
import HTMLEntities
import SwiftUI

let defaults = UserDefaults.standard

let NSFWBoards = [
    "s", "hc", "hm", "h",
    "e", "u", "d", "y",
    "t", "hr", "gif", "aco",
    "r", "b", "bant", "r9k",
    "pol", "soc", "s4s"
]

@main
struct fourchannerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(boards: {
                var errorBoard = Board(
                    board: "err",
                    title: "Error",
                    meta_description: ""
                )
                
                do {
                    let boards : BoardList = try load("https://a.4cdn.org/boards.json")
                    return boards.boards
                } catch fourchannerError.URLNotFound(let url) {
                    errorBoard.meta_description = "URL \(url) not found"
                    return [errorBoard]
                } catch fourchannerError.DataNotRetrieved(let url) {
                    errorBoard.meta_description = "Couldn't retrieve data from \(url)"
                    return [errorBoard]
                } catch {
                    fatalError()
                }
            }())
        }
    }
}

enum fourchannerError: Error {
    case URLNotFound(String)
    case DataNotRetrieved(String)
}

func load<T: Decodable>(_ url: String) throws -> T {
    print("Fetching \(url)")
    
    var json_data : Data
    if let urlData = URL(string: url) {
        do {
            json_data = try Data(contentsOf: urlData)
        } catch {
            throw fourchannerError.DataNotRetrieved(url)
        }
    } else {
        throw fourchannerError.URLNotFound(url)
    }
    
    do {
        print("Done fetching \(url)")
        return try JSONDecoder().decode(T.self, from: json_data)
    } catch {
        print(error)
        fatalError(error.localizedDescription)
    }
}

func htmlToText(_ html: String, opNum : String = "0") -> Text {
    do {
        let doc : Document = try SwiftSoup.parseBodyFragment(html)
        var output = Text("")
        
        var nextLink : String? = nil
        
        for node in doc.body()!.getChildNodes() {
            if (node is TextNode) {
                output = output + Text((try node.outerHtml()).htmlUnescape())
            } else {
                var nodeText : Text = Text("")
                
                switch (node.nodeName()) {
                case "br":
                    nodeText = Text("\n")
                    break
                case "wbr":
                    break
                case "a":
                    if (node.getChildNodes().count == 0) {
                        nextLink = try node.attr("href")
                        break
                    }
                    
                    if (try node.attr("class") == "quotelink") {
                        let opText = String(try node.attr("href")) == "#p" + opNum ? " (OP)" : ""
                        nodeText = Text(try (((node as? Element)?.text() ?? "[invalid link]") + opText)).foregroundColor(.red)
                        nextLink = nil
                        break
                    }
                    
                    nodeText = Text(try ((node as? Element)?.text() ?? "[invalid link]")).foregroundColor(.blue)
                    break
                case "span":
                    if (try node.attr("class") == "quote") {
                        nodeText = Text(try ((node as? Element)?.text() ?? "[invalid quote]")).foregroundColor(.green)
                    }
                    break
                case "pre":
                    print(html)
                    for codeNode : Node in node.getChildNodes() {
                        if (codeNode.nodeName() == "br") {
                            nodeText = nodeText + Text("\n")
                        } else {
                            nodeText = nodeText + Text(try codeNode.outerHtml().htmlUnescape()).font(Font.custom("JetBrainsMono-Regular", size: 12)).foregroundColor(.yellow)
                        }
                    }
                    break
                case "i":
                    nodeText = Text(try (node as? Element)?.text() ?? "[invalid ital]")
                        .italic()
                    break
                default:
                    nodeText = Text(try node.outerHtml().htmlUnescape()).foregroundColor(.red)
                }
                
                output = output + nodeText
            }
        }
        return output
    } catch Exception.Error(let _, let message) {
        return Text(message)
    } catch {
        return Text("error")
    }
}

func saveStringArrayUserSetting(_ array: [String]) -> Data {
    do {
        return try JSONEncoder().encode(array)
    } catch {
        print(error)
        fatalError(error.localizedDescription)
    }
}

func loadStringArrayUserSetting(_ data: Data) -> [String] {
    do {
        return try JSONDecoder().decode([String].self, from: data)
    } catch {
        print(error)
        fatalError(error.localizedDescription)
    }
}
