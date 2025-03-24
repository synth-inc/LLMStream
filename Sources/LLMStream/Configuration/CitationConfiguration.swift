//
//  CitationConfiguration.swift
//  LLMStream
//
//  Created by Kévin Naudin on 20/03/2025.
//

import SwiftUI

public struct CitationConfiguration {
    // MARK: - Properties
    
    /// La couleur de fond pour les citations
    public var backgroundColor: Color
    
    /// La couleur de fond au survol pour les citations
    public var hoverBackgroundColor: Color
    
    /// La couleur du texte pour les citations
    public var textColor: Color
    
    /// La couleur du texte au survol pour les citations
    public var hoverTextColor: Color
    
    /// Le rayon de bordure des citations
    public var borderRadius: Double
    
    /// L'espacement intérieur (padding) des citations
    public var padding: EdgeInsets
    
    /// La marge extérieure (margin) des citations
    public var margin: EdgeInsets
    
    // MARK: - Initializer
    
    public init(
        backgroundColor: Color = Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.2),
        hoverBackgroundColor: Color = Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.4),
        textColor: Color? = nil,
        hoverTextColor: Color? = nil,
        borderRadius: Double = 4,
        padding: EdgeInsets = EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4),
        margin: EdgeInsets = EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2)
    ) {
        self.backgroundColor = backgroundColor
        self.hoverBackgroundColor = hoverBackgroundColor
        self.textColor = textColor ?? Color.white
        self.hoverTextColor = hoverTextColor ?? Color.accentColor
        self.borderRadius = borderRadius
        self.padding = padding
        self.margin = margin
    }
}
