//
//  MarkdownLatexTextProcessor.swift
//  Synth, Inc
//
//  Created by Kévin Naudin on 17/03/2025.
//

import AppKit

struct MarkdownLatexTextProcessor {
    
    static func cleanLatexDocuments(in text: String) -> String {
        func postProcess(_ text: String) -> String {
            return text.replacingOccurrences(of: "\\", with: "\\\\")
                .replacingOccurrences(of: "`", with: "\\`")
                .replacingOccurrences(of: "$", with: "\\$")
                .replacingOccurrences(of: "\n", with: "\\n")
                .replacingOccurrences(of: "\r", with: "\\r")
                .replacingOccurrences(of: "\t", with: "\\t")
        }
        
        if !text.contains("\\begin{document}") || !text.contains("\\end{document}") {
            return postProcess(text)
        }
        
        var result = ""
        var currentIndex = text.startIndex
        
        let docClassPattern = "\\\\documentclass(?:\\[[^\\]]*\\])?\\{[^\\}]*\\}"
        let docStartPattern = "\\\\begin\\{document\\}"
        let docEndPattern = "\\\\end\\{document\\}"
        
        while currentIndex < text.endIndex {
            if let docClassRange = text[currentIndex...].range(of: docClassPattern, options: .regularExpression),
               let startRange = text[docClassRange.upperBound...].range(of: docStartPattern, options: .regularExpression) {
                
                result += text[currentIndex..<docClassRange.lowerBound]
                
                guard let endRange = text[startRange.upperBound...].range(of: docEndPattern, options: .regularExpression) else {
                    result += text[currentIndex...]
                    break
                }
                
                let documentContent = text[startRange.upperBound..<endRange.lowerBound]
                
                if let processedContent = processLatexDocumentContent(documentContent) {
                    result += processedContent
                }
                
                currentIndex = endRange.upperBound
            } else {
                result += text[currentIndex...]
                break
            }
        }
        
        return postProcess(result)
    }
    
    private static func processLatexDocumentContent(_ content: Substring) -> String? {
        let cleanedContent = String(content)
        let processedContent = cleanLatexCommands(cleanedContent)
        let finalContent = processedContent.replacingOccurrences(of: "\\n\\s*\\n\\s*\\n", with: "\n\n")
        
        return finalContent.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private static func cleanLatexCommands(_ text: String) -> String {
        var cleanedContent = text
        
        let commandsToRemove = [
            "\\\\title\\{[^\\}]*\\}",
            "\\\\author\\{[^\\}]*\\}",
            "\\\\date\\{[^\\}]*\\}",
            "\\\\thanks\\{[^\\}]*\\}",
            "\\\\institute\\{[^\\}]*\\}",
            "\\\\documentclass\\{[^\\}]*\\}",
            "\\\\usepackage(?:\\[[^\\]]*\\])?\\{[^\\}]*\\}",
            "\\\\bibliographystyle\\{[^\\}]*\\}",
            "\\\\tableofcontents",
            "\\\\listoffigures",
            "\\\\listoftables",
            "\\\\begin\\{abstract\\}[\\s\\S]*?\\\\end\\{abstract\\}",
            "\\\\printbibliography(?:\\[[^\\]]*\\])?",
            "\\\\maketitle"
        ]
        
        for pattern in commandsToRemove {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                let range = NSRange(cleanedContent.startIndex..., in: cleanedContent)
                cleanedContent = regex.stringByReplacingMatches(
                    in: cleanedContent,
                    options: [],
                    range: range,
                    withTemplate: ""
                )
            }
        }
        
        return cleanedContent.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
