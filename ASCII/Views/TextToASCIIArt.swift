//
//  TextToASCIIArt.swift
//  ASCII
//
//  Created by Raphael Iniesta Reis on 28/11/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct TextToASCIIArt: View {
    
    let size: CGFloat = 25.0
    
    @State var text: String = ""
    @StateObject var ascii = ASCIIModel()
    @State var copiedToClipboard: Bool = false
    @State var selectedFont: String = "standard"
    
    private func getText(text: String, font: String) {
        Task {
            await ascii.fetchFromAPI(text: text, font: font)
        }
    }
    
    private func fetchFonts() {
        Task {
            await ascii.fetchFonts()
        }
    }
    
    var body: some View {
        VStack {
            if(ascii.loadingFonts) {
                LoadingView()
            } else {
                
                Menu {
                    Picker(selection: $selectedFont, label: EmptyView()) {
                        ForEach(ascii.fonts.fonts, id: \.self) { font in
                            Text(font.capitalized).tag(font)
                        }
                    }
                } label: {
                    Text("Selected font: \(selectedFont.capitalized)")
                }
                
                ScrollView {
                    if ascii.loading {
                        LoadingView()
                            .containerRelativeFrame(.vertical)
                    }
                    
                    Text(ascii.ascii.ascii)
                        .font(.custom("RobotoMono-Regular", size: 24))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                HStack {
                    TextField("", text: $text)
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        getText(text: stringTreatment(for: text), font: selectedFont)
                        text = ""
                    } label: {
                        Image(systemName: "paperplane.circle.fill")
                            .resizable()
                            .frame(width: size, height: size)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding()
        .toolbar {
//            ToolbarItem {
//                Picker("Selected font: \(selectedFont)", selection: $selectedFont) {
//                    ForEach(ascii.fonts.fonts, id: \.self) { font in
//                        Text(font.capitalized).tag(font)
//                    }
//                }
//            }
            
            ToolbarItem {
                Button {
                    UIPasteboard.general.setValue("```\(ascii.ascii.ascii)```", forPasteboardType: UTType.plainText.identifier)
                    withAnimation(.snappy) {
                        copiedToClipboard = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.snappy) {
                            copiedToClipboard = false
                        }
                    }
                } label: {
                    Image(systemName: "square.on.square")
                }
            }
        }
        .overlay {
            if copiedToClipboard {
                Text("Copied to clipboard!")
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.cyan.cornerRadius(20))
                    .padding(.bottom)
                    .shadow(radius: 5)
                    .transition(.move(edge: .bottom))
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .onAppear {
            fetchFonts()
        }
    }
}

#Preview {
    TextToASCIIArt()
}
