//
//  LLMStreamView.swift
//  MarkdownLatexWebview
//
//  Created by Kévin Naudin on 20/03/2025.
//

import SwiftUI

public struct LLMStreamView: View {
    let text: String
    let configuration: LLMStreamConfiguration
    let onUrlClicked: ((String) -> Void)
    let onCodeAction: ((String) -> Void)?
    
    // ContentSegment represents either normal text or a thought block
    struct ContentSegment {
        let isThought: Bool
        let isStreaming: Bool
        let content: String
    }
    
    public init(
        text: String,
        configuration: LLMStreamConfiguration = .default,
        onUrlClicked: @escaping ((String) -> Void),
        onCodeAction: ((String) -> Void)? = nil
    ) {
        self.text = text
        self.configuration = configuration
        self.onUrlClicked = onUrlClicked
        self.onCodeAction = onCodeAction
    }
    
    // Split the text into segments based on <think> and </think> tags.
    var segments: [ContentSegment] {
        var result: [ContentSegment] = []
        var currentIndex = text.startIndex
        
        while let openRange = text.range(of: "<think>", range: currentIndex..<text.endIndex) {
            // Add normal text before <think> if any
            let normalText = String(text[currentIndex..<openRange.lowerBound])
            if !normalText.isEmpty {
                result.append(ContentSegment(isThought: false, isStreaming: false, content: normalText))
            }
            
            let searchStart = openRange.upperBound
            if let closeRange = text.range(of: "</think>", range: searchStart..<text.endIndex) {
                // Found closing tag: complete thought block
                let thoughtContent = String(text[searchStart..<closeRange.lowerBound])
                result.append(ContentSegment(isThought: true, isStreaming: false, content: thoughtContent))
                currentIndex = closeRange.upperBound
            } else {
                // No closing tag found: streaming thought block
                let thoughtContent = String(text[searchStart..<text.endIndex])
                result.append(ContentSegment(isThought: true, isStreaming: true, content: thoughtContent))
                currentIndex = text.endIndex
            }
        }
        
        if currentIndex < text.endIndex {
            let remaining = String(text[currentIndex..<text.endIndex])
            if !remaining.isEmpty {
                result.append(ContentSegment(isThought: false, isStreaming: false, content: remaining))
            }
        }
        return result
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.layout.spacing) {
            ForEach(Array(segments.enumerated()), id: \.offset) { index, segment in
                if segment.isThought {
                    ThoughtProcessView(
                        content: segment.content,
                        streaming: segment.isStreaming,
                        configuration: configuration
                    )
                } else {
                    MarkdownLatexSegmentView(
                        content: segment.content,
                        configuration: configuration,
                        onUrlClicked: onUrlClicked,
                        onCodeAction: onCodeAction
                    )
                }
            }
        }
        .padding(configuration.layout.contentPadding)
        .background(configuration.colors.backgroundColor)
    }
}

private struct MarkdownLatexSegmentView: View {
    let content: String
    let configuration: LLMStreamConfiguration
    let onUrlClicked: ((String) -> Void)
    let onCodeAction: ((String) -> Void)?
    
    @State private var height: CGFloat = 0
    
    var body: some View {
        MarkdownLatexView(
            content: content,
            height: $height,
            configuration: configuration,
            onUrlClicked: onUrlClicked,
            onCodeAction: onCodeAction
        )
        .textSelection(.enabled)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: height)
    }
}
