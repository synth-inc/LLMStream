//
//  AnimationConfiguration.swift
//  LLMStream
//
//  Created by Kévin Naudin on 20/03/2025.
//

import SwiftUI

public struct AnimationConfiguration {
    public var thoughtExpandAnimation: Animation
    public var shimmerAnimation: Animation
    public var shimmerGradient: Gradient
    
    public init(
        thoughtExpandAnimation: Animation = .spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0),
        shimmerAnimation: Animation = .linear(duration: 1.5).delay(0.25).repeatForever(autoreverses: false),
        shimmerGradient: Gradient = Gradient(colors: [
            .black.opacity(0.3),
            .black,
            .black.opacity(0.3)
        ])
    ) {
        self.thoughtExpandAnimation = thoughtExpandAnimation
        self.shimmerAnimation = shimmerAnimation
        self.shimmerGradient = shimmerGradient
    }
}
