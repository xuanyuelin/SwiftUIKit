//
//  Alerter.swift
//  Dazi
//
//  Created by gao lun on 2024/2/22.
//

import Foundation
import SwiftUI

struct AdColor: Equatable {
    let value: UInt
    var alpha: CGFloat = 1
    
    var color: Color {
        Color(hex: value, alpha: alpha)
    }
}

struct AdTextConfig: Equatable {
    let text: String
    let font: Font
    let adc: AdColor
    
    var color: Color { adc.color }
}

struct AdButtonConfig: Equatable {
    let textConfig: AdTextConfig
    let action: () -> Void
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.textConfig == rhs.textConfig
    }
}

enum AdSubject {
    case image(String)
    case title(AdTextConfig)
    case message(AdTextConfig)
}

enum AdButton: Hashable {
    case cancel(AdButtonConfig)
    case finish(AdButtonConfig)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .cancel(config): hasher.combine("0:\(config.textConfig)")
        case let .finish(config): hasher.combine("1:\(config.textConfig)")
        }
    }
    
    var button: some View {
        switch self {
        case let .cancel(config):
            return Button(action: {
                config.action()
            }, label: {
                ZStack {
                    Color(hex: 0x000000, alpha: 0.15)
                    Text(config.textConfig.text)
                        .font(config.textConfig.font)
                        .foregroundColor(config.textConfig.color)
                }
            })
            .frame(maxWidth: 100.scaleX)
            .frame(height: 44.scaleY)
            .cornerRadius(16)
        case let .finish(config):
            return Button(action: {
                config.action()
            }, label: {
                ZStack {
                    Color(hex: 0x000000)
                    Text(config.textConfig.text)
                        .font(config.textConfig.font)
                        .foregroundColor(config.textConfig.color)
                }
            })
            .frame(maxWidth: 100.scaleX)
            .frame(height: 44.scaleY)
            .cornerRadius(16)
        }
    }
}

struct AdConfig {
    let subjects: [AdSubject]
    let buttons: [AdButton]
    var tapBackToDissmiss: Bool = false
    
    var image: Image? {
        if case let .image(name) = subjects.first(where: { if case .image = $0 { return true } else { return false }}) {
            return Image(name)
        }
        return nil
    }
    
    var title: Text? {
        if case let .title(config) = subjects.first(where: { if case .title = $0 { return true } else { return false }}) {
            return Text(config.text)
                .font(config.font)
                .foregroundColor(config.color)
        }
        return nil
    }
    
    var message: Text? {
        if case let .message(config) = subjects.first(where: { if case .message = $0 { return true } else { return false }}) {
            return Text(config.text)
                .font(config.font)
                .foregroundColor(config.color)
        }
        return nil
    }
}

struct AlertModifier: ViewModifier {
    @Binding var show: Bool
    var preferredSize: CGSize? = nil
    let config: AdConfig
    @State private var scale: CGFloat = 0.2
    private var related: Bool { scale == 1 }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack(alignment: .center) {
                    Color(hex: 0x000000, alpha: 0.15)
                        .onTapGesture {
                            if config.tapBackToDissmiss {
                                show = false
                            }
                        }
                    
                    AdCard(config: config)
                        .frame(width: kScreenWidth - 16.scaleX * 2)
                        .background(
                            Color.white
                                .cornerRadius(20)
                        )
                        .scaleEffect(scale)
                        .onChange(of: show) { s in
                            if s {
                                withAnimation(.interpolatingSpring(duration: 0.45, bounce: 0.2, initialVelocity: 5)) {
                                    scale = 1
                                }
                            } else {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    scale = 0.2
                                }
                            }
                        }
                }
                .ignoresSafeArea()
                .opacity(related ? 1 : 0)
            }
    }
}

extension View {
    func withAlert(show: Binding<Bool>, config: AdConfig) -> some View {
        modifier(AlertModifier(show: show, config: config))
    }
}

struct AdCard: View {
    let config: AdConfig
    private let edges = EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30).scale
    
    var body: some View {
        VStack {
            if let image = config.image {
                image
                    .vspace(20.scaleY)
            }
            if let title = config.title {
                title
                    .vspace(10.scaleY)
            }
            if let message = config.message {
                message
                    .vspace(30.scaleY)
            } else {
                Spacer().frame(height: 20.scaleY)
            }
            
            HStack(spacing: 10.scaleX) {
                ForEach(config.buttons, id: \.self) { buttonConfig in
                    buttonConfig.button
                }
            }
        }
        .padding(edges)
        .multilineTextAlignment(.center)
        .lineSpacing(8.scaleY)
    }
}
