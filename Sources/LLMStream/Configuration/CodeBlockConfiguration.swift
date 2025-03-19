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
    public var languageTextSize: Double
    public var copyButtonSize: CGFloat
    public var copyButtonOpacity: Double
    public var copyButtonHoverOpacity: Double
    
    public init(
        showLanguage: Bool = true,
        showCopyButton: Bool = true,
        languageTextSize: Double = 13.0,
        copyButtonSize: CGFloat = 16,
        copyButtonOpacity: Double = 0.5,
        copyButtonHoverOpacity: Double = 1.0
    ) {
        self.showLanguage = showLanguage
        self.showCopyButton = showCopyButton
        self.languageTextSize = languageTextSize
        self.copyButtonSize = copyButtonSize
        self.copyButtonOpacity = copyButtonOpacity
        self.copyButtonHoverOpacity = copyButtonHoverOpacity
    }
}
