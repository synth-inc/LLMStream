//
//  CSS String+Extension.swift
//  LLMStream
//
//  Created by Kévin Naudin on 20/03/2025.
//

import SwiftUI

extension Color {
    var cssString: String {
        #if os(macOS)
        let color = NSColor(self)
        #else
        let color = UIColor(self)
        #endif
        let components = color.cgColor.components ?? []

        if components.count >= 3 {
            let red = Int(components[0] * 255)
            let green = Int(components[1] * 255)
            let blue = Int(components[2] * 255)
            let alpha = components.count >= 4 ? components[3] : 1.0
            return "rgba(\(red), \(green), \(blue), \(alpha))"
        }
        return "rgba(255, 255, 255, 1.0)"
    }
}

extension Font.Weight {
    var cssString: String {
        switch self {
        case .ultraLight: return "200"
        case .thin: return "300"
        case .light: return "300"
        case .regular: return "400"
        case .medium: return "500"
        case .semibold: return "600"
        case .bold: return "700"
        case .heavy: return "800"
        case .black: return "900"
        default: return "400"
        }
    }
}

extension TextAlignment {
    var cssString: String {
        switch self {
        case .leading: return "left"
        case .center: return "center"
        case .trailing: return "right"
        @unknown default: return "left"
        }
    }
}

extension Image {
    
    @MainActor
    var cssString: String? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = 2.0
        
        #if os(macOS)
        guard let nsImage = renderer.nsImage,
              let tiffData = nsImage.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [.compressionFactor: 1.0]) else {
            return nil
        }
        #else
        guard let uiImage = renderer.uiImage,
              let pngData = uiImage.pngData() else { return nil }
        #endif

        return "url(data:image/png;base64," + pngData.base64EncodedString() + ")"
    }
}
