//
//  YHDragCardDelegate.swift
//  Pods
//
//  Created by apple on 2020/4/21.
//

import Foundation

// MARK: - 代理
@objc public protocol YHDragCardDelegate: NSObjectProtocol {
    
    /// 显示顶层卡片的回调
    /// - Parameters:
    ///   - dragCard: 容器
    ///   - cell: 卡片
    ///   - index: 索引
    @objc optional func dragCard(_ dragCard: YHDragCard, didDisplayCell cell: YHDragCardCell, withIndexAt index: Int)
    
    /// 点击顶层卡片的回调
    /// - Parameters:
    ///   - dragCard: 容器
    ///   - index: 点击的顶层卡片的索引
    ///   - cell: 点击的顶层卡片
    @objc optional func dragCard(_ dragCard: YHDragCard, didSelectIndexAt index: Int, with cell: YHDragCardCell)
    
    /// 最后一个卡片滑完的回调(当`infiniteLoop`设置为`true`,也会走该回调)
    /// - Parameters:
    ///   - dragCard: 容器
    ///   - cell: 最后一张卡片
    @objc optional func dragCard(_ dragCard: YHDragCard, didFinishRemoveLastCell cell: YHDragCardCell)
    
    /// 顶层卡片滑出去的回调。当最后一个卡片滑出去时，会和`didFinishRemoveLastCard`代理同时回调
    /// - Parameters:
    ///   - dragCard: 容器
    ///   - cell: 滑出去的卡片
    ///   - index: 滑出去的卡片的索引
    ///   - removeDirection: 卡片移除方向
    @objc optional func dragCard(_ dragCard: YHDragCard, didRemoveCell cell: YHDragCardCell, withIndex index: Int, removeDirection: YHDragCardMoveDirection)
    
    /// 当前卡片的滑动位置信息的回调(已经自带动画)
    /// - Parameters:
    ///   - dragCard: 容器
    ///   - cell: 顶层正在滑动的卡片
    ///   - index: 卡片索引
    ///   - direction: 卡片方向信息
    ///   - canRemove: 卡片所处的位置是否可以移除
    /// 该代理可以用来干什么:
    /// 1.实现在滑动过程中，控制容器外部某个控件的形变、颜色、透明度等等
    /// 2、实现在滑动过程中，控制卡片内部某个按钮的形变、颜色、透明度等等(比如：右滑，like按钮逐渐显示；左滑，unlike按钮逐渐显示)
    @objc optional func dragCard(_ dragCard: YHDragCard, currentCell cell: YHDragCardCell, withIndex index: Int, currentCardDirection direction: YHDragCardDirection, canRemove: Bool)
}
