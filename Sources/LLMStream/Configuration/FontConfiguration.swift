//
//  FontConfiguration.swift
//  LLMStream
//
//  Created by Kévin Naudin on 20/03/2025.
//

public struct FontConfiguration {
    public var size: Double
    public var lineHeight: Double
    public var family: String
    public var codeFontFamily: String
    public var tableFontFamily: String
    public var mathFontFamily: String
    
    public init(
        size: Double = 14.0,
        lineHeight: Double = 1.4,
        family: String = "-apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, Helvetica, Arial, sans-serif",
        codeFontFamily: String = "\"SF Mono\", Monaco, Menlo, Consolas, \"Ubuntu Mono\", monospace",
        tableFontFamily: String = "system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', 'STIX Two Math', 'Latin Modern Math', serif",
        mathFontFamily: String = "'STIX Two Math', 'Latin Modern Math', serif"
    ) {
        self.size = size
        self.lineHeight = lineHeight
        self.family = family
        self.codeFontFamily = codeFontFamily
        self.tableFontFamily = tableFontFamily
        self.mathFontFamily = mathFontFamily
    }
}
