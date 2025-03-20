//
//  CodeBlockConfiguration.swift
//  LLMStream
//
//  Created by Kévin Naudin on 20/03/2025.
//

import SwiftUI

public struct CodeBlockConfiguration {
    public var showLanguage: Bool
    public var showCopyButton: Bool
    public var showActionButton: Bool
    public var languageTextSize: Double
    public var copyButtonSize: CGFloat
    public var actionButtonSize: CGFloat
    public var copyButtonOpacity: Double
    public var copyButtonHoverOpacity: Double
    public var copyButtonIcon: Image?
    public var actionButtonOpacity: Double
    public var actionButtonHoverOpacity: Double
    public var actionButtonIcon: Image?
    public var actionButtonTooltip: String
    
    public init(
        showLanguage: Bool = true,
        showCopyButton: Bool = true,
        showActionButton: Bool = false,
        languageTextSize: Double = 13.0,
        copyButtonSize: CGFloat = 16,
        actionButtonSize: CGFloat = 16,
        copyButtonOpacity: Double = 0.5,
        copyButtonHoverOpacity: Double = 1.0,
        copyButtonIcon: Image? = nil,
        actionButtonOpacity: Double = 0.5,
        actionButtonHoverOpacity: Double = 1.0,
        actionButtonIcon: Image? = nil,
        actionButtonTooltip: String = "Execute"
    ) {
        self.showLanguage = showLanguage
        self.showCopyButton = showCopyButton
        self.showActionButton = showActionButton
        self.languageTextSize = languageTextSize
        self.copyButtonSize = copyButtonSize
        self.actionButtonSize = actionButtonSize
        self.copyButtonOpacity = copyButtonOpacity
        self.copyButtonHoverOpacity = copyButtonHoverOpacity
        self.copyButtonIcon = copyButtonIcon
        self.actionButtonOpacity = actionButtonOpacity
        self.actionButtonHoverOpacity = actionButtonHoverOpacity
        self.actionButtonIcon = actionButtonIcon
        self.actionButtonTooltip = actionButtonTooltip
    }
}
