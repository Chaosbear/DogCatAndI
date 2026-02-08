//
//  Shimmer.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 8/2/2569 BE.
//

import SwiftUI

/// A view modifier that applies an animated "shimmer" to any view, typically to show that an operation is in progress.
struct Shimmer: ViewModifier {
    enum ShimmerDirection {
        case rightToLeft
        case leftToRight
        case topToBottom
        case bottomToTop
        case topLeftToBottomRight
        case topRightToBottomLeft
        case bottomLeftToTopRight
        case bottomRightToTopLeft
    }

    private let animation: Animation
    private let gradient: Gradient
    private let direction: ShimmerDirection
    private let bandSize: CGFloat
    @State private var isInitialState = true

    /// Initializes his modifier with a custom animation,
    /// - Parameters:
    ///   - animation: A custom animation. Defaults to ``Shimmer/defaultAnimation``.
    ///   - gradient:  A custom gradient. Defaults to ``Shimmer/defaultGradient``.
    ///   - bandSize:  The size of the animated mask's "band". Defaults to 0.3 unit points, which corresponds to
    ///                30% of the extent of the gradient.
    init(
        animation: Animation = Self.defaultAnimation(),
        gradient: Gradient = Self.defaultGradient(),
        bandSize: CGFloat = 0.4,
        direction: ShimmerDirection
    ) {
        self.animation = animation
        self.gradient = gradient
        self.bandSize = bandSize
        self.direction = direction
    }

    /// The default animation effect.
    static func defaultAnimation(_ time: TimeInterval = 1.2) -> Animation {
        Animation.linear(duration: time).delay(0.25).repeatForever(autoreverses: false)
    }

    // A default gradient for the animated mask.
    static func defaultGradient() -> Gradient {
        Gradient(colors: [
            Color(DSColor.gray9),
            Color(DSColor.gray10),
            Color(DSColor.gray9)
        ])
    }

    /// The start unit point of our gradient, adjusting for layout direction.
    var startPoint: UnitPoint {
        switch direction {
        case .rightToLeft:
            return isInitialState ? UnitPoint(x: 1, y: 0) : UnitPoint(x: -bandSize, y: 0)
        case .leftToRight:
            return isInitialState ? UnitPoint(x: -bandSize, y: 0) : UnitPoint(x: 1, y: 0)
        case .topToBottom:
            return isInitialState ? UnitPoint(x: 0, y: -bandSize) : UnitPoint(x: 0, y: 1)
        case .bottomToTop:
            return isInitialState ? UnitPoint(x: 0, y: 1) : UnitPoint(x: 0, y: -bandSize)
        case .topLeftToBottomRight:
            return isInitialState ? UnitPoint(x: -bandSize, y: -bandSize) : UnitPoint(x: 1, y: 1)
        case .topRightToBottomLeft:
            return isInitialState ? UnitPoint(x: 1, y: 0) : UnitPoint(x: -bandSize, y: 1 + bandSize)
        case .bottomLeftToTopRight:
            return isInitialState ? UnitPoint(x: 0, y: 1) : UnitPoint(x: 1 + bandSize, y: -bandSize)
        case .bottomRightToTopLeft:
            return isInitialState ? UnitPoint(x: 1, y: 1) : UnitPoint(x: -bandSize, y: -bandSize)
        }
    }

    /// The end unit point of our gradient, adjusting for layout direction.
    var endPoint: UnitPoint {
        switch direction {
        case .rightToLeft:
            return isInitialState ? UnitPoint(x: 1 + bandSize, y: 0) : UnitPoint(x: 0, y: 0)
        case .leftToRight:
            return isInitialState ? UnitPoint(x: 0, y: 0) : UnitPoint(x: 1 + bandSize, y: 0)
        case .topToBottom:
            return isInitialState ? UnitPoint(x: 0, y: 0) : UnitPoint(x: 0, y: 1 + bandSize)
        case .bottomToTop:
            return isInitialState ? UnitPoint(x: 0, y: 1 + bandSize) : UnitPoint(x: 0, y: 0)
        case .topLeftToBottomRight:
            return isInitialState ? UnitPoint(x: 0, y: 0) : UnitPoint(x: 1 + bandSize, y: 1 + bandSize)
        case .topRightToBottomLeft:
            return isInitialState ? UnitPoint(x: 1 + bandSize, y: -bandSize) : UnitPoint(x: 0, y: 1)
        case .bottomLeftToTopRight:
            return isInitialState ? UnitPoint(x: -bandSize, y: 1 + bandSize) : UnitPoint(x: 1, y: 0)
        case .bottomRightToTopLeft:
            return isInitialState ? UnitPoint(x: 1 + bandSize, y: 1 + bandSize) : UnitPoint(x: 0, y: 0)
        }
    }

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .center, content: {
                LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
                    .mask(content)
                    .animation(animation, value: isInitialState)
            })
            .onAppear {
                isInitialState = false
            }
    }
}
