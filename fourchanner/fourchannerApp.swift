//
//  fourchannerApp.swift
//  fourchanner
//
//  Created by Artichaut on 16/01/2022.
//

import SwiftSoup
import SwiftUI

@main
struct fourchannerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(boards: {
                do {
                    let boards : BoardList = try load("https://a.4cdn.org/boards.json")
                    return boards.boards
                } catch fourchannerError.URLNotFound(let url) {
                    return [Board(board: "error", title: "URL not found :(", meta_description: "URL \(url) not found")]
                } catch {
                    fatalError()
                }
            }())
        }
    }
}

enum fourchannerError: Error {
    case URLNotFound(String)
}

func load<T: Decodable>(_ url: String) throws -> T {
    print("Fetching \(url)")
    
    var json_data : Data
    if let urlData = URL(string: url) {
        do {
            json_data = try Data(contentsOf: urlData)
        } catch {
            print(error)
            fatalError(error.localizedDescription)
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

func htmlToText(_ html: String) -> Text {
    do {
       let doc: Document = try SwiftSoup.parse(html)
       return Text(try doc.text())
    } catch Exception.Error(let _, let message) {
        return Text(message)
    } catch {
        return Text("error")
    }
}
