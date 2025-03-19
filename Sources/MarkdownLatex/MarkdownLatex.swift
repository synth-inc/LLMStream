//
//  MarkdownLatex.swift
//  Synth, Inc
//
//  Created by Kévin Naudin on 10/03/2025.
//

import AppKit
import Defaults
import SwiftUI
import WebKit
import os

struct MarkdownLatex: NSViewRepresentable {
    @Default(.fontSize) var fontSize
    @Default(.lineHeight) var lineHeight
    @Default(.fontSize) var codeFontSize
    @Default(.lineHeight) var codeLineHeight
    
    var markdownText: String
    @Binding var webViewHeight: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Self.Context) -> WKWebView {
        let cssVariables = """
            const style = document.createElement('style');
            style.textContent = `
                :root {
                    --font-size: \(Int(fontSize))px;
                    --line-height: \(lineHeight);
                    --code-font-size: \(Int(codeFontSize))px;
                    --code-line-height: \(codeLineHeight);
                }
            `;
            document.head.appendChild(style);
        """
        let cssScript = WKUserScript(
            source: cssVariables,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        
        let config = WKWebViewConfiguration()
        config.userContentController.add(context.coordinator, name: "heightUpdate")
        config.userContentController.add(context.coordinator, name: "log")
        config.userContentController.addUserScript(cssScript)
        
        let webView = VerticalScrollPassthroughWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.setValue(false, forKey: "drawsBackground")
        webView.allowsMagnification = false

        loadHTML(in: webView)
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Self.Context) {
        loadHTML(in: webView)
    }

    private func loadHTML(in webView: WKWebView) {
        guard let bundlePath = Bundle.main.path(forResource: "markdownLatex", ofType: "html"),
              var htmlContent = try? String(contentsOfFile: bundlePath, encoding: .utf8) else {
            return
        }
        print("🔵" + markdownText)
        let encodedMarkdown = MarkdownLatexTextProcessor.cleanLatexDocuments(in: markdownText)
        let cssVariables = """
            const styleElement = document.querySelector('style');
            if (styleElement) {
                styleElement.textContent = `
                    :root {
                        --font-size: \(Int(fontSize))px;
                        --line-height: \(lineHeight);
                        --code-font-size: \(Int(codeFontSize))px;
                        --code-line-height: \(codeLineHeight);
                    }
                `;
            } else {
                const style = document.createElement('style');
                style.textContent = `
                    :root {
                        --font-size: \(Int(fontSize))px;
                        --line-height: \(lineHeight);
                        --code-font-size: \(Int(codeFontSize))px;
                        --code-line-height: \(codeLineHeight);
                    }
                `;
                document.head.appendChild(style);
            }
        """
        webView.evaluateJavaScript(cssVariables)
        
        htmlContent = htmlContent.replacingOccurrences(of: "[TEXT]", with: encodedMarkdown)

        webView.loadHTMLString(htmlContent, baseURL: Bundle.main.resourceURL)
    }

    class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        var parent: MarkdownLatex

        init(_ parent: MarkdownLatex) {
            self.parent = parent
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "heightUpdate" {
                guard let height = message.body as? Double else { return }
                
                DispatchQueue.main.async {
                    self.parent.webViewHeight = CGFloat(height)
                }
            }
            if message.name == "log" {
                guard let message = message.body as? String else { return }
                
                print("JS: " + message)
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("updateHeight();")
        }
    }
}
