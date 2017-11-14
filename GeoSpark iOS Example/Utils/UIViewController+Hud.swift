//
//  UIViewController+Hud.swift
//  CareUI
//
//  Created by Pavel Zhuravlev on 3/1/17.
//  Copyright © 2017 Care.com. All rights reserved.
//

import UIKit

private var hudViewAssociatedKey: UInt8 = 0

public extension UIViewController {
    
    public var hudView: HudView? {
        get {
            return objc_getAssociatedObject(self, &hudViewAssociatedKey) as? HudView
        }
        set {
            objc_setAssociatedObject(self, &hudViewAssociatedKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    
    public func showHud() {
        showHud(withBackground: .white)
    }
    
    public func showHud(withBackground backgroundColor: UIColor? = .white) {
        
        removeHudIfPresent()
        
        hudView = HudView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        hudView?.backgroundColor = backgroundColor
        hudView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hudView!)
        hudView!.cr_fillContainerWithInsets(.zero)
        hudView!.startProgress()
    }
    
    public func dismissHud(withCompletion completionBlock: ((Void) -> Void)? = nil) {
        
        if let hudView = hudView {
            UIView.animate(withDuration: 0.25,
                           animations: { hudView.alpha = 0 },
                           completion: { _ in self.removeHudIfPresent()
                                completionBlock?()
            })
        }
        
    }
    
    private func removeHudIfPresent() {
        if let hudView = hudView {
            hudView.removeFromSuperview()
            self.hudView = nil
        }
    }
    
}