//
//  Constants.swift
//  MadHearing
//
//  Created by gao lun on 2022/9/29.
//

import Foundation
import UIKit

/// animate durations
let kAnimateDurationFastly = 0.3
let kAnimateDurationSlowly = 0.7

/// device orientation
var kInterfaceOrientation: UIInterfaceOrientation {

    var result: UIInterfaceOrientation = .unknown
    if #available(iOS 13, *) {
        result = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? .unknown
    } else {
        result = UIApplication.shared.statusBarOrientation
    }
    return result
}

/// mask colors
let kMaskLightColor = UIColor(white: 0, alpha: 0.2)
let kMaskDarkColor = UIColor(white: 0, alpha: 0.5)

// MARK: - UIScreen
/// 主窗口
public var kKeyWindow: UIWindow? { UIApplication.shared.windows.filter {$0.isKeyWindow}.first }
/// 是否是iPhoneX系列(有刘海)
let kIsIPhoneXSeries: Bool = kKeyWindow!.safeAreaInsets.bottom > 0 ? true : false
/// 屏幕宽
public var kScreenWidth: CGFloat {  UIScreen.main.bounds.size.width }
/// 屏幕高
public var kScreenHeight: CGFloat { UIScreen.main.bounds.size.height }
/// 状态栏高度
public var kStatusBarHeight: CGFloat { kKeyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0 }
/// 导航栏高度
let kNavagationBarHeight: CGFloat = 44.0
/// 顶部bar高度 = 状态栏+导航栏高度
let kTopBarHeight: CGFloat = kStatusBarHeight + kNavagationBarHeight
/// 底部home bar高度
let kHomeBarHeight: CGFloat = kIsIPhoneXSeries ? 34.0 : 0
/// 返回按钮间距
let kNavagationButtonSpace: CGFloat = 8.0
/// keyWindow宽
public var kKeyWindowWidth: CGFloat { kKeyWindow?.bounds.width ?? 0 }
/// keyWindow高
public var kKeyWindowHeight: CGFloat { return kKeyWindow?.bounds.height ?? 0 }

// MARK: - Business
public let kAgreementUrl: String = "https://www.baidu.com"
public let kPrivacyUrl: String = "https://www.baidu.com"
