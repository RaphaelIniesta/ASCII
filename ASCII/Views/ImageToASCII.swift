//
//  ImageToASCII.swift
//  ASCII
//
//  Created by Raphael Iniesta Reis on 28/11/24.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct ImageToASCII: View {
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var copiedToClipboard: Bool = false
    
    var body: some View {
        
        VStack {
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                Text("Select a Photo")
            }
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
            
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                
                Button("Cpnvert to ASCII Art") {
                    if let result = img2gs(cgImage: Image2CGImage(image: uiImage)) {
                        let (values, cgImage) = result
                        
                        if let validImage = cgImage {
                            let final = imageToASCIIArt(of: validImage, values: values)
                            
                            UIPasteboard.general.setValue(final, forPasteboardType: UTType.plainText.identifier)
                            withAnimation(.snappy) {
                                copiedToClipboard = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation(.snappy) {
                                    copiedToClipboard = false
                                }
                            }
                        }
                    }
                }
                
//                if let result = img2gs(cgImage: Image2CGImage(image: uiImage)) {
//                    let (values, cgImage) = result
//                    
//                    if let validImage = cgImage {
//                        let final = imageToASCIIArt(of: validImage, values: values)
//                        if setValues(final: final) {
////                            print("Copiado")
//                        }
//                    }
//                }
                
//                imageToASCIIArt(of: cgImage, values: values)
                
            }
        }
        .overlay {
            if(copiedToClipboard) {
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
    }
}


#Preview {
    ImageToASCII()
}
