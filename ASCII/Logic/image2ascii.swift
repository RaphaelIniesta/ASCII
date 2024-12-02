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
