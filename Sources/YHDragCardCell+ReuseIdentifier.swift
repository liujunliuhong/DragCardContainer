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
    }
    
    func yh_set(reuseIdentifier: String) {
        objc_setAssociatedObject(self, &AssociatedKeys.reuseKey, reuseIdentifier, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func yh_getReuseIdentifier() -> String? {
        return objc_getAssociatedObject(self, &AssociatedKeys.reuseKey) as? String
    }
}
