//
//  DragCardContainer+PanGesture.swift
//  YHDragContainer
//
//  Created by jun on 2021/10/18.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension DragCardContainer {
    @objc internal func panGestureRecognizer(panGesture: UIPanGestureRecognizer) {
        guard let cell = panGesture.view as? DragCardCell else { return }
        let movePoint = panGesture.translation(in: containerView)
        let velocity = panGesture.velocity(in: containerView)
        switch panGesture.state {
            case .began:
                panGestureBegan()
            case .changed:
                panGestureChanged(cell: cell, movePoint: movePoint, panGesture: panGesture)
            case .ended:
                panGestureEnd(cell: cell, velocity: velocity)
            case .cancelled, .failed:
                panGestureCancel()
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
    private func panGestureChanged(cell: DragCardCell, movePoint: CGPoint, panGesture: UIPanGestureRecognizer) {
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
        let rotationAngle = horizontalRatio * fixCellRotationMaximumAngleAndConvertToRadius()
        cell.transform = CGAffineTransform(rotationAngle: rotationAngle)
        // 复位
        panGesture.setTranslation(.zero, in: containerView)
        // 设置卡片transform
        if removeDirection == .horizontal {
            moving(ratio: abs(horizontalRatio))
        } else {
            moving(ratio: abs(verticalRatio))
        }
        // 卡片滑动过程中的方向设置
        var horizontalRemoveDirection: DragCardContainer.MovementDirection = .identity
        var verticalRemoveDirection: DragCardContainer.MovementDirection = .identity
        if horizontalRatio > 0.0 {
            horizontalRemoveDirection = .right
        } else if horizontalRatio < 0.0 {
            horizontalRemoveDirection = .left
        }
        if verticalRatio > 0.0 {
            verticalRemoveDirection = .down
        } else if verticalRatio < 0.0 {
            verticalRemoveDirection = .up
        }
        let direction = DragCardDirection(horizontalMovementDirection: horizontalRemoveDirection,
                                          horizontalMovementRatio: horizontalRatio,
                                          verticalMovementDirection: verticalRemoveDirection,
                                          verticalMovementRatio: verticalRatio)
        delegate?.dragCard(self, currentCell: cell, withIndex: _currentIndex, currentCardDirection: direction, canRemove: false)
    }
}

extension DragCardContainer {
    private func panGestureEnd(cell: DragCardCell, velocity: CGPoint) {
        let horizontalMoveDistance: CGFloat = cell.center.x - initialFirstCellCenter.x
        let verticalMoveDistance: CGFloat = cell.center.y - initialFirstCellCenter.y
        if removeDirection == .horizontal {
            if (abs(horizontalMoveDistance) > horizontalRemoveMinimumDistance || abs(velocity.x) > horizontalRemoveMinimumVelocity) &&
                abs(verticalMoveDistance) > 0.1 && // 避免分母为0
                abs(horizontalMoveDistance) / abs(verticalMoveDistance) >= tan(fixDemarcationVerticalAngleAndConvertToRadius()) {
                // 消失
                disappear(horizontalMoveDistance: horizontalMoveDistance, verticalMoveDistance: verticalMoveDistance, movementDirection: horizontalMoveDistance.isLess(than: .zero) ? .left : .right)
            } else {
                // 复位
                panGestureCancel()
            }
        } else {
            if (abs(verticalMoveDistance) > verticalRemoveMinimumDistance || abs(velocity.y) > verticalRemoveMinimumVelocity) &&
                abs(verticalMoveDistance) > 0.1 && // 避免分母为0
                abs(horizontalMoveDistance) / abs(verticalMoveDistance) <= tan(fixDemarcationVerticalAngleAndConvertToRadius()) {
                // 消失
                disappear(horizontalMoveDistance: horizontalMoveDistance, verticalMoveDistance: verticalMoveDistance, movementDirection: verticalMoveDistance.isLess(than: .zero) ? .up : .down)
            } else {
                // 复位
                panGestureCancel()
            }
        }
    }
}

extension DragCardContainer {
    private func panGestureCancel() {
        // 这儿加上动画的原因是：回调给外部的时候就自带动画了
        guard let topCell = activeCardProperties.first?.cell else { return }
        UIView.animate(withDuration: 0.08) {
            let direction = DragCardDirection(horizontalMovementDirection: .identity,
                                              horizontalMovementRatio: .zero,
                                              verticalMovementDirection: .identity,
                                              verticalMovementRatio: .zero)
            self.delegate?.dragCard(self, currentCell: topCell, withIndex: self._currentIndex, currentCardDirection: direction, canRemove: false)
        }
        //
        UIView.animate(withDuration: 0.45,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
            for (_, info) in self.activeCardProperties.enumerated() {
                info.cell.transform = info.transform
                info.cell.frame = info.frame
            }
        }) { (isFinish) in
            if !isFinish { return }
            // 只有当infos数量大于visibleCount时，才移除最底部的卡片
            if self.activeCardProperties.count > self.visibleCount {
                if let info = self.activeCardProperties.last {
                    self.removeFromReusePool(cell: info.cell) // restore的时候要重复用池子里面移除该cell
                }
                self.activeCardProperties.removeLast()
            }
        }
    }
}

extension DragCardContainer {
    private func moving(ratio: CGFloat) {
        // 1、activeCardProperties数量小于等于visibleCount
        // 2、activeCardProperties数量大于visibleCount（activeCardProperties数量最多只比visibleCount多1）
        var ratio = ratio
        if ratio.isLess(than: .zero) {
            ratio = 0.0
        } else if ratio > 1.0 {
            ratio = 1.0
        }
        
        // index = 0 是最顶部的卡片
        // index = activeCardProperties.count - 1 是最下面的卡片
        for (index, info) in activeCardProperties.enumerated() {
            if index >= activeCardProperties.count { continue }
            if activeCardProperties.count <= visibleCount {
                if index == 0 { continue }
            } else {
                if index == activeCardProperties.count - 1 || index == 0 { continue }
            }
            let willInfo = activeCardProperties[index - 1]
            
            let currentTransform = info.transform
            let currentFrame = info.frame
            
            let willTransform = willInfo.transform
            let willFrame = willInfo.frame
            
            info.cell.transform = CGAffineTransform(scaleX:currentTransform.a - (currentTransform.a - willTransform.a) * ratio,
                                                    y: currentTransform.d - (currentTransform.d - willTransform.d) * ratio)
            
            var frame = info.cell.frame
            frame.origin.y = currentFrame.origin.y - (currentFrame.origin.y - willFrame.origin.y) * ratio
            info.cell.frame = frame
        }
    }
    
    private func disappear(horizontalMoveDistance: CGFloat, verticalMoveDistance: CGFloat, movementDirection: DragCardContainer.MovementDirection) {
        if activeCardProperties.count <= 0 { return }
        
        let topCell = activeCardProperties.first! // 临时存储顶层卡片
        activeCardProperties.removeFirst() // 移除顶层卡片
        
        UIView.animate(withDuration: 0.1, animations: {
            // 信息重置
            for (index, info) in self.activeCardProperties.enumerated() {
                if index >= self.initialCardProperties.count { continue }
                let willInfo = self.initialCardProperties[index]
                info.cell.transform = willInfo.transform
                
                var frame = info.cell.frame
                frame.origin.y = willInfo.frame.origin.y
                info.cell.frame = frame
                
                
                info.frame = willInfo.frame
                info.transform = willInfo.transform
            }
            
            // 这儿加上动画的原因是：回调给外部的时候就自带动画了
            let direction = DragCardDirection(horizontalMovementDirection: .identity,
                                              horizontalMovementRatio: .zero,
                                              verticalMovementDirection: .identity,
                                              verticalMovementRatio: .zero)
            self.delegate?.dragCard(self, currentCell: topCell.cell, withIndex: self._currentIndex, currentCardDirection: direction, canRemove: true)
        }) { (isFinish) in
            if !isFinish { return }
            self.isNexting = false
            // 卡片滑出去的回调
            self.delegate?.dragCard(self, didRemoveTopCell: topCell.cell, withIndex: self._currentIndex, movementDirection: movementDirection)
            
            if self.infiniteLoop {
                if self._currentIndex == (self.dataSource?.numberOfCount(self) ?? 0) - 1 {
                    // 最后一张卡片Remove
                    self.delegate?.dragCard(self, didFinishRemoveLastCell: topCell.cell)
                    self._currentIndex = 0 // 索引置为0
                } else {
                    self._currentIndex = self._currentIndex + 1
                }
                if let tmpTopCell = self.activeCardProperties.first?.cell {
                    tmpTopCell.isUserInteractionEnabled = true
                    self.delegate?.dragCard(self, didDisplayTopCell: tmpTopCell, withIndexAt: self._currentIndex)
                }
            } else {
                if self._currentIndex == (self.dataSource?.numberOfCount(self) ?? 0) - 1 {
                    // 最后一张卡片Remove
                    self.delegate?.dragCard(self, didFinishRemoveLastCell: topCell.cell)
                } else {
                    self._currentIndex = self._currentIndex + 1
                }
                if let tmpTopCell = self.activeCardProperties.first?.cell {
                    tmpTopCell.isUserInteractionEnabled = true
                    self.delegate?.dragCard(self, didDisplayTopCell: tmpTopCell, withIndexAt: self._currentIndex)
                }
            }
        }
        
        do {
            // 顶层卡片的动画
            UIView.animate(withDuration: 0.5, animations: {
                var tmpWidth: CGFloat = 0.0
                var tmpHeight: CGFloat = 0.0
                if self.removeDirection == .horizontal {
                    var flag: CGFloat = 0
                    if horizontalMoveDistance > 0 {
                        flag = 1.5 // 右边滑出
                    } else {
                        flag = -1 // 左边滑出
                    }
                    tmpWidth = UIScreen.main.bounds.size.width * CGFloat(flag)
                    tmpHeight = (verticalMoveDistance / horizontalMoveDistance * tmpWidth) + self.initialFirstCellCenter.y
                } else {
                    var flag: CGFloat = 0
                    if verticalMoveDistance > 0 {
                        flag = 1.5 // 向下滑出
                    } else {
                        flag = -1 // 向上滑出
                    }
                    tmpHeight = UIScreen.main.bounds.size.height * CGFloat(flag)
                    tmpWidth = horizontalMoveDistance / verticalMoveDistance * tmpHeight + self.initialFirstCellCenter.x
                }
                topCell.cell.center = CGPoint(x: tmpWidth, y: tmpHeight) // 中心点设置
            }) { (isFinish) in
                if !isFinish { return }
                topCell.cell.center = CGPoint(x: UIScreen.main.bounds.size.width * 5, y: UIScreen.main.bounds.size.height * 5) // 动画完成，把`topCell`的中心点设置在屏幕外面很远的地方，防止pop的时候，会看见cell
                self.addToReusePool(cell: topCell.cell)
            }
        }
    }
}
