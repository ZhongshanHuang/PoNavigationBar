//
//  PoNavigationController.swift
//  HZSCustomTransition
//
//  Created by HzS on 16/4/6.
//  Copyright © 2016年 HzS. All rights reserved.
//

import UIKit

open class PoNavigationController: UINavigationController {
    /// 默认配置
    open lazy var defaultNavigationBarConfigure: PoNavigationBarConfigure = {
        let config = PoNavigationBarConfigure()
        config.barStyle = .default
        config.isTranslucent = true
        config.isHidden = false
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            config.standardAppearance = appearance
            config.scrollEdgeAppearance = appearance
        }
        return config
    }()
    
    /// 全屏返回
    open lazy var fullScreenPopGestureRecognizer: UIPanGestureRecognizer = {
        let target = interactivePopGestureRecognizer?.delegate
        let pan = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        pan.delegate = self
        return pan
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // 全屏侧滑返回
        view.addGestureRecognizer(fullScreenPopGestureRecognizer)
        interactivePopGestureRecognizer?.isEnabled = false
        
        // 代理
        delegate = self
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        print("push before")
        super.pushViewController(viewController, animated: animated)
        print("push after")
    }
}

// MARK: - UINavigationControllerDelegate
extension PoNavigationController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 如果有一边是隐藏了bar
        viewController.poNavigationBarConfigure.fillSelfEmptyValue(with: defaultNavigationBarConfigure)
        if (viewController.poNavigationBarConfigure.isHidden ?? false) != navigationController.navigationBar.isHidden {
            navigationController.setNavigationBarHidden(viewController.poNavigationBarConfigure.isHidden ?? false, animated: animated)
        }
        
        // 没有动画的没必要继续执行
        if !animated { return }
        
        navigationController.transitionCoordinator?.animate(alongsideTransition: { (ctx) in
            guard let toVC = ctx.viewController(forKey: .to) else { fatalError("nil") }
            toVC.poNavigationBarConfigure.apply(to: self.navigationBar)
        }, completion: { (ctx) in
            if ctx.isCancelled { // 失败后恢复原状
                guard let fromVC = ctx.viewController(forKey: .from) else { fatalError("nil") }
                fromVC.poNavigationBarConfigure.apply(to: self.navigationBar)
            }
        })
    }
    
    // 如果push或者pop成功就调用，失败是不会调用这儿的，比上面的completion先掉用
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        viewController.poNavigationBarConfigure.apply(to: navigationController.navigationBar)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension PoNavigationController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === self.fullScreenPopGestureRecognizer {
            return viewControllers.count > 1
        }
        return false
    }
}
