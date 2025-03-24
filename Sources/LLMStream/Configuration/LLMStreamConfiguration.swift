import SwiftUI

public struct LLMStreamConfiguration {

    // MARK: - Properties
    
    public var font: FontConfiguration
    public var colors: ColorConfiguration
    public var layout: LayoutConfiguration
    public var thought: ThoughtConfiguration
    public var animation: AnimationConfiguration
    public var codeBlock: CodeBlockConfiguration
    public var table: TableConfiguration
    public var citation: CitationConfiguration
    
    // MARK: - Initializer
    
    public init(
        font: FontConfiguration = FontConfiguration(),
        colors: ColorConfiguration = ColorConfiguration(),
        layout: LayoutConfiguration = LayoutConfiguration(),
        thought: ThoughtConfiguration = ThoughtConfiguration(),
        animation: AnimationConfiguration = AnimationConfiguration(),
        codeBlock: CodeBlockConfiguration = CodeBlockConfiguration(),
        table: TableConfiguration = TableConfiguration(),
        citation: CitationConfiguration = CitationConfiguration()
    ) {
        self.font = font
        self.colors = colors
        self.layout = layout
        self.thought = thought
        self.animation = animation
        self.codeBlock = codeBlock
        self.table = table
        self.citation = citation
    }
    
    // MARK: - Preset Themes
    
    public static var `default`: LLMStreamConfiguration {
        LLMStreamConfiguration()
    }
    
    public static var dark: LLMStreamConfiguration {
        LLMStreamConfiguration(
            colors: ColorConfiguration(
                textColor: .white,
                backgroundColor: Color(red: 0.11, green: 0.11, blue: 0.12),
                codeBackgroundColor: Color(red: 0.15, green: 0.15, blue: 0.16),
                codeBorderColor: Color(white: 0.3),
                linkColor: Color(red: 0.4, green: 0.65, blue: 1.0),
                thoughtBackgroundColor: Color(white: 0.2, opacity: 0.3)
            )
        )
    }
    
    public static var light: LLMStreamConfiguration {
        LLMStreamConfiguration(
            colors: ColorConfiguration(
                textColor: .black,
                backgroundColor: .white,
                codeBackgroundColor: Color(red: 0.96, green: 0.96, blue: 0.96),
                codeBorderColor: Color(white: 0.9),
                linkColor: Color.blue,
                thoughtBackgroundColor: Color(white: 0.95)
            )
        )
    }
} 
