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
    /// This method is called when the top card is displayed.
    func dragCard(_ dragCard: DragCardContainer, displayTopCardAt index: Int, with card: UIView)
    
    /// This method is called when the top card is removed.
    func dragCard(_ dragCard: DragCardContainer, didRemovedTopCardAt index: Int, direction: Direction, with card: UIView)
    
    /// This method is called when the card position is changing.
    func dragCard(_ dragCard: DragCardContainer, movementCardAt index: Int, translation: CGPoint, with card: UIView)
    
    /// This method is called when the last card is removed.
    /// **If `infiniteLoop` is true, this method not called**
    func dragCard(_ dragCard: DragCardContainer, didRemovedLast card: UIView)
    
    /// This method is called when the top card being tapped.
    func dragCard(_ dragCard: DragCardContainer, didSelectTopCardAt index: Int, with card: UIView)
}
//
extension DragCardDelegate {
    public func dragCard(_ dragCard: DragCardContainer, displayTopCardAt index: Int, with card: UIView) { }
    public func dragCard(_ dragCard: DragCardContainer, didRemovedTopCardAt index: Int, direction: Direction, with card: UIView) { }
    public func dragCard(_ dragCard: DragCardContainer, movementCardAt index: Int, translation: CGPoint, with card: UIView) { }
    public func dragCard(_ dragCard: DragCardContainer, didRemovedLast card: UIView) { }
    public func dragCard(_ dragCard: DragCardContainer, didSelectTopCardAt index: Int, with card: UIView) { }
}
