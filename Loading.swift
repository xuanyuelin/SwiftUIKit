//
//  Loading.swift
//  Dazi
//
//  Created by gao lun on 2024/2/27.
//

import Foundation
import SwiftUI

enum LoadState: Equatable {
    case loading
    case toast(String)
}

struct LoadConfig: Equatable {
    var state: LoadState
    var backClear: Bool = true
}

struct Loading: ViewModifier {
    @Binding var loader: LoadConfig?
    @State private var angle: Angle = .degrees(0)
    @State private var offy: CGFloat = -50
    @State private var scale: CGFloat = 0
    @State private var work: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack(alignment: .top) {
                    if let ld = loader {
                        if !ld.backClear {
                            Color(hex: 0x000000, alpha: 0.15)
                        }
                        
                        switch ld.state {
                        case .loading:
                            ZStack {
                                Color.black
                                    .cornerRadius(8)
                                
                                Circle()
                                    .trim(from: 0.2, to: 1)
                                    .stroke(Color.white, lineWidth: 4)
                                    .frame(width: 18.scaleX, height: 18.scaleX)
                                    .rotationEffect(angle)
                            }
                            .frame(width: 40.scaleX, height: 40.scaleX)
                            .offset(y: offy)
                            .onAppear {
                                withAnimation(.linear(duration: 0.25)) {
                                    offy = 100
                                }
                                
                                withAnimation(.linear(duration: 0.7).repeatForever(autoreverses: false)) {
                                    angle = .degrees(360)
                                }
                            }
                        case let .toast(text):
                            ZStack {
                                Text(text)
                                    .font(.system(size: 17))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            // later set maxFrame limit to make the background ajust its content's size
                            .background(
                                Color.black
                                    .cornerRadius(8)
                            )
                            .frame(maxWidth: kScreenWidth * 0.68)
                            .offset(y: 100)
                            .multilineTextAlignment(.center)
                            .lineSpacing(5.scaleY)
                            .scaleEffect(scale)
                            .onAppear {
                                withAnimation(.interpolatingSpring(duration: 0.45, bounce: 0.2, initialVelocity: 5)) {
                                    scale = 1
                                }
                                dismiss()
                            }
                        }
                    } else {
                        EmptyView()
                    }
                }
                .ignoresSafeArea()
            }
    }
    
    private func dismiss() {
        let task = DispatchWorkItem {
            dismissToast()
        }
        
        // cancel first
        work?.cancel()
        work = task
        
        // dispatch later
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: task)
    }
    
    private func dismissToast() {
        withAnimation {
            loader = nil
            angle = .degrees(0)
            offy = -50
            scale = 0
        }
        
        work?.cancel()
        work = nil
    }
}

extension View {
    func loading(with config: Binding<LoadConfig?>) -> some View {
        modifier(Loading(loader: config))
    }
}
