//
//  ContentView.swift
//  LLMStreamExample
//
//  Created by Kévin Naudin on 14/03/2026.
//

import SwiftUI
import LLMStream

struct ContentView: View {
    private let sampleMarkdown = """
    # LLMStream iOS Example

    This is a **test** of the `LLMStream` library on iOS.

    ## Markdown Features

    - **Bold text** and *italic text*
    - `Inline code` support
    - [Link to Apple](https://www.apple.com)

    ## Code Block

    ```swift
    struct HelloWorld: View {
        var body: some View {
            Text("Hello, World!")
        }
    }
    ```

    ## LaTeX Support

    Inline math: $E = mc^2$

    Block math:

    $$\\int_{0}^{\\infty} e^{-x^2} dx = \\frac{\\sqrt{\\pi}}{2}$$

    ## Table

    | Feature | Status |
    |---------|--------|
    | Markdown | Supported |
    | LaTeX | Supported |
    | Links | Supported |
    | Code blocks | Supported |

    <think>
    This is an example of a thought process block that can be collapsed.
    The LLM is "thinking" here before providing its answer.
    </think>

    The answer after the thought process is **42**.
    """

    var body: some View {
        NavigationView {
            ScrollView {
                LLMStreamView(
                    text: sampleMarkdown,
                    onUrlClicked: { url in
                        guard let url = URL(string: url) else { return }
                        UIApplication.shared.open(url)
                    }
                )
            }
            .background(Color.black)
            .navigationTitle("LLMStream")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
