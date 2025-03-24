//
//  MarkdownLatexView.swift
//  MarkdownLatexWebview
//
//  Created by Kévin Naudin on 10/03/2025.
//

import SwiftUI
import WebKit

#if os(iOS)
public struct MarkdownLatexViewiOS: UIViewRepresentable, @preconcurrency MarkdownLatexViewShared {
    typealias ViewContext = Context
    var content: String
    var height: Binding<CGFloat>
    let configuration: LLMStreamConfiguration
    let onUrlClicked: ((String) -> Void)
    let onCodeAction: ((String) -> Void)?
    
    public init(
        content: String,
        height: Binding<CGFloat>,
        configuration: LLMStreamConfiguration,
        onUrlClicked: @escaping ((String) -> Void),
        onCodeAction: ((String) -> Void)? = nil
    ) {
        self.content = content
        self.height = height
        self.configuration = configuration
        self.onUrlClicked = onUrlClicked
        self.onCodeAction = onCodeAction
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> WKWebView {
        return makeWebView(context: context)
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
        if context.coordinator.lastContent != content {
            context.coordinator.lastContent = content
            loadHTML(in: webView)
        }
    }
}
#else
public struct MarkdownLatexViewMacOS: NSViewRepresentable, @preconcurrency MarkdownLatexViewShared {
    typealias ViewContext = Context
    var content: String
    var height: Binding<CGFloat>
    let configuration: LLMStreamConfiguration
    let onUrlClicked: ((String) -> Void)
    let onCodeAction: ((String) -> Void)?
    
    public init(
        content: String,
        height: Binding<CGFloat>,
        configuration: LLMStreamConfiguration,
        onUrlClicked: @escaping ((String) -> Void),
        onCodeAction: ((String) -> Void)? = nil
    ) {
        self.content = content
        self.height = height
        self.configuration = configuration
        self.onUrlClicked = onUrlClicked
        self.onCodeAction = onCodeAction
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeNSView(context: Context) -> WKWebView {
        return makeWebView(context: context)
    }

    public func updateNSView(_ webView: WKWebView, context: Context) {
        if context.coordinator.lastContent != content {
            context.coordinator.lastContent = content
            loadHTML(in: webView)
        }
    }
}
#endif

// Common typealias to provide a unified API
#if os(iOS)
public typealias MarkdownLatexView = MarkdownLatexViewiOS
#else
public typealias MarkdownLatexView = MarkdownLatexViewMacOS
#endif

// Protocol to share common functionality
private protocol MarkdownLatexViewShared {
    var content: String { get }
    var height: Binding<CGFloat> { get }
    var configuration: LLMStreamConfiguration { get }
    var onUrlClicked: ((String) -> Void) { get }
    var onCodeAction: ((String) -> Void)? { get }
    
    associatedtype ViewContext
    @MainActor func makeWebView(context: ViewContext) -> WKWebView
}

#if os(iOS)
extension MarkdownLatexViewiOS {
    func makeWebView(context: UIViewRepresentableContext<MarkdownLatexViewiOS>) -> WKWebView {
        makeSharedWebView(coordinator: context.coordinator)
    }
}
#else
extension MarkdownLatexViewMacOS {
    func makeWebView(context: NSViewRepresentableContext<MarkdownLatexViewMacOS>) -> WKWebView {
        makeSharedWebView(coordinator: context.coordinator)
    }
}
#endif

// Common extension to share code between platforms
@MainActor
private extension MarkdownLatexViewShared {
    var cssContent: String {
        """
        :root {
            /* Font Configuration */
            --font-size: \(Int(configuration.font.size))px;
            --line-height: \(configuration.font.lineHeight);
            --font-family: \(configuration.font.family);
            --code-font-family: \(configuration.font.codeFontFamily);
            --table-font-family: \(configuration.font.tableFontFamily);
            --math-font-family: \(configuration.font.mathFontFamily);
            
            /* Color Configuration */
            --text-color: \(configuration.colors.textColor.cssString);
            --background-color: \(configuration.colors.backgroundColor.cssString);
            --code-background-color: \(configuration.colors.codeBackgroundColor.cssString);
            --code-border-color: \(configuration.colors.codeBorderColor.cssString);
            --link-color: \(configuration.colors.linkColor.cssString);
            --thought-background-color: \(configuration.colors.thoughtBackgroundColor.cssString);
            --table-header-background-color: \(configuration.colors.tableHeaderBackgroundColor.cssString);
            --table-border-color: \(configuration.colors.tableBorderColor.cssString);
            --table-row-even-color: \(configuration.colors.tableRowEvenColor.cssString);
            --table-row-hover-color: \(configuration.colors.tableRowHoverColor.cssString);
            --theorem-border-color: \(configuration.colors.theoremBorderColor.cssString);
            --proof-border-color: \(configuration.colors.proofBorderColor.cssString);
            
            /* Citation Configuration */
            --citation-background-color: \(configuration.citation.backgroundColor.cssString);
            --citation-hover-background-color: \(configuration.citation.hoverBackgroundColor.cssString);
            --citation-text-color: \(configuration.citation.textColor.cssString);
            --citation-hover-text-color: \(configuration.citation.hoverTextColor.cssString);
            --citation-border-radius: \(configuration.citation.borderRadius)px;
            --citation-padding: \(configuration.citation.padding.top)px \(configuration.citation.padding.trailing)px \(configuration.citation.padding.bottom)px \(configuration.citation.padding.leading)px;
            --citation-margin: \(configuration.citation.margin.top)px \(configuration.citation.margin.trailing)px \(configuration.citation.margin.bottom)px \(configuration.citation.margin.leading)px;
            
            /* Layout Configuration */
            --content-padding: \(configuration.layout.contentPadding.top)px \(configuration.layout.contentPadding.trailing)px \(configuration.layout.contentPadding.bottom)px \(configuration.layout.contentPadding.leading)px;
            --code-padding: \(configuration.layout.codePadding.top)px \(configuration.layout.codePadding.trailing)px \(configuration.layout.codePadding.bottom)px \(configuration.layout.codePadding.leading)px;
            --thought-padding: \(configuration.layout.thoughtPadding.top)px \(configuration.layout.thoughtPadding.trailing)px \(configuration.layout.thoughtPadding.bottom)px \(configuration.layout.thoughtPadding.leading)px;
            --table-padding: \(configuration.layout.tablePadding.top)px \(configuration.layout.tablePadding.trailing)px \(configuration.layout.tablePadding.bottom)px \(configuration.layout.tablePadding.leading)px;
            --spacing: \(configuration.layout.spacing)px;
            --corner-radius: \(configuration.layout.cornerRadius)px;
            --table-corner-radius: \(configuration.layout.tableCornerRadius)px;
            --theorem-corner-radius: \(configuration.layout.theoremCornerRadius)px;
            
            /* Code Block Configuration */
            --show-language: \(configuration.codeBlock.showLanguage ? "flex" : "none");
            --show-copy-button: \(configuration.codeBlock.showCopyButton ? "block" : "none");
            --show-action-button: \(configuration.codeBlock.showActionButton ? "block" : "none");
            --language-text-size: \(configuration.codeBlock.languageTextSize)px;
            --copy-button-size: \(configuration.codeBlock.copyButtonSize)px;
            --action-button-size: \(configuration.codeBlock.actionButtonSize)px;
            --copy-button-opacity: \(configuration.codeBlock.copyButtonOpacity);
            --copy-button-hover-opacity: \(configuration.codeBlock.copyButtonHoverOpacity);
            --copy-button-icon: \(configuration.codeBlock.copyButtonIcon?.cssString ?? "url('copy.svg')");
            --action-button-opacity: \(configuration.codeBlock.actionButtonOpacity);
            --action-button-hover-opacity: \(configuration.codeBlock.actionButtonHoverOpacity);
            --action-button-icon: \(configuration.codeBlock.actionButtonIcon?.cssString ?? "none");
            --action-button-tooltip: "\(configuration.codeBlock.actionButtonTooltip)";
            
            /* Table Configuration */
            --show-caption: \(configuration.table.showCaption ? "block" : "none");
            --table-caption-font-size: \(configuration.table.captionStyle.fontSize)em;
            --table-caption-color: \(configuration.table.captionStyle.textColor.cssString);
            --table-header-font-weight: \(configuration.table.headerStyle.fontWeight.cssString);
            --table-header-text-align: \(configuration.table.headerStyle.textAlignment.cssString);
            --table-header-border-width: \(configuration.table.headerStyle.borderWidth)px;
            --enable-hover: \(configuration.table.enableHover ? "table-row" : "none");
            --enable-zebra-stripes: \(configuration.table.enableZebraStripes ? "table-row" : "none");
        }
        """
    }
    
    
    func makeSharedWebView(coordinator: Coordinator) -> WKWebView {
        let cssVariables = """
            const style = document.createElement('style');
            style.textContent = `\(cssContent)`;
            document.head.appendChild(style);
        """
        let cssScript = WKUserScript(
            source: cssVariables,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        
        let config = WKWebViewConfiguration()
        config.userContentController.add(coordinator, name: "heightUpdate")
        config.userContentController.add(coordinator, name: "log")
        config.userContentController.add(coordinator, name: "urlClicked")
        config.userContentController.add(coordinator, name: "codeAction")
        config.userContentController.addUserScript(cssScript)
        
        let webView = VerticalScrollPassthroughWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = coordinator
        #if os(macOS)
        webView.setValue(false, forKey: "drawsBackground")
        webView.allowsMagnification = false
        #else
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        #endif

        coordinator.lastContent = content
        loadHTML(in: webView)
        return webView
    }

    func loadHTML(in webView: WKWebView) {
        guard let bundlePath = Bundle.module.path(forResource: "markdownLatex", ofType: "html"),
              var htmlContent = try? String(contentsOfFile: bundlePath, encoding: .utf8) else {
            return
        }
        
        // Set hasActionCallback before content is loaded
        webView.evaluateJavaScript("window.hasActionCallback = \(onCodeAction != nil);")
        
        let encodedMarkdown = MarkdownLatexTextProcessor.cleanLatexDocuments(in: content)
        
        // Si c'est le premier chargement, on charge la page HTML complète
        if !webView.isLoading && webView.url == nil {
            htmlContent = htmlContent.replacingOccurrences(of: "[TEXT]", with: encodedMarkdown)

            let cssVariables = """
                const styleElement = document.querySelector('style');
                if (styleElement) {
                    styleElement.textContent = `\(cssContent)`;
                } else {
                    const style = document.createElement('style');
                    style.textContent = `\(cssContent)`;
                    document.head.appendChild(style);
                }
            """
            // Inject CSS variables
            let initScript = WKUserScript(
                source: "window.hasActionCallback = \(onCodeAction != nil);",
                injectionTime: .atDocumentStart,
                forMainFrameOnly: true
            )
            webView.configuration.userContentController.addUserScript(initScript)
            
            webView.evaluateJavaScript(cssVariables)
            webView.loadHTMLString(htmlContent, baseURL: Bundle.module.resourceURL)
        } else {
            print("\(encodedMarkdown)")
            webView.evaluateJavaScript("window.markdownContent = `\(encodedMarkdown)`; renderMarkdown();")
        }
    }
}

// Common Coordinator class
public class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
    #if os(iOS)
    var parent: MarkdownLatexViewiOS
    
    init(_ parent: MarkdownLatexViewiOS) {
        self.parent = parent
    }
    #else
    var parent: MarkdownLatexViewMacOS
    
    init(_ parent: MarkdownLatexViewMacOS) {
        self.parent = parent
    }
    #endif
    
    var lastContent: String = ""
    private var lastHeightUpdate: Date = .distantPast
    private let minimumUpdateInterval: TimeInterval = 0.1
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "heightUpdate" {
            guard let height = message.body as? Double else { return }
            
            let now = Date()
            if now.timeIntervalSince(lastHeightUpdate) >= minimumUpdateInterval {
                DispatchQueue.main.async {
                    self.parent.height.wrappedValue = CGFloat(height)
                }
                lastHeightUpdate = now
            }
        }
        if message.name == "log" {
             guard let message = message.body as? String else { return }
             print("LLMStream - JS: " + message)
        }
        if message.name == "codeAction" {
            guard let code = message.body as? String else { return }
            DispatchQueue.main.async {
                self.parent.onCodeAction?(code)
            }
        }
        if message.name == "urlClicked" {
            guard let url = message.body as? String else { return }
            DispatchQueue.main.async {
                self.parent.onUrlClicked(url)
            }
        }
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            webView.evaluateJavaScript("updateHeight();")
        }
    }
}
