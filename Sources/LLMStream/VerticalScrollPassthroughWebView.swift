//
//  VerticalScrollPassthroughWebView.swift
//  MarkdownLatexWebview
//
//  Created by Kévin Naudin on 19/03/2025.
//

import WebKit

#if os(iOS)
import UIKit

class VerticalScrollPassthroughWebView: WKWebView, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    private var panGesture: UIPanGestureRecognizer?

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture?.delegate = self
        addGestureRecognizer(panGesture!)
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 1
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        if abs(translation.x) > abs(translation.y) {
            self.scrollView.panGestureRecognizer.isEnabled = true
        } else {
            self.scrollView.panGestureRecognizer.isEnabled = false
            superview?.gestureRecognizers?.forEach { $0.isEnabled = true }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
#else
class VerticalScrollPassthroughWebView: WKWebView {
    override func scrollWheel(with event: NSEvent) {
        if abs(event.scrollingDeltaX) > abs(event.scrollingDeltaY) {
            super.scrollWheel(with: event)
        } else {
            nextResponder?.scrollWheel(with: event)
        }
    }
}
#endif
