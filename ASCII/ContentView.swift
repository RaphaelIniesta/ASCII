//
//  ContentView.swift
//  ASCII
//
//  Created by Raphael Iniesta Reis on 26/11/24.
//

import SwiftUI
import PhotosUI

enum Tabs {
    case img2ascii
    case text2ascii
}

struct ContentView: View {
    
    @State private var selectedTab: Tabs = .img2ascii
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                
                Tab("Image to ASCII", systemImage: "photo.on.rectangle.angled", value: .img2ascii) {
                    ImageToASCII()
                }
                
                Tab("Text to ASCII", systemImage: "textformat.abc", value: .text2ascii) {
                    TextToASCIIArt()
                }
            }
        }
        .tabViewStyle(.tabBarOnly)
    }
}

#Preview {
    ContentView()
}
