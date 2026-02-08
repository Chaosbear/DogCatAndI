//
//  ErrorView.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 8/2/2569 BE.
//

import SwiftUI

enum ErrorViewStateModel: String {
    case noError
    case noInternetError
    case systemError

    var title: String? {
        switch self {
        case .noError: return nil
        case .noInternetError: return "No internet connection"
        case .systemError: return "Something went wrong"
        }
    }

    var message: String? {
        switch self {
        case .noError: return nil
        case .noInternetError: return "Please check your internet connection"
        case .systemError: return "Please try again later"
        }
    }

    var image: String? {
        switch self {
        case .noError: return nil
        case .noInternetError: return "wifi.slash"
        case .systemError: return "exclamationmark.triangle"
        }
    }
}

struct ErrorView: View {
    // MARK: - Property
    @Environment(\.isEnabled) private var isEnabled
    private var imgName: String?
    private var title: String?
    private var message: String?
    private var btnLabel: String?
    private var imageSize: CGSize
    private var retryAction: @Sendable () -> Void

    // MARK: - Text Style
    private let titleTextStyle = TextStyler(
        font: DSFont.subTitleBold.font,
        color: Color(DSColor.primaryWhite)
    )
    private let msgTextStyle = TextStyler(
        font: DSFont.body2.font,
        color: Color(DSColor.gray5)
    )
    private let btnTextStyle = TextStyler(
        font: DSFont.body2Bold.font,
        color: Color(DSColor.primaryWhite)
    )

    // MARK: - Init
    init(
        state: ErrorViewStateModel,
        btnLabel: String? = "Try again",
        imageSize: CGSize = .init(width: 160, height: 160),
        retryAction: @Sendable @escaping () -> Void
    ) {
        self.imgName = state.image
        self.title = state.title
        self.message = state.message
        self.btnLabel = btnLabel
        self.imageSize = imageSize
        self.retryAction = retryAction
    }

    // MARK: - View Body
    var body: some View {
        VStack(spacing: 0) {
            if let image = imgName {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize.width, height: imageSize.height)
                    .padding(.bottom, 24)
            }

            if title != nil || message != nil {
                VStack(spacing: 8) {
                    if let title = title {
                        Text(title)
                            .modifier(titleTextStyle)
                    }

                    if let msg = message {
                        Text(msg)
                            .modifier(msgTextStyle)
                    }
                }
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.bottom, 24)
            }

            if let btnLabel = btnLabel {
                VStack {
                    if isEnabled {
                        Text(btnLabel)
                            .modifier(btnTextStyle)
                            .padding(.horizontal, 12)
                            .minimumScaleFactor(0.8)
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 100, height: 44, alignment: .center)
                .background(isEnabled ? Color(DSColor.primaryBlue) : Color(DSColor.primaryBlueDisable))
                .corner(radius: 4)
                .asButton {
                    retryAction()
                }
            }
        }
        .frame(maxWidth: 480)
        .padding(.horizontal, 12)
        .padding(.vertical, 24)
    }
}

#Preview {
    ErrorView(state: .noInternetError, retryAction: {})
        .frameExpand()
}
