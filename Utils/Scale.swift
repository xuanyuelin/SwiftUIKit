//
//  Scale.swift
//  Enabot
//
//  Created by Terry on 2020/1/8.
//  Copyright © 2020 sks. All rights reserved.
//

import UIKit

private var originScreenSize: CGSize {
    if #available(iOS 16.0, *) { // fix wrong interface orientation returned by windownScene.orientation on iOS16
        let screenSize = UIScreen.main.bounds.size
        let isPortrait = screenSize.width < screenSize.height
        return isPortrait ? CGSize(width: 375, height: 812) : CGSize(width: 812, height: 375)
    } else {
        switch kInterfaceOrientation {
        case .portrait, .portraitUpsideDown:
            return CGSize(width: 375, height: 812)
        default:
            return CGSize(width: 812, height: 375)
        }
    }
}

public extension BinaryInteger {
    var float: CGFloat {
        return CGFloat(self)
    }
    
    var scaleX: CGFloat {
        let radio = UIScreen.main.bounds.width / originScreenSize.width
        let scale = UIScreen.main.scale
        let tmp = CGFloat(self) * radio * scale / scale
        return ceil(tmp)
    }
    
    var scaleWidth: CGFloat {
        return self.scaleX
    }
    
    var scaleY: CGFloat {
        let radio = UIScreen.main.bounds.height / originScreenSize.height
        let scale = UIScreen.main.scale
        let tmp = CGFloat(self) * radio * scale / scale
        return ceil(tmp)
    }
    
    var scaleHeight: CGFloat {
        return self.scaleY
    }
}

public extension CGPoint {
    var scale: CGPoint {
        return CGPoint(x: x.scaleX, y: y.scaleY)
    }
}

public extension CGSize {
    var scale: CGSize {
        return CGSize(width: width.scaleX, height: height.scaleY)
    }
}

public extension CGRect {
    var scale: CGRect {
        return CGRect(origin: origin.scale, size: size.scale)
    }
}

public extension UIEdgeInsets {
    var scale: Self {
        UIEdgeInsets(top: top.scaleY, left: left.scaleX, bottom: bottom.scaleY, right: right.scaleX)
    }
}

public extension BinaryFloatingPoint {
    var scaleX: CGFloat {
        let radio = UIScreen.main.bounds.width / originScreenSize.width
        let scale = UIScreen.main.scale
        let tmp = CGFloat(self) * radio * scale / scale
        return ceil(tmp)
    }
    
    var scaleWidth: CGFloat {
        return self.scaleX
    }
    
    var scaleY: CGFloat {
        let radio = UIScreen.main.bounds.height / originScreenSize.height
        let scale = UIScreen.main.scale
        let tmp = CGFloat(self) * radio * scale / scale
        return ceil(tmp)
    }
    
    var scaleHeight: CGFloat {
        return self.scaleY
    }
}

// MARK: - SwiftUI
import SwiftUI

extension EdgeInsets {
    var scale: EdgeInsets {
        EdgeInsets(top: top.scaleY, leading: leading.scaleX, bottom: bottom.scaleY, trailing: trailing.scaleX)
    }
}
