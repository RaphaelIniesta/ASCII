//
//  image2ascii.swift
//  ASCII
//
//  Created by Raphael Iniesta Reis on 28/11/24.
//

import Foundation
import CoreGraphics

func img2gs(cgImage: CGImage) -> ([[UInt8]], CGImage?)? {
    let width = cgImage.width
    let height = cgImage.height

    guard let grayscaleColorSpace = CGColorSpace(name: CGColorSpace.genericGrayGamma2_2) else {
        print("Failed to create grayscale color space")
        return nil
    }

    var pixelData = [UInt8](repeating: 0, count: width * height)

    guard let context = CGContext(
        data: &pixelData,
        width: width,
        height: height,
        bitsPerComponent: 8,
        bytesPerRow: width,
        space: grayscaleColorSpace,
        bitmapInfo: CGImageAlphaInfo.none.rawValue
    ) else {
        print("Failed to create CGContext")
        return nil
    }

    let rect = CGRect(x: 0, y: 0, width: width, height: height)
    context.draw(cgImage, in: rect)

    guard let grayscaleCGImage = context.makeImage() else {
        print("Failed to create grayscale CGImage")
        return nil
    }

    var grayscaleValues = [[UInt8]]()
    for row in 0..<height {
        let start = row * width
        let rowValues = Array(pixelData[start..<start + width])
        grayscaleValues.append(rowValues)
    }

    return (grayscaleValues, grayscaleCGImage)
}

func imageToASCIIArt(of image: CGImage, values: [[UInt8]]) -> String {
    let width = image.width
    let height = image.height
    
    let gscale = ["@", "%", "#", "*", "+", "=", "-", ":", ".", " "]
    
    var ascii: [String] = []
    var string = ""
    var output = ""
    
    for i in stride(from: 0, to: height, by: 3) {
        ascii.append("")
        for j in stride(from: 0, to: width, by: 3) {
            if((j+3) < width && (i+3) < height) {
                let avg1 = Int(values[i][j]) + Int(values[i][j+1]) + Int(values[i][j+2])
                let avg2 = Int(values[i+1][j]) + Int(values[i+1][j+1]) + Int(values[i+1][j+2])
                let avg3 = Int(values[i+2][j]) + Int(values[i+2][j+1]) + Int(values[i+2][j+2])
                
                let final = avg1 + avg2 + avg3
                
                string += gscale[Int(final/255)]
            }
        }
        ascii.append(string)
        output += "\n\(string)"
        string = ""
    }
    
    return output
//    write2File(input: ascii, path: "/Users/raphael/Documents/GitHub/ASCII-POC/ASCII-POC/out.txt")
}
