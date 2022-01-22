//
//  ReloadButton.swift
//  fourchanner
//
//  Created by Artichaut on 22/01/2022.
//

import SwiftUI

struct ReloadButton: View {
    var callback : (() -> Void)
    
    @State var timeElapsed = 0
    
    var body: some View {
        HStack {
            if (timeElapsed == 0) {
                Button(action: {
                    Task {
                        callback()
                        timeElapsed = 10
                        await delayLoad()
                    }
                }, label: {
                    Image(systemName: "arrow.2.circlepath")
                })
            } else {
                Text("\(timeElapsed)")
                Image(systemName: "arrow.2.circlepath")
            }
        }
    }
    
    private func delayLoad() async {
        while timeElapsed > 0 {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            timeElapsed -= 1
        }
    }
}

struct ReloadButton_Previews: PreviewProvider {
    static var previews: some View {
        ReloadButton(callback: {})
    }
}
