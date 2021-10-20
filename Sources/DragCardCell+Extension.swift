//
//  DragCardCell+Extension.swift
//  YHDragContainer
//
//  Created by jun on 2021/10/19.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

extension DragCardCell {
    private struct AssociatedKeys {
        static var identifierKey = "com.galaxy.gragCardCell.identifierKey"
        static var isReuseKey = "com.galaxy.gragCardCell.isReuseKey"
    }
}

extension DragCardCell {
    /// 唯一标识符
    internal var identifier: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.identifierKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.identifierKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 是否被重用
    internal var isReuse: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.isReuseKey) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isReuseKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
