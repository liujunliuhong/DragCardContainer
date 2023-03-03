//
//  BasicInfo.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/3/1.
//
//
//
//                              ┌───────────────────────────────────────────┐
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              │*******************************************│
//                              └┬─────────────────────────────────────────┬┘
//                               └┬───────────────────────────────────────┬┘
//                                └───────────────────────────────────────┘



import Foundation
import QuartzCore

public struct BasicInfo {
    public let transform3D: CATransform3D
    public let frame: CGRect
    public let anchorPoint: CGPoint
    
    public let alpha: CGFloat
    
    public init(transform3D: CATransform3D, frame: CGRect, anchorPoint: CGPoint, alpha: CGFloat = 1.0) {
        self.transform3D = transform3D
        self.frame = frame
        self.anchorPoint = anchorPoint
        self.alpha = alpha
    }
    
    public static let `default` = BasicInfo(transform3D: CATransform3DIdentity, frame: .zero, anchorPoint: .zero)
}
