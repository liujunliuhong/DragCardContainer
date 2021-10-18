//
//  DragCardContainer+PanGesture.swift
//  YHDragContainer
//
//  Created by jun on 2021/10/18.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

extension DragCardContainer {
    @objc internal func panGestureRecognizer(panGesture: UIPanGestureRecognizer) {
        guard let cell = panGesture.view as? DragCardContainer else { return }
        let movePoint = panGesture.translation(in: self)
        let velocity = panGesture.velocity(in: self)
        switch panGesture.state {
            case .began:
                panGestureBegan()
            case .changed:
                panGestureChanged(cell: cell, movePoint: movePoint, panGesture: panGesture)
            default:
                break
        }
    }
}

extension DragCardContainer {
    private func panGestureBegan() {
        installNextCard()
    }
}

extension DragCardContainer {
    private func panGestureChanged(cell: DragCardContainer, movePoint: CGPoint, panGesture: UIPanGestureRecognizer) {
        let currentPoint = CGPoint(x: cell.center.x + movePoint.x, y: cell.center.y + movePoint.y)
        // 设置手指拖住的那张卡牌的位置
        cell.center = currentPoint
        // 垂直方向上的滑动比例
        let verticalMoveDistance: CGFloat = cell.center.y - initialFirstCellCenter.y
        var verticalRatio = verticalMoveDistance / fixVerticalRemoveMinimumDistance()
        if verticalRatio < -1.0 {
            verticalRatio = -1.0
        } else if verticalRatio > 1.0 {
            verticalRatio = 1.0
        }
        // 水平方向上的滑动比例
        let horizontalMoveDistance: CGFloat = cell.center.x - initialFirstCellCenter.x
        var horizontalRatio = horizontalMoveDistance / fixHorizontalRemoveMinimumDistance()
        if horizontalRatio < -1.0 {
            horizontalRatio = -1.0
        } else if horizontalRatio > 1.0 {
            horizontalRatio = 1.0
        }
        // 设置手指拖住的那张卡牌的旋转角度
        let rotationAngle = horizontalRatio * fixRemoveMaximumAngleAndToRadius()
        cell.transform = CGAffineTransform(rotationAngle: rotationAngle)
        // 复位
        panGesture.setTranslation(.zero, in: self)
        
        
    }
}

extension DragCardContainer {
    
}

extension DragCardContainer {
    
}
