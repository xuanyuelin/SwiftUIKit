//
//  Modifier.swift
//  Dazi
//
//  Created by gao lun on 2024/2/19.
//

import Foundation
import SwiftUI

struct HSpace: ViewModifier {
    
    let space: CGFloat
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            Spacer().frame(width: space)
        }
    }
}

struct VSpace: ViewModifier {
    
    let space: CGFloat
    
    func body(content: Content) -> some View {
        VStack {
            content
            
            Spacer().frame(height: space)
        }
    }
}

extension View {
    func hspace(_ space: CGFloat) -> some View {
        modifier(HSpace(space: space))
    }
    
    func vspace(_ space: CGFloat) -> some View {
        modifier(VSpace(space: space))
    }
}
