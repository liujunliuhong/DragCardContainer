//
//  RandomMode.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/3/3.
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

public final class RandomMode {
    
    /// Maximum angle.
    public var maximumAngle: CGFloat = 3.0
    
    public static let `default` = RandomMode()
    
    public init() {}
}

extension RandomMode: Mode {
    public func basicInfos(visibleCount: Int, containerSize: CGSize) -> [BasicInfo] {
        var basicInfos: [BasicInfo] = []
        
        let anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        for _ in 0..<visibleCount {
            let radius = CGFloat(CGFloat.random(in: Range(uncheckedBounds: (-maximumAngle, maximumAngle)))).radius
            let transform = CATransform3DRotate(CATransform3DIdentity, radius, 0, 0, 1)
            
            let basicInfo = BasicInfo(transform3D: transform,
                                      frame: CGRect(x: .zero,
                                                    y: .zero,
                                                    width: containerSize.width,
                                                    height: containerSize.height),
                                      anchorPoint: anchorPoint)
            basicInfos.append(basicInfo)
        }
        return basicInfos
    }
}