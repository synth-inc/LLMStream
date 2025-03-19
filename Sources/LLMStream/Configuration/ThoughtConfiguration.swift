//
//  ThoughtConfiguration.swift
//  LLMStream
//
//  Created by Kévin Naudin on 20/03/2025.
//

import SwiftUI

public struct ThoughtConfiguration {
    public var icon: Image?
    public var iconSize: CGFloat
    public var thinkingTitle: String
    public var thoughtTitle: String
    public var showExpandButton: Bool
    
    public init(
        icon: Image? = nil,
        iconSize: CGFloat = 16,
        thinkingTitle: String = "Thinking...",
        thoughtTitle: String = "Thought-process",
        showExpandButton: Bool = true
    ) {
        self.icon = icon
        self.iconSize = iconSize
        self.thinkingTitle = thinkingTitle
        self.thoughtTitle = thoughtTitle
        self.showExpandButton = showExpandButton
    }
}
