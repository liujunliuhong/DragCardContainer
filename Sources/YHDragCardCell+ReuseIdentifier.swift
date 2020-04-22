//
//  YHDragCardCell+ReuseIdentifier.swift
//  Pods-YHDragContainer
//
//  Created by apple on 2020/4/21.
//

import Foundation

internal extension YHDragCardCell {
    struct AssociatedKeys {
        static var reuseKey = "com.yinhe.yhdragcard.reuse"
        static var internalReuseKey = "com.yinhe.yhdragcard.internalReuseKey"
        static var isReuseKey = "com.yinhe.yhdragcard.isReuse"
    }
    
    var yh_reuseIdentifier: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.reuseKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.reuseKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    var yh_internalIdentifier: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.internalReuseKey) as? String
        }
        set {
            if let i = self.yh_reuseIdentifier, let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.internalReuseKey, "\(i)_\(newValue)", .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    
    var yh_is_reuse: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.isReuseKey) as? Bool) ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isReuseKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
