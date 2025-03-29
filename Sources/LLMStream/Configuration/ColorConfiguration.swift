//
//  ColorConfiguration.swift
//  LLMStream
//
//  Created by Kévin Naudin on 20/03/2025.
//

import SwiftUI

public struct ColorConfiguration {
    public var textColor: Color
    public var backgroundColor: Color
    public var codeBackgroundColor: Color
    public var codeBorderColor: Color
    public var linkColor: Color
    public var thoughtBackgroundColor: Color
    public var tableHeaderBackgroundColor: Color
    public var tableBorderColor: Color
    public var tableRowEvenColor: Color
    public var tableRowHoverColor: Color
    public var theoremBorderColor: Color
    public var proofBorderColor: Color
    
    /// Citation
    public var citationBackgroundColor: Color
    public var citationHoverBackgroundColor: Color
    public var citationTextColor: Color
    public var citationHoverTextColor: Color
    public var citationFontSizeRatio: Double
    
    public init(
        textColor: Color = .white,
        backgroundColor: Color = .clear,
        codeBackgroundColor: Color = Color(red: 0.15, green: 0.15, blue: 0.15),
        codeBorderColor: Color = Color(white: 0.24),
        linkColor: Color = Color(red: 0.29, green: 0.60, blue: 1.0),
        thoughtBackgroundColor: Color = Color.gray.opacity(0.1),
        tableHeaderBackgroundColor: Color = Color(white: 0.24),
        tableBorderColor: Color = Color(white: 0.4),
        tableRowEvenColor: Color = Color(white: 0.2).opacity(0.2),
        tableRowHoverColor: Color = Color(white: 0.27).opacity(0.3),
        theoremBorderColor: Color = Color(red: 0.29, green: 0.60, blue: 1.0),
        proofBorderColor: Color = Color(white: 0.47),
        citationBackgroundColor: Color = Color(red: 0.15, green: 0.15, blue: 0.15),
        citationHoverBackgroundColor: Color = Color(red: 0.15, green: 0.15, blue: 0.15),
        citationTextColor: Color = .white,
        citationHoverTextColor: Color = .white,
        citationFontSizeRatio: Double = 0.8
    ) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.codeBackgroundColor = codeBackgroundColor
        self.codeBorderColor = codeBorderColor
        self.linkColor = linkColor
        self.thoughtBackgroundColor = thoughtBackgroundColor
        self.tableHeaderBackgroundColor = tableHeaderBackgroundColor
        self.tableBorderColor = tableBorderColor
        self.tableRowEvenColor = tableRowEvenColor
        self.tableRowHoverColor = tableRowHoverColor
        self.theoremBorderColor = theoremBorderColor
        self.proofBorderColor = proofBorderColor
        self.citationBackgroundColor = citationBackgroundColor
        self.citationHoverBackgroundColor = citationHoverBackgroundColor
        self.citationTextColor = citationTextColor
        self.citationHoverTextColor = citationHoverTextColor
        self.citationFontSizeRatio = citationFontSizeRatio
    }
}
