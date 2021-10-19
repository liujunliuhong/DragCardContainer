//
//  DragCardContainer.swift
//  YHDragContainer
//
//  Created by jun on 2021/10/18.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

public class DragCardContainer: UIView {
    deinit {
#if DEBUG
        print("DragCardContainer deinit")
#endif
    }
    
    /// 卡片移除方向
    public enum RemoveDirection: Int {
        case horizontal // 水平
        case vertical   // 垂直
    }
    
    /// 卡片运动方向
    public enum MovementDirection: Int {
        case identity
        case left
        case right
        case up
        case down
    }
    
    /// 数据源
    public weak var dataSource: DragCardDataSource?
    
    /// 代理
    public weak var delegate: DragCardDelegate?
    
    /// 可见卡片数量
    public var visibleCount: Int = 3
    
    /// 卡片之间的距离
    public var cellSpacing: CGFloat = 10.0
    
    /// 卡片最小缩放比例
    public var minimumScale: CGFloat = 0.8
    
    /// 卡pain移除方向
    public var removeDirection: DragCardContainer.RemoveDirection = .horizontal
    /// 水平方向上最大移除距离
    /// `removeDirection`设置为`horizontal`时，才生效
    public var horizontalRemoveMinimumDistance: CGFloat = UIScreen.main.bounds.size.width / 4.0
    
    /// 水平方向上最大移除速度
    /// `removeDirection`设置为`horizontal`时，才生效
    public var horizontalRemoveMinimumVelocity: CGFloat = 1000.0
    
    /// 垂直方向上最大移除距离
    /// `removeDirection`设置为`vertical`时，才生效
    public var verticalRemoveMinimumDistance: CGFloat = UIScreen.main.bounds.size.height / 4.0
    
    /// 垂直方向上最大移除速度
    /// `removeDirection`设置为`vertical`时，才生效
    public var verticalRemoveMinimumVelocity: CGFloat = 500.0
    
    /// 卡片滑动过程中旋转的角度
    public var cellRotationMaximumAngle: CGFloat = 10.0
    
    /// 是否无限滑动
    public var infiniteLoop: Bool = false
    
    /// 卡片滑动方向和纵轴之间的角度（你可以自己写个Demo，然后改变该属性的值，你就明白该属性的意思了）
    /// 如果水平方向滑动能移除卡片，请把该值设置的尽量小
    /// 如果垂直方向能够移除卡片，请把该值设置的大点
    public var demarcationVerticalAngle: CGFloat = 5.0
    
    /// 是否禁用拖动
    public var disableDrag: Bool = false {
        didSet {
            for (_, info) in dynamicCardProperties.enumerated() {
                if disableDrag {
                    removePanGesture(for: info.cell)
                } else {
                    addPanGesture(for: info.cell)
                }
            }
        }
    }
    
    /// 是否禁用卡片的点击事件
    public var disableClick: Bool = false {
        didSet {
            for (_, info) in dynamicCardProperties.enumerated() {
                if disableClick {
                    removeTapGesture(for: info.cell)
                } else {
                    addTapGesture(for: info.cell)
                }
            }
        }
    }
    
    internal var currentIndex: Int = 0 // 当前卡片索引（顶层卡片的索引，可以直接与用户发生交互）
    internal var initialFirstCellCenter: CGPoint = .zero // 初始化顶层卡片的位置
    internal var cardProperties: [DragCardProperty] = [] // 卡片属性集合
    internal var dynamicCardProperties: [DragCardProperty] = [] // 动态卡片属性集合
    internal var isRevoking: Bool = false // 是否正在撤销，避免在短时间内多次调用revoke方法，必须等上一张卡片revoke完成，才能revoke下一张卡片
    internal var isNexting: Bool = false // 是否正在调用`nextCard`方法，避免在短时间内多次调用`nextCard`方法，必须`nextCard`完成，才能继续下一次`nextCard`
    internal var reusableCells: [DragCardCell] = [] // 重用卡片集合
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init() {
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DragCardContainer {
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview == nil { return }
        reloadData()
    }
}

extension DragCardContainer {
    /// 重新加载界面
    public func reloadData() {
        if superview == nil { return }
        superview?.setNeedsLayout()
        superview?.layoutIfNeeded()
        //
        let maxCount: Int = dataSource?.numberOfCount(self) ?? 0
        let showCount: Int = min(maxCount, visibleCount)
        if showCount <= 0 { return }
        //
        let cardWidth = bounds.size.width
        let cardHeight = bounds.size.height - CGFloat(showCount - 1) * fixCellSpacing()
        if cardHeight.isLessThanOrEqualTo(.zero) { return }
        //
        reusableCells.forEach { cell in
            cell.removeFromSuperview()
        }
        reusableCells.removeAll()
        //
        dynamicCardProperties.forEach { p in
            p.cell.removeFromSuperview()
        }
        dynamicCardProperties.removeAll()
        //
        cardProperties.forEach { p in
            p.cell.removeFromSuperview()
        }
        cardProperties.removeAll()
        //
        currentIndex = 0
        isRevoking = false
        isNexting = false
        initialFirstCellCenter = .zero
        //
        var avergeScale: CGFloat = 1.0
        if showCount > 1 {
            avergeScale = CGFloat(1.0 - fixMinimumScale()) / CGFloat(showCount - 1)
        }
        
        for index in 0..<showCount {
            let y = fixCellSpacing() * CGFloat(index)
            let frame = CGRect(x: 0, y: y, width: cardWidth, height: cardHeight)
            guard let cell = dataSource?.dragCard(self, indexOfCell: index) else { continue }
            
            let tmpScale: CGFloat = 1.0 - (avergeScale * CGFloat(index))
            let transform = CGAffineTransform(scaleX: tmpScale, y: tmpScale)
            
            cell.isUserInteractionEnabled = false
            cell.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            insertSubview(cell, at: 0)
            
            cell.transform = transform
            cell.frame = frame
            
            do {
                let property = DragCardProperty(cell: cell)
                property.transform = transform
                property.frame = frame
                dynamicCardProperties.append(property)
            }
            do {
                let property = DragCardProperty(cell: cell)
                property.transform = transform
                property.frame = frame
                cardProperties.append(property)
            }
            
            if !disableDrag {
                addPanGesture(for: cell)
            }
            if !disableClick {
                addTapGesture(for: cell)
            }
        }
        
        guard dynamicCardProperties.count > 0 else { return }
        
        let topCell = dynamicCardProperties.first!.cell
        
        initialFirstCellCenter = topCell.center
        
        topCell.isUserInteractionEnabled = true
        
        delegate?.dragCard(self, didDisplayTopCell: topCell, withIndexAt: currentIndex)
    }
    
    /// 显示下一张卡片
    public func nextCard(topCardMovementDirection: DragCardContainer.MovementDirection) {
        func _horizontalNextCell(isRight: Bool) {
            if removeDirection == .vertical { return }
            installNextCard()
            let distance: CGFloat = 150.0
            isNexting = true
            autoDisappear(horizontalMoveDistance: (isRight ? distance : -distance), verticalMoveDistance: -10, movementDirection: isRight ? .right : .left)
        }
        func _verticalNextCell(isUp: Bool) {
            if removeDirection == .horizontal { return }
            installNextCard()
            let distance: CGFloat = 30.0
            isNexting = true
            autoDisappear(horizontalMoveDistance: 0.0, verticalMoveDistance: (isUp ? -distance : distance), movementDirection: isUp ? .up : .down)
        }
        
        if isNexting { return }
        if isRevoking { return }
        switch topCardMovementDirection {
            case .right:
                _horizontalNextCell(isRight: true)
            case .left:
                _horizontalNextCell(isRight: false)
            case .up:
                _verticalNextCell(isUp: true)
            case .down:
                _verticalNextCell(isUp: false)
            default:
                break
        }
    }
    
    /// 撤销
    /// canRevokeWhenFirst: 当已经是第一张卡片的时候，是否还能继续撤销
    public func revoke(movementDirection: DragCardContainer.MovementDirection, canRevokeWhenFirst: Bool = false) {
        if !canRevokeWhenFirst && currentIndex <= 0 { return }
        if movementDirection == .identity { return }
        if isRevoking { return }
        if isNexting { return }
        if removeDirection == .horizontal {
            if movementDirection == .up || movementDirection == .down { return }
        }
        if removeDirection == .vertical {
            if movementDirection == .left || movementDirection == .right { return }
        }
        guard let topCell = dynamicCardProperties.first?.cell else { return } // 顶层卡片
        
        guard let cell = dataSource?.dragCard(self, indexOfCell: (currentIndex - 1 < 0) ? 0 : (currentIndex - 1)) else { return } // 获取上一个卡片
        
        cell.isUserInteractionEnabled = false
        cell.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        addSubview(cell)
        
        if !disableDrag { addPanGesture(for: cell) }
        if !disableClick { addTapGesture(for: cell) }
        
        cell.transform = .identity
        cell.frame = topCell.frame
        
        if removeDirection == .horizontal {
            var flag: CGFloat = 1.0
            if movementDirection == .left {
                flag = -1.0
            } else if movementDirection == .right {
                flag = 1.0
            }
            cell.transform = CGAffineTransform(rotationAngle: fixCellRotationMaximumAngleAndConvertToRadius() * flag)
        } else {
            // 垂直方向不做处理
            cell.transform = .identity
        }
        
        if removeDirection == .horizontal {
            var flag: CGFloat = 2.0
            if movementDirection == .left {
                flag = -0.5
            } else if movementDirection == .right {
                flag = 1.5
            }
            let tmpWidth = UIScreen.main.bounds.size.width * flag
            let tmpHeight = self.initialFirstCellCenter.y - 20.0
            cell.center = CGPoint(x: tmpWidth, y: tmpHeight)
        } else {
            var flag: CGFloat = 2.0
            if movementDirection == .up {
                flag = -1.0
            } else if movementDirection == .down {
                flag = 2.0
            }
            let tmpWidth = self.initialFirstCellCenter.x
            let tmpHeight = UIScreen.main.bounds.size.height * flag
            cell.center = CGPoint(x: tmpWidth, y: tmpHeight)
        }
        
        dynamicCardProperties.first?.cell.isUserInteractionEnabled = false
        
        let property = DragCardProperty(cell: cell)
        property.transform = topCell.transform
        property.frame = topCell.frame
        dynamicCardProperties.insert(property, at: 0)
        
        isRevoking = true
        
        do {
            UIView.animate(withDuration: 0.3, animations: {
                cell.center = self.initialFirstCellCenter
            }, completion: nil)
            
            // 延迟0.1秒
            // 花费0.2秒使`transform`变为`identity`
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut, animations: {
                cell.transform = .identity
            }, completion: nil)
        }
        
        do {
            UIView.animate(withDuration: 0.1, animations: {
                for (index, info) in self.dynamicCardProperties.enumerated() {
                    if self.dynamicCardProperties.count <= self.visibleCount {
                        if index == 0 { continue }
                    } else {
                        if index == self.dynamicCardProperties.count - 1 || index == 0 { continue }
                    }
                    
                    /**********************************************************************
                     4 3  2 1 0
                     stableInfos    🀫 🀫 🀫 🀫 🀫
                     
                     5 4 3  2 1 0
                     infos          🀫 🀫 🀫 🀫 🀫 🀫👈这个卡片新添加的
                     ***********************************************************************/
                    let willInfo = self.cardProperties[index]
                    
                    info.cell.transform = willInfo.transform
                    
                    var frame = info.cell.frame
                    frame.origin.y = willInfo.frame.origin.y
                    info.cell.frame = frame
                    
                    info.transform = willInfo.transform
                    info.frame = willInfo.frame
                }
            }) { (isFinish) in
                guard let bottomCell = self.dynamicCardProperties.last?.cell else { return }
                
                // 移除最底部的卡片
                if self.dynamicCardProperties.count > self.visibleCount {
                    self.addToReusePool(cell: bottomCell)
                    self.dynamicCardProperties.removeLast()
                }
                
                self.currentIndex = (self.currentIndex - 1 < 0) ? 0 : (self.currentIndex - 1)
                cell.isUserInteractionEnabled = true
                
                self.isRevoking = false
                
                // 显示顶层卡片的回调
                self.delegate?.dragCard(self, didDisplayTopCell: cell, withIndexAt: self.currentIndex)
            }
        }
    }
    
    public func dequeueReusableCell(withIdentifier identifier: String) -> DragCardCell? {
        var reusableCell: DragCardCell?
        for (_, cell) in reusableCells.enumerated() {
            // 在缓存池子中，且未被使用
            let reuseIdentifier = cell.reuseIdentifier
            if reuseIdentifier == identifier {
                if cell.isReuse == false {
                    cell.isReuse = true // 标记为正在使用缓存池子中的Cell
                    reusableCell = cell
                    break
                }
            }
        }
        // 每次都遍历一次，如果未使用，从父视图移除
        for (_, cell) in reusableCells.enumerated() {
            if !cell.isReuse && cell.superview != nil {
                cell.removeFromSuperview()
            }
        }
        return reusableCell
    }
    
    public func register(_ cellClass: DragCardCell.Type, forCellReuseIdentifier identifier: String) {
        let className = NSStringFromClass(cellClass)
        var find: Bool = false
        for (_, cell) in reusableCells.enumerated() {
            if NSStringFromClass(cell.classForCoder) == className {
                find = true
                break
            }
        }
        if find { return }
        let cell = cellClass.init(reuseIdentifier: identifier)
        addToReusePool(cell: cell)
    }
}

extension DragCardContainer {
    private func addPanGesture(for cell: DragCardCell) {
        removePanGesture(for: cell)
        if disableDrag { return }
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(panGesture:)))
        cell.addGestureRecognizer(pan)
        cell.panGesture = pan
    }
    
    private func addTapGesture(for cell: DragCardCell) {
        removeTapGesture(for: cell)
        if disableClick { return }
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer(tapGesture:)))
        cell.addGestureRecognizer(tap)
        cell.tapGesture = tap
    }
    
    private func removePanGesture(for cell: DragCardCell) {
        guard let pan = cell.panGesture else { return }
        cell.removeGestureRecognizer(pan)
    }
    
    private func removeTapGesture(for cell: DragCardCell) {
        guard let tap = cell.tapGesture else { return }
        cell.removeGestureRecognizer(tap)
    }
}

extension DragCardContainer {
    internal func addToReusePool(cell: DragCardCell) {
        guard let identifier = cell.identifier else { return }
        cell.isReuse = false
        
        var isContain: Bool = false
        for (_, c) in reusableCells.enumerated() {
            if let _identifier = c.identifier, _identifier == identifier, c.reuseIdentifier == cell.reuseIdentifier {
                isContain = true
                break
            }
        }
        if isContain { return }
        reusableCells.append(cell)
    }
    
    internal func removeFromReusePool(cell: DragCardCell) {
        for (index, c) in reusableCells.enumerated() {
            // 在缓存池子中，且未被使用
            if let identifier = cell.identifier,
               let _identifier = c.identifier,
               cell.reuseIdentifier == c.reuseIdentifier,
               identifier == _identifier,
               cell.isReuse == false {
                reusableCells.remove(at: index)
                break
            }
        }
        cell.removeFromSuperview()
    }
}

extension DragCardContainer {
    internal func installNextCard() {
        let maxCount: Int = dataSource?.numberOfCount(self) ?? 0
        let showCount: Int = min(maxCount, visibleCount)
        if showCount <= 0 { return }
        
        var cell: DragCardCell?
        
        if infiniteLoop {
            if maxCount > showCount {
                if currentIndex + showCount >= maxCount {
                    // 无剩余卡片可以滑动，把之前滑出去的，加在最下面
                    cell = dataSource?.dragCard(self, indexOfCell: currentIndex + showCount - maxCount)
                } else {
                    // 还有剩余卡片可以滑动
                    cell = dataSource?.dragCard(self, indexOfCell: currentIndex + showCount)
                }
            } else { // 最多只是`maxCount = showCount`，比如总数是3张，一次性显示3张
                // 滑出去的那张，放在最下面
                cell = dataSource?.dragCard(self, indexOfCell: currentIndex)
            }
        } else {
            if currentIndex + showCount >= maxCount { return } // 无剩余卡片可滑
            cell = dataSource?.dragCard(self, indexOfCell: currentIndex + showCount)
        }
        
        if cell == nil { return }
        guard let bottomCell = self.dynamicCardProperties.last?.cell else { return }
        
        cell!.isUserInteractionEnabled = false
        cell!.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        insertSubview(cell!, at: 0)
        cell!.transform = bottomCell.transform
        cell!.frame = bottomCell.frame
        
        let property = DragCardProperty(cell: cell!)
        property.frame = cell!.frame
        property.transform = cell!.transform
        dynamicCardProperties.append(property)
        
        if !disableDrag {
            addPanGesture(for: cell!)
        }
        if !disableClick {
            addTapGesture(for: cell!)
        }
    }
    
    private func autoDisappear(horizontalMoveDistance: CGFloat, verticalMoveDistance: CGFloat, movementDirection: DragCardContainer.MovementDirection) {
        if dynamicCardProperties.count <= 0 { return }
        
        let topCell = dynamicCardProperties.first! // 临时存储顶层卡片
        dynamicCardProperties.removeFirst() // 移除顶层卡片
        
        // 顶层卡片下面的那些卡片的动画
        UIView.animate(withDuration: 0.1, animations: {
            // 信息重置
            for (index, info) in self.dynamicCardProperties.enumerated() {
                let willInfo = self.cardProperties[index]
                
                info.cell.transform = willInfo.transform
                
                var frame = info.cell.frame
                frame.origin.y = willInfo.frame.origin.y
                info.cell.frame = frame
                
                info.frame = willInfo.frame
                info.transform = willInfo.transform
            }
        }) { (isFinish) in
            if !isFinish { return }
            self.isNexting = false
            // 卡片滑出去的回调
            self.delegate?.dragCard(self, didRemoveTopCell: topCell.cell, withIndex: self.currentIndex, movementDirection: movementDirection)
            
            if self.infiniteLoop {
                if self.currentIndex == (self.dataSource?.numberOfCount(self) ?? 0) - 1 {
                    // 最后一张卡片Remove
                    self.delegate?.dragCard(self, didFinishRemoveLastCell: topCell.cell)
                    self.currentIndex = 0 // 索引置为0
                } else {
                    self.currentIndex = self.currentIndex + 1
                }
                if let tmpTopCell = self.dynamicCardProperties.first?.cell {
                    tmpTopCell.isUserInteractionEnabled = true
                    self.delegate?.dragCard(self, didDisplayTopCell: tmpTopCell, withIndexAt: self.currentIndex)
                }
            } else {
                if self.currentIndex == (self.dataSource?.numberOfCount(self) ?? 0) - 1 {
                    // 最后一张卡片Remove
                    self.delegate?.dragCard(self, didFinishRemoveLastCell: topCell.cell)
                } else {
                    self.currentIndex = self.currentIndex + 1
                }
                if let tmpTopCell = self.dynamicCardProperties.first?.cell {
                    tmpTopCell.isUserInteractionEnabled = true
                    self.delegate?.dragCard(self, didDisplayTopCell: tmpTopCell, withIndexAt: self.currentIndex)
                }
            }
        }
        
        // 自动消失时，这儿加上个动画，这样外部就自带动画了
        do {
            let direction1 = DragCardDirection(horizontalMovementDirection: horizontalMoveDistance > 0.0 ? .right : .left,
                                              horizontalMovementRatio: horizontalMoveDistance > 0.0 ? 1.0 : -1.0,
                                              verticalMovementDirection: verticalMoveDistance > 0 ? .down : .up,
                                              verticalMovementRatio: verticalMoveDistance > 0.0 ? 1.0 : -1.0)
            
            let direction2 = DragCardDirection(horizontalMovementDirection: .identity,
                                               horizontalMovementRatio: .zero,
                                               verticalMovementDirection: .identity,
                                               verticalMovementRatio: .zero)
            
            UIView.animate(withDuration: 0.25, animations: {
                self.delegate?.dragCard(self, currentCell: topCell.cell, withIndex: self.currentIndex, currentCardDirection: direction1, canRemove: false)
            }) { (isFinish) in
                if !isFinish { return }
                UIView.animate(withDuration: 0.25) {
                    self.delegate?.dragCard(self, currentCell: topCell.cell, withIndex: self.currentIndex, currentCardDirection: direction2, canRemove: true)
                }
            }
        }
        
        do {
            // 顶层卡片的动画: 自动消失时，设置个旋转角度
            UIView.animate(withDuration: 0.2, animations: {
                topCell.cell.transform = CGAffineTransform(rotationAngle: horizontalMoveDistance > 0 ? self.fixCellRotationMaximumAngleAndConvertToRadius() : -self.fixCellRotationMaximumAngleAndConvertToRadius())
            }, completion: nil)
            
            // 顶层卡片的动画: center设置
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
