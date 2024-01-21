//
//  UIViewController+Extension.swift
//  NavigationBar
//
//  Created by 黄中山 on 2020/4/1.
//  Copyright © 2020 potato. All rights reserved.
//

import UIKit

// MARK: - UIViewController + Extension
extension UIViewController {
    
    private struct AssociatedObjectKeys {
        static var navigationBarConfigureKey: UInt8 = 0
    }
    
    // 用来存储属性的model
    private var _poNavigationBarConfigure: PoNavigationBarConfigure? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectKeys.navigationBarConfigureKey) as? PoNavigationBarConfigure
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectKeys.navigationBarConfigureKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// lazy navigationBarConfigure
    public var poNavigationBarConfigure: PoNavigationBarConfigure {
        get {
            if let configure = _poNavigationBarConfigure { return configure }
            let configure = PoNavigationBarConfigure()
            _poNavigationBarConfigure = configure
            return configure
        }
        set {
            _poNavigationBarConfigure = newValue
        }
    }
    
    /// copy default standard appearance
    @available(iOS 13.0, *)
    public var poCopyNavigationBarStandardAppearance: UINavigationBarAppearance? {
        if let appearance = (navigationController as? PoNavigationController)?.defaultNavigationBarConfigure.standardAppearance {
            return UINavigationBarAppearance(barAppearance: appearance)
        }
        return nil
    }
    
    /// 将navigationBarConfigure设置到navigationBar
    /// 除非在viewWillAppear之后设置了navigationBarConfigure，否则不需要手动调用
    public func flushBarConfigure(_ animated: Bool = false) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        poNavigationBarConfigure.apply(to: navigationBar)
        navigationController?.setNavigationBarHidden(poNavigationBarConfigure.isHidden ?? false, animated: animated)
    }
    
    internal var originNavigationBarFrame: CGRect? {
        guard let bar = navigationController?.navigationBar else { return nil }
        guard let background = bar.value(forKey: "_backgroundView") as? UIView else { return nil }
        var frame = background.frame
        frame.origin = .zero
        return frame
    }
}
