//
//  DragCardDelegate.swift
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
import UIKit

public protocol DragCardDelegate: NSObjectProtocol {
//    /// 显示顶层卡片的回调
    func dragCard(_ dragCard: DragCardContainer, displayTopCardAt index: Int, with card: UIView)
//    
//    /// 当前卡片的滑动位置信息的回调(已经自带动画)
//    /// 该代理可以用来干什么:
//    /// 实现在滑动过程中，控制某个控件的形变、颜色、透明度等等(比如：右滑，like按钮逐渐显示；左滑，unlike按钮逐渐显示)
    func dragCard(_ dragCard: DragCardContainer, movementCardAt index: Int, translation: CGPoint, with card: UIView)

//    /// 顶层卡片滑出去的回调
//    /// 当最后一个卡片滑出去时，会和`didFinishRemoveLastCell`代理同时回调
    func dragCard(_ dragCard: DragCardContainer, didRemoveTopCardAt index: Int, direction: Direction, with card: UIView)
//    
//    /// 最后一个卡片滑完的回调
//    /// 当`infiniteLoop`设置为`true`,不会走该回调
    func dragCard(_ dragCard: DragCardContainer, didFinishRemoveLast card: UIView)
//    
//    /// 点击顶层卡片的回调
    func dragCard(_ dragCard: DragCardContainer, didSelectTopCardAt index: Int, with card: UIView)
}
//
extension DragCardDelegate {
//    public func dragCard(_ dragCard: DragCardContainer, didDisplayTopCell cell: DragCardCell, withIndexAt index: Int) { }
//    public func dragCard(_ dragCard: DragCardContainer, currentCell cell: DragCardCell, withIndex index: Int, currentCardDirection direction: DragCardDirection, canRemove: Bool) { }
//    public func dragCard(_ dragCard: DragCardContainer, didRemoveTopCell cell: DragCardCell, withIndex index: Int, movementDirection: DragCardContainer.MovementDirection) { }
//    public func dragCard(_ dragCard: DragCardContainer, didFinishRemoveLastCell cell: DragCardCell) { }

//    public func dragCard(_ dragCard: DragCardContainer, didRemoveTopCard index: Int, direction: Direction, with card: UIView) { }
//    public func dragCard(_ dragCard: DragCardContainer, didFinishRemoveLast card: UIView) { }
//    public func dragCard(_ dragCard: DragCardContainer, displayTopCard index: Int, with card: UIView) { }
//    public func dragCard(_ dragCard: DragCardContainer, didSelectTopCard index: Int, with card: UIView) { }
    
}
