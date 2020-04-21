//
//  YHDragCardDataSource.swift
//  Pods
//
//  Created by apple on 2020/4/21.
//

import Foundation

// MARK: - 数据源
@objc public protocol YHDragCardDataSource: NSObjectProtocol {
    
    /// 卡片总数
    /// - Parameter dragCard: 容器
    @objc func numberOfCount(_ dragCard: YHDragCard) -> Int
    
    /// 每个索引对应的卡片
    /// - Parameters:
    ///   - dragCard: 容器
    ///   - index: 索引
    @objc func dragCard(_ dragCard: YHDragCard, indexOfCell index: Int) -> YHDragCardCell
}
