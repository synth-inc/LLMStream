//
//  VerticalScrollPassthroughWebView.swift
//  MarkdownLatexWebview
//
//  Created by Kévin Naudin on 19/03/2025.
//

import WebKit

class VerticalScrollPassthroughWebView: WKWebView {
    override func scrollWheel(with event: NSEvent) {
        if abs(event.scrollingDeltaX) > abs(event.scrollingDeltaY) {
            super.scrollWheel(with: event)
        } else {
            nextResponder?.scrollWheel(with: event)
        }
    }
}
