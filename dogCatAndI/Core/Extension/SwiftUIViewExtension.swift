//
//  SwiftUIViewExtension.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 7/2/2569 BE.
//

import SwiftUI

extension View {
    // MARK: - Life Cycle
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
    }

    func taskOnViewDidLoad(perform action: (@Sendable () async -> Void)? = nil) -> some View {
        self.modifier(TaskOnViewDidLoadModifier(action: action))
    }

    // MARK: - Layout
    func frame(_ size: CGFloat, alignment: Alignment = .center) -> some View {
        frame(width: size, height: size, alignment: alignment)
    }

    @ViewBuilder
    func frameHorizontalExpand(alignment: HorizontalAlignment? = .center) -> some View {
        frame(
            maxWidth: .infinity,
            alignment: Alignment(horizontal: alignment ?? .center, vertical: .center)
        )
    }

    func frameVerticalExpand(alignment: VerticalAlignment? = .center) -> some View {
        frame(
            maxHeight: .infinity,
            alignment: Alignment(horizontal: .center, vertical: alignment ?? .center)
        )
    }

    func frameExpand(alignment: Alignment? = .center) -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment ?? .center)
    }

    func aspectClipped(_ ratio: CGFloat? = nil, contentMode: ContentMode) -> some View {
        Color.clear
            .aspectRatio(ratio, contentMode: .fit)
            .overlay(alignment: .center) {
                self.aspectRatio(contentMode: contentMode)
            }
            .clipped()
    }

    // MARK: - Corner Border
    func corner(radius: CGFloat) -> some View {
        clipShape(RoundedRectangle(cornerRadius: radius))
    }

    func cornerRadiusWithBorder<S: ShapeStyle>(
        _ content: S,
        radius: CGFloat,
        width: CGFloat,
        corners: UIRectCorner,
        inset: UIEdgeInsets = .zero
    ) -> some View { self
        .clipShape(RoundedCorner(radius: radius, corners: corners))
        .overlay(RoundedCorner(radius: radius, corners: corners, inset: inset).stroke(content, lineWidth: width))
    }

    // MARK: - Utils
    func asButton(action: @escaping () -> Void) -> some View {
        Button(action: action) { self }
    }

    func asScrollView(_ axes: Axis.Set, showIndicators: Bool) -> some View {
        ScrollView(axes, showsIndicators: showIndicators) { self }
    }

    func expandInScrollView(
        _ axes: Axis.Set = .vertical,
        showIndicators: Bool = false
    ) -> some View {
        GeometryReader { proxy in
            ScrollView(axes, showsIndicators: showIndicators) {
                self
                    .frame(minHeight: proxy.size.height, alignment: .center)
                    .frameHorizontalExpand(alignment: .center)
            }
        }
    }

    func refreshableWithDelay(
        sec: Double = 0.8,
        action: @Sendable @escaping () async -> Void
    ) -> some View {
        self.refreshable {
            await Task {
                async let refresh: Void = action()
                async let delay: Void = Task.sleep(nanoseconds: UInt64(sec * 1_000_000_000))
                _ = try? await (refresh, delay)
            }.value
        }
    }

    /// Adds an animated shimmering effect to any view, typically to show that an operation is in progress.
    /// - Parameters:
    ///   - active: Convenience parameter to conditionally enable the effect. Defaults to `true`.
    ///   - animation: A custom animation. Defaults to ``Shimmer/defaultAnimation``.
    ///   - gradient: A custom gradient. Defaults to ``Shimmer/defaultGradient``.
    ///   - bandSize: The size of the animated mask's "band". Defaults to 0.3 unit points, which corresponds to 20% of the extent of the gradient.
    ///   - direction: The direction that the animated mask's "band" will move. Defaults to ``leftToRight``
    @ViewBuilder func shimmering(
        active: Bool = true,
        animation: Animation = Shimmer.defaultAnimation(),
        gradient: Gradient = Shimmer.defaultGradient(),
        bandSize: CGFloat = 0.4,
        direction: Shimmer.ShimmerDirection = .leftToRight
    ) -> some View {
        if active {
            modifier(Shimmer(
                animation: animation,
                gradient: gradient,
                bandSize: bandSize,
                direction: direction
            ))
        } else {
            self
        }
    }
}

// MARK: - Helper
private struct ViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad = false
    let action: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .onAppear {
                guard viewDidLoad == false else { return }
                viewDidLoad = true
                action?()
            }
    }
}

private struct TaskOnViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad = false
    let action: (@Sendable () async -> Void)?

    func body(content: Content) -> some View {
        content
            .task {
                guard viewDidLoad == false else { return }
                viewDidLoad = true
                await action?()
            }
    }
}

/// Round specific corner link
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    var inset: UIEdgeInsets = .zero

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect.inset(by: inset), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
