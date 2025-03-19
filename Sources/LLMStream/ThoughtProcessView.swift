//
//  ThoughtProcessView.swift
//  MarkdownLatexWebview
//
//  Created by Kévin Naudin on 20/03/2025.
//

import SwiftUI

struct ThoughtProcessView: View {
    let content: String
    let streaming: Bool
    let configuration: LLMStreamConfiguration
    
    @State private var isExpanded: Bool = false
    
    var title: String {
        streaming ? configuration.thought.thinkingTitle : configuration.thought.thoughtTitle
    }
    
    var arrowImageName: String {
        isExpanded ? "chevron.up" : "chevron.down"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let icon = configuration.thought.icon {
                    icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: configuration.thought.iconSize, height: configuration.thought.iconSize)
                }
                Text(title)
                    .font(.headline)
                    .foregroundColor(configuration.colors.textColor)
                    .shimmering(
                        active: streaming,
                        animation: configuration.animation.shimmerAnimation,
                        gradient: configuration.animation.shimmerGradient
                    )
                Spacer()
                if configuration.thought.showExpandButton && !streaming {
                    Image(systemName: arrowImageName)
                        .foregroundColor(configuration.colors.textColor)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                // Only allow expanding if the thought block is complete
                if !streaming {
                    withAnimation(configuration.animation.thoughtExpandAnimation) {
                        isExpanded.toggle()
                    }
                }
            }
            
            if isExpanded && !streaming {
                Text(content)
                    .padding(.leading, 20)
                    .lineSpacing((configuration.font.lineHeight * configuration.font.size) - configuration.font.size)
                    .foregroundColor(configuration.colors.textColor)
            }
        }
        .padding(configuration.layout.thoughtPadding)
        .background(configuration.colors.thoughtBackgroundColor)
        .cornerRadius(configuration.layout.cornerRadius)
    }
}
