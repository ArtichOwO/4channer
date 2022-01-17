//
//  fourchannerApp.swift
//  fourchanner
//
//  Created by Artichaut on 16/01/2022.
//

import SwiftSoup
import SwiftUI

let defaults = UserDefaults.standard

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

func htmlToText(_ html: String) -> Text {
    do {
        let doc: Document = try SwiftSoup.parse(html.replacingOccurrences(of: "<br>", with: "/{newline}/"))
        return Text(try doc.text().replacingOccurrences(of: "/{newline}/", with: "\n"))
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
