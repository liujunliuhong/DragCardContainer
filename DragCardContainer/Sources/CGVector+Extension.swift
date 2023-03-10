//
//  CGVector+Extension.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/3/9.
//

import Foundation


extension CGVector {
    internal init(from origin: CGPoint = .zero, to target: CGPoint) {
        self = CGVector(dx: target.x - origin.x,
                        dy: target.y - origin.y)
    }
    
    internal init(_ size: CGSize) {
        self = CGVector(dx: size.width, dy: size.height)
    }
}

extension CGVector {
    internal static func * (lhs: CGVector, rhs: CGVector) -> CGFloat {
        return lhs.dx * rhs.dx + lhs.dy * rhs.dy
    }
    
    internal static func / (vector: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
    }
    
    internal var length: CGFloat {
        return hypot(dx, dy)
    }
    
    internal var normalized: CGVector {
        return self / length
    }
}
