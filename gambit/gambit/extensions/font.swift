//
//  font.swift
//  atlas
//
//  Created by Nick Mantini on 9/27/24.
//

import SwiftUICore
import VFont

extension Font {
    static func inter(size: CGFloat, width: CGFloat = 0, weight: CGFloat = 0) -> Font {
        return .vFont("Inter", size: size, axes: [
            2003072104: width,
            2003265652: weight
        ])
    }
}
