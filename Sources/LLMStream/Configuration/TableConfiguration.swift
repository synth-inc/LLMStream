//
//  TableConfiguration.swift
//  LLMStream
//
//  Created by Kévin Naudin on 20/03/2025.
//

import SwiftUI

public struct TableConfiguration {
    public var showCaption: Bool
    public var captionStyle: CaptionStyle
    public var headerStyle: HeaderStyle
    public var enableHover: Bool
    public var enableZebraStripes: Bool
    
    public struct CaptionStyle {
        public var fontSize: Double
        public var textColor: Color
        
        public init(
            fontSize: Double = 0.9,
            textColor: Color = Color(white: 0.8)
        ) {
            self.fontSize = fontSize
            self.textColor = textColor
        }
    }
    
    public struct HeaderStyle {
        public var fontWeight: Font.Weight
        public var textAlignment: TextAlignment
        public var borderWidth: Double
        
        public init(
            fontWeight: Font.Weight = .bold,
            textAlignment: TextAlignment = .center,
            borderWidth: Double = 2.0
        ) {
            self.fontWeight = fontWeight
            self.textAlignment = textAlignment
            self.borderWidth = borderWidth
        }
    }
    
    public init(
        showCaption: Bool = true,
        captionStyle: CaptionStyle = CaptionStyle(),
        headerStyle: HeaderStyle = HeaderStyle(),
        enableHover: Bool = true,
        enableZebraStripes: Bool = true
    ) {
        self.showCaption = showCaption
        self.captionStyle = captionStyle
        self.headerStyle = headerStyle
        self.enableHover = enableHover
        self.enableZebraStripes = enableZebraStripes
    }
}
