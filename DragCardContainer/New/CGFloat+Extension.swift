//
//  CGFloat+Extension.swift
//  DragCardContainer
//
//  Created by galaxy on 2023/3/1.
//

import Foundation


extension CGFloat {
    internal var radius: CGFloat {
        return self / 180.0 * CGFloat(Double.pi)
    }
}
