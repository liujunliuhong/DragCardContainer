//
//  DragCardContainer.swift
//  YHDragContainer
//
//  Created by jun on 2021/10/18.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

public class DragCardContainer: UIView {
    deinit {
#if DEBUG
        print("DragCardContainer deinit")
#endif
    }
    
    public enum RemoveDirection: Int {
        case horizontal // 水平
        case vertical   // 垂直
    }
    
    public weak var dataSource: DragCardDataSource?
    public weak var delegate: DragCardDelegate?
    public var visibleCount: Int = 3
    public var cellSpacing: CGFloat = 10.0
    public var minimumScale: CGFloat = 0.8
    public var removeDirection: DragCardContainer.RemoveDirection = .horizontal
    public var horizontalRemoveMinimumDistance: CGFloat = UIScreen.main.bounds.size.width / 4.0
    public var horizontalRemoveMinimumVelocity: CGFloat = 1000.0
    public var verticalRemoveMinimumDistance: CGFloat = UIScreen.main.bounds.size.height / 4.0
    public var verticalRemoveMinimumVelocity: CGFloat = 500.0
    public var removeMaxAngle: CGFloat = 10.0
    public var infiniteLoop: Bool = false
    
    public var disableDrag: Bool = false {
        didSet {
            
        }
    }
    
    public var disableClick: Bool = false {
        didSet {
            
        }
    }
    
    /// 当前卡片索引（顶层卡片的索引，可以直接与用户发生交互）
    internal var currentIndex: Int = 0
    internal var initialFirstCellCenter: CGPoint = .zero
    internal var cardProperties: [DragCardProperty] = []
    internal var dynamicCardProperties: [DragCardProperty] = []
    internal var isRevoking: Bool = false
    internal var isNexting: Bool = false
    internal var reusableCells: [DragCardCell] = []
}


extension DragCardContainer {
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview == nil { return }
    }
}

extension DragCardContainer {
    /// 重新加载界面
    public func reloadData() {
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
        //
        let maxCount: Int = dataSource?.numberOfCount(self) ?? 0
        let showCount: Int = min(maxCount, visibleCount)
        if showCount <= 0 { return }
        //
        var avergeScale: CGFloat = 1.0
        if showCount > 1 {
            avergeScale = CGFloat(1.0 - fixScale(scale: minimumScale)) / CGFloat(showCount - 1)
        }
        //
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()
        //
        let cardWidth = bounds.size.width
        let cardHeight = bounds.size.height - CGFloat(showCount - 1) * fixCellSpacing(cellSpacing: cellSpacing)
        
        if cardHeight.isLessThanOrEqualTo(.zero) { return }
        
        for index in 0..<showCount {
            let y = fixCellSpacing(cellSpacing: cellSpacing) * CGFloat(index)
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
        
        guard cardProperties.count > 0 else { return }
        
        let topCell = cardProperties.first!.cell
        
        topCell.isUserInteractionEnabled = true
        
        delegate?.dragCard(self, didDisplayCell: topCell, withIndexAt: currentIndex)
    }
}

extension DragCardContainer {
    
}

extension DragCardContainer {
    internal func installNextCard() {
        let maxCount: Int = self.dataSource?.numberOfCount(self) ?? 0
        let showCount: Int = min(maxCount, self.visibleCount)
        if showCount <= 0 { return }
        
        var cell: DragCardCell?
        
        if infiniteLoop {
            if maxCount > showCount {
                if self.currentIndex + showCount >= maxCount {
                    // 无剩余卡片可以滑动，把之前滑出去的，加在最下面
                    cell = self.dataSource?.dragCard(self, indexOfCell: self.currentIndex + showCount - maxCount)
                } else {
                    // 还有剩余卡片可以滑动
                    cell = self.dataSource?.dragCard(self, indexOfCell: self.currentIndex + showCount)
                }
            } else { // 最多只是`maxCount = showCount`，比如总数是3张，一次性显示3张
                // 滑出去的那张，放在最下面
                cell = self.dataSource?.dragCard(self, indexOfCell: self.currentIndex)
            }
        } else {
            if self.currentIndex + showCount >= maxCount { return } // 无剩余卡片可滑
            cell = self.dataSource?.dragCard(self, indexOfCell: self.currentIndex + showCount)
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
}

extension DragCardContainer {
    private func addPanGesture(for cell: DragCardCell) {
        self.removePanGesture(for: cell)
        if self.disableDrag { return }
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(panGesture:)))
        cell.addGestureRecognizer(pan)
        cell.panGesture = pan
    }
    
    private func addTapGesture(for cell: DragCardCell) {
        self.removeTapGesture(for: cell)
        if self.disableClick { return }
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer(tapGesture:)))
        cell.addGestureRecognizer(tap)
        cell.tapGesture = tap
    }
    
    private func removePanGesture(for cell: DragCardCell) {
        if let pan = cell.panGesture {
            cell.removeGestureRecognizer(pan)
        }
    }
    
    private func removeTapGesture(for cell: DragCardCell) {
        if let tap = cell.tapGesture {
            cell.removeGestureRecognizer(tap)
        }
    }
}

extension DragCardContainer {
    
    
    
}
