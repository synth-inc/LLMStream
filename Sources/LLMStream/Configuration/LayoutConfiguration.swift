//
//  LayoutConfiguration.swift
//  LLMStream
//
//  Created by Kévin Naudin on 20/03/2025.
//

import SwiftUI

public struct LayoutConfiguration {
    public var contentPadding: EdgeInsets
    public var codePadding: EdgeInsets
    public var thoughtPadding: EdgeInsets
    public var tablePadding: EdgeInsets
    public var spacing: CGFloat
    public var cornerRadius: CGFloat
    public var tableCornerRadius: CGFloat
    public var theoremCornerRadius: CGFloat
    
    public init(
        contentPadding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
        codePadding: EdgeInsets = EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16),
        thoughtPadding: EdgeInsets = EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
        tablePadding: EdgeInsets = EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
        spacing: CGFloat = 8,
        cornerRadius: CGFloat = 8,
        tableCornerRadius: CGFloat = 5,
        theoremCornerRadius: CGFloat = 4
    ) {
        self.contentPadding = contentPadding
        self.codePadding = codePadding
        self.thoughtPadding = thoughtPadding
        self.tablePadding = tablePadding
        self.spacing = spacing
        self.cornerRadius = cornerRadius
        self.tableCornerRadius = tableCornerRadius
        self.theoremCornerRadius = theoremCornerRadius
    }
}
