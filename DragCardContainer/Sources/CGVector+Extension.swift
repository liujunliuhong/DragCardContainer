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
}

extension CGVector {
    static func * (lhs: CGVector, rhs: CGVector) -> CGFloat {
        return lhs.dx * rhs.dx + lhs.dy * rhs.dy
    }
}
