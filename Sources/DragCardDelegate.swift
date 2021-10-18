//
//  DragCardDelegate.swift
//  YHDragContainer
//
//  Created by jun on 2021/10/18.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation


public protocol DragCardDelegate: NSObjectProtocol {
    /// 显示顶层卡片的回调
    func dragCard(_ dragCard: DragCardContainer, didDisplayCell cell: DragCardCell, withIndexAt index: Int)
}

extension DragCardDelegate {
    func dragCard(_ dragCard: DragCardContainer, didDisplayCell cell: DragCardCell, withIndexAt index: Int) { }
}
