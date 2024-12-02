//
//  Entities.swift
//  ASCII
//
//  Created by Raphael Iniesta Reis on 01/12/24.
//

import Foundation

struct ASCII: Identifiable, Decodable {
    var id: String?
    var text: String
    var font: String
    var ascii: String
}

struct ASCIIFonts: Identifiable, Decodable {
    var id: String?
    var fonts: [String]
}
