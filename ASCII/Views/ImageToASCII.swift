//
//  ImageToASCII.swift
//  ASCII
//
//  Created by Raphael Iniesta Reis on 28/11/24.
//

import SwiftUI
import PhotosUI

struct ImageToASCII: View {
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
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
            }
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(.gray)
    }
}


#Preview {
    ImageToASCII()
}
