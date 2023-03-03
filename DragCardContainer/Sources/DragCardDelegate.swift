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
    func dragCard(_ dragCard: DragCardContainer,
                  displayTopCardAt index: Int,
                  with cardView: DragCardView)
    
    /// This method is called when the top card is removed.
    func dragCard(_ dragCard: DragCardContainer,
                  didRemovedTopCardAt index: Int,
                  direction: Direction,
                  with cardView: DragCardView)
    
    /// This method is called when the card position is changing.
    func dragCard(_ dragCard: DragCardContainer,
                  movementCardAt index: Int,
                  translation: CGPoint,
                  with cardView: DragCardView)
    
    /// This method is called when the last card is removed.
    /// **If `infiniteLoop` is true, this method not called**
    func dragCard(_ dragCard: DragCardContainer,
                  didRemovedLast cardView: DragCardView)
    
    /// This method is called when the top card being tapped.
    func dragCard(_ dragCard: DragCardContainer,
                  didSelectTopCardAt index: Int,
                  with cardView: DragCardView)
}
//
extension DragCardDelegate {
    public func dragCard(_ dragCard: DragCardContainer, displayTopCardAt index: Int, with cardView: DragCardView) { }
    public func dragCard(_ dragCard: DragCardContainer, didRemovedTopCardAt index: Int, direction: Direction, with cardView: DragCardView) { }
    public func dragCard(_ dragCard: DragCardContainer, movementCardAt index: Int, translation: CGPoint, with cardView: DragCardView) { }
    public func dragCard(_ dragCard: DragCardContainer, didRemovedLast cardView: DragCardView) { }
    public func dragCard(_ dragCard: DragCardContainer, didSelectTopCardAt index: Int, with cardView: DragCardView) { }
}
