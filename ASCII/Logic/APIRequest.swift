//
//  APIRequest.swift
//  ASCII
//
//  Created by Raphael Iniesta Reis on 30/11/24.
//

import Foundation

enum ErrorType: Error {
    case requestError, invalidURL, invalidResponse, invalidData
}

class ASCIIModel: ObservableObject {
    
    @Published var ascii: ASCII = ASCII(text: "", font: "", ascii: "")
    @Published var fonts: ASCIIFonts = ASCIIFonts(fonts: [])
    @Published var loading: Bool = false
    @Published var loadingFonts: Bool = false
    @Published var error: ErrorType?
    
    @MainActor
    func fetchFromAPI(text: String, font: String) async {
        
        guard let url = URL(string: "https://figlet-api.onrender.com/ascii?text=\(text)&font=\(font)") else {
            self.error = .invalidURL
            return
        }
                
        self.error = nil
        self.loading = true
        self.ascii = ASCII(text: "", font: "", ascii: "")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            self.loading = false
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                self.error = .invalidResponse
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(ASCII.self, from: data)
                print(decodedData)
                self.ascii = decodedData
            } catch let error {
                print("Error decoding: \(error)")
                self.error = .invalidData
            }
        }catch {
            self.loading = false
            self.error = .requestError
            print("Request error: \(error)")
        }
    }
    
    @MainActor
    func fetchFonts() async {
        
        guard let url = URL(string: "https://figlet-api.onrender.com/fonts") else {
            self.error = .invalidURL
            return
        }
                
        self.error = nil
        self.loading = true
        self.fonts = ASCIIFonts(fonts: [])
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            self.loading = false
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                self.error = .invalidResponse
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([String].self, from: data)
                self.fonts.fonts = decodedData.sorted()
            } catch let error {
                print("Error decoding: \(error)")
                self.error = .invalidData
            }
        }catch {
            self.loading = false
            self.error = .requestError
            print("Request error: \(error)")
        }
    }
}
