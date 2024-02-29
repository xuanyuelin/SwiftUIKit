//
//  Poper.swift
//  Dazi
//
//  Created by gao lun on 2024/2/22.
//

import Foundation
import SwiftUI

struct Poper<Card: View>: ViewModifier {
    @Binding var show: Bool
    let card: () -> Card
    let tapBackToDismiss: Bool
    @State private var cardSize: CGSize = .zero
    @State private var offy: CGFloat = -1
    private var related: Bool { offy == 0 }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack(alignment: .bottom) {
                    Color(hex: 0x000000, alpha: 0.15)
                        .onTapGesture {
                            if tapBackToDismiss {
                                show = false
                            }
                        }
                    
                    card()
                        .frame(width: kScreenWidth)
                        .background(
                            GeometryReader { reader in
                                TopRoundedCorner(radius: 20)
                                    .fill(.white)
                                    .onAppear {
                                        // passby the contentsize outside
                                        cardSize = reader.size
                                    }
                            }
                        )
                        .offset(y: offy)
                        .onChange(of: show) { s in
                            withAnimation(.easeInOut(duration: s ? 0.45 : 0.25)) {
                                offy = s ? 0 : cardSize.height
                            }
                        }
                }
                .ignoresSafeArea()
                .opacity(related ? 1 : 0)
            }
    }
}

extension View {
    func withPoper<Content: View>(show: Binding<Bool>, tapBackToDismiss: Bool = false, content: @escaping () -> Content) -> some View {
        modifier(Poper(show: show, card: content, tapBackToDismiss: tapBackToDismiss))
    }
}
