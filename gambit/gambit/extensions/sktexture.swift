//
//  sktexture.swift
//  gambit
//
//  Created by Nick Mantini on 11/21/24.
//

import SpriteKit

extension SKTexture {
    convenience init(size: CGSize, colors: [UIColor]) {
        let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!

        let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors.map { $0.cgColor } as CFArray,
            locations: nil
        )!

        context.drawLinearGradient(
            gradient,
            start: CGPoint(x: 0, y: size.height),
            end: CGPoint(x: size.width, y: 0),
            options: []
        )

        let cgImage = context.makeImage()!
        self.init(cgImage: cgImage)
    }
}
