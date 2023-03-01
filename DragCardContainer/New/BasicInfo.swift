//
//  BasicInfo.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/3/1.
//

import Foundation


internal struct BasicInfo {
    internal let transform: CGAffineTransform
    internal let frame: CGRect
    internal let anchorPoint: CGPoint
    
    internal init(transform: CGAffineTransform, frame: CGRect, anchorPoint: CGPoint) {
        self.transform = transform
        self.frame = frame
        self.anchorPoint = anchorPoint
    }
    
    internal static let `default` = BasicInfo(transform: .identity, frame: .zero, anchorPoint: .zero)
}
