//
//  DragCardDataSource.swift
//  YHDragContainer
//
//  Created by jun on 2021/10/18.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

public protocol DragCardDataSource: NSObjectProtocol {
    /// 卡片总数
    func numberOfCount(_ dragCard: DragCardContainer) -> Int
    
    /// 每个索引对应的卡片
    func dragCard(_ dragCard: DragCardContainer, indexOfCell index: Int) -> DragCardCell
}
