//
//  DragCardProperty.swift
//  YHDragContainer
//
//  Created by jun on 2021/10/18.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import CoreGraphics

internal class DragCardProperty {
    var transform: CGAffineTransform = .identity
    var frame: CGRect = .zero
    
    let cell: DragCardCell
    
    init(cell: DragCardCell) {
        self.cell = cell
    }
}
