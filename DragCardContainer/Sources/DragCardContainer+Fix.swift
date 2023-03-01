//
//  DragCardContainer+Fix.swift
//  YHDragContainer
//
//  Created by jun on 2021/10/18.
//  Copyright © 2021 yinhe. All rights reserved.
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
import CoreGraphics

//extension DragCardContainer {
//    /// 0.1 ~ 1.0
//    internal func fixMinimumScale() -> CGFloat {
//        var minimumScale = minimumScale
//        if minimumScale > 1.0 { minimumScale = 1.0 }
//        if minimumScale <= 0.1 { minimumScale = 0.1 }
//        return minimumScale
//    }
//    
//    /// 0.0 ~ bounds.size.height / 2.0
//    internal func fixCellSpacing() -> CGFloat {
//        var spacing = cellSpacing
//        if spacing.isLess(than: .zero) {
//            spacing = .zero
//        } else if spacing > bounds.size.height / 2.0 {
//            spacing = bounds.size.height / 2.0
//        }
//        return spacing
//    }
//    
//    /// 50.0 ~ +∞
//    internal func fixVerticalRemoveMinimumDistance() -> CGFloat {
//        return verticalRemoveMinimumDistance < 50.0 ? 50.0 : verticalRemoveMinimumDistance
//    }
//    
//    /// 100.0 ~ +∞
//    internal func fixVerticalRemoveMinimumVelocity() -> CGFloat {
//        return verticalRemoveMinimumVelocity < 100.0 ? 100.0 : verticalRemoveMinimumVelocity
//    }
//    
//    /// 10.0 ~ +∞
//    internal func fixHorizontalRemoveMinimumDistance() -> CGFloat {
//        return horizontalRemoveMinimumDistance < 10.0 ? 10.0 : horizontalRemoveMinimumDistance
//    }
//    
//    /// 100.0 ~ +∞
//    internal func fixHorizontalRemoveMinimumVelocity() -> CGFloat {
//        return horizontalRemoveMinimumVelocity < 100.0 ? 100.0 : horizontalRemoveMinimumVelocity
//    }
//    
//    /// 0.0 ~ 90.0，并且转换为弧度
//    internal func fixCellRotationMaximumAngleAndConvertToRadius() -> CGFloat {
//        var angle: CGFloat = cellRotationMaximumAngle
//        if angle.isLess(than: .zero) {
//            angle = .zero
//        } else if angle > 90.0 {
//            angle = 90.0
//        }
//        return angle / 180.0 * CGFloat(Double.pi)
//    }
//    
//    /// 5.0 ~ 85.0，并且转换为弧度
//    internal func fixDemarcationVerticalAngleAndConvertToRadius() -> CGFloat {
//        var angle = demarcationVerticalAngle
//        if angle < 5.0 {
//            angle = 5.0
//        } else if angle > 85.0 {
//            angle = 85.0
//        }
//        return angle / 180.0 * CGFloat(Double.pi)
//    }
//}
