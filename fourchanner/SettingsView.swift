//
//  SettingsView.swift
//  fourchanner
//
//  Created by Artichaut on 20/01/2022.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("hideNSFW") var hideNSFW : Bool = true
    
    var body: some View {
        VStack {
            
            Text("Settings")
                .font(.title)
                .padding([.top, .leading, .trailing])
            
            List {
                HStack {
                    Toggle(isOn: $hideNSFW) {
                        Label("Hide NSFW boards", systemImage: "eyes")
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
