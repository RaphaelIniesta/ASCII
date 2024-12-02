//
//  Converter.swift
//  ASCII
//
//  Created by Raphael Iniesta Reis on 28/11/24.
//

import Foundation
import SwiftUI
import CoreGraphics


func Image2CGImage(image: UIImage) -> CGImage! {
    
    guard let ciImage = CIImage(image: image) else {
        return nil
    }
    
    let context = CIContext(options: nil)
    return context.createCGImage(ciImage, from: ciImage.extent)
}
