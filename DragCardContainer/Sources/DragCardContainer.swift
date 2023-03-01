//
//  DragCardContainer.swift
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

public class DragCardContainer: UIView {
    deinit {
//        activeCardProperties.forEach { p in
//            p.cell.removeFromSuperview()
//        }
//        reusableCells.forEach { cell in
//            cell.removeFromSuperview()
//        }
//        activeCardProperties.removeAll()
//        initialCardProperties.removeAll()
//        reusableCells.removeAll()
//        _currentIndex = 0
//        initialFirstCellCenter = .zero
//        registerTables.removeAll()
#if DEBUG
        print("DragCardContainer deinit")
#endif
    }
    
    /// 卡片移除方向
//    public enum RemoveDirection: Int {
//        case horizontal // 水平
//        case vertical   // 垂直
//    }
//
//    /// 卡片运动方向
//    public enum MovementDirection: Int {
//        case identity
//        case left
//        case right
//        case up
//        case down
//    }
//
//
    public weak var dataSource: DragCardDataSource?
//    public weak var delegate: DragCardDelegate?
    
    
    private lazy var modeState: ModeState = {
        let modeState = ModeState(cardContainer: self)
        return modeState
    }()
    
    
    /// 可见卡片数量
    public var visibleCount: Int = 3 {
        didSet {
            reloadData()
        }
    }
    
    /// 卡片之间的距离
    public var cardSpacing: CGFloat = 20.0 {
        didSet {
            reloadData()
        }
    }
    
    /// 卡片最小缩放比例
    public var minimumScale: CGFloat = 0.8 {
        didSet {
            reloadData()
        }
    }
    
    
    /// 是否无限滑动
    public var infiniteLoop: Bool = false {
        didSet {
            reloadData()
        }
    }
    
    public var allowedDirection = Direction.horizontal
    
    public var minimumTranslationInPercent: CGFloat = 0.5
    public var minimumVelocityInPointPerSecond: CGFloat = 750
    
    
    /// 卡片滑动过程中旋转的角度
    public var cardRotationMaximumAngle: CGFloat = 20.0 {
        didSet {
            reloadData()
        }
    }
    
    
    
    
    
    
    
    
    
    
    /// 卡片移除方向
//    public var removeDirection: DragCardContainer.RemoveDirection = .horizontal {
//        didSet {
//            reloadData()
//        }
//    }
    
    
    /// 水平方向上最大移除距离
    /// `removeDirection`设置为`horizontal`时，才生效
//    public var horizontalRemoveMinimumDistance: CGFloat = UIScreen.main.bounds.size.width / 4.0 {
//        didSet {
//            reloadData()
//        }
//    }
//
//    /// 水平方向上最大移除速度
//    /// `removeDirection`设置为`horizontal`时，才生效
//    public var horizontalRemoveMinimumVelocity: CGFloat = 1000.0 {
//        didSet {
//            reloadData()
//        }
//    }
//
//    /// 垂直方向上最大移除距离
//    /// `removeDirection`设置为`vertical`时，才生效
//    public var verticalRemoveMinimumDistance: CGFloat = UIScreen.main.bounds.size.height / 4.0 {
//        didSet {
//            reloadData()
//        }
//    }
//
//    /// 垂直方向上最大移除速度
//    /// `removeDirection`设置为`vertical`时，才生效
//    public var verticalRemoveMinimumVelocity: CGFloat = 500.0 {
//        didSet {
//            reloadData()
//        }
//    }
    
    
    
    
    
    /// 卡片滑动方向和纵轴之间的角度（你可以自己写个Demo，然后改变该属性的值，你就明白该属性的意思了）
    /// 如果水平方向滑动能移除卡片，请把该值设置的尽量小
    /// 如果垂直方向能够移除卡片，请把该值设置的大点
//    public var demarcationVerticalAngle: CGFloat = 5.0 {
//        didSet {
//            reloadData()
//        }
//    }
//
//    /// 当数据源只有1个的时候，是否可以撤销
//    public var canRevokeWhenOnlyOneDataSource: Bool = false {
//        didSet {
//            reloadData()
//        }
//    }
//
//    /// 当前卡片索引（顶层卡片的索引，可以直接与用户发生交互）
//    public var currentIndex: Int {
//        set {
//            _currentIndex = newValue
//            reloadData()
//        }
//        get {
//            return _currentIndex
//        }
//    }
//
//    /// 是否禁用拖动
//    public var disableDrag: Bool = false {
//        didSet {
//            for (_, info) in activeCardProperties.enumerated() {
//                if disableDrag {
//                    removePanGesture(for: info.cell)
//                } else {
//                    addPanGesture(for: info.cell)
//                }
//            }
//        }
//    }
//
//    /// 是否禁用卡片的点击事件
//    public var disableClick: Bool = false {
//        didSet {
//            for (_, info) in activeCardProperties.enumerated() {
//                if disableClick {
//                    removeTapGesture(for: info.cell)
//                } else {
//                    addTapGesture(for: info.cell)
//                }
//            }
//        }
//    }
    
//    internal var containerView: UIView!
//    internal var _currentIndex: Int = 0
//    internal var initialFirstCellCenter: CGPoint = .zero // 初始化顶层卡片的位置
//    internal var initialCardProperties: [DragCardProperty] = [] // 卡片属性集合
//    internal var activeCardProperties: [DragCardActiveProperty] = [] // 动态卡片属性集合
//    internal var registerTables: [RegisterTable] = [] // 注册表
//    internal var reusableCells: [DragCardCell] = [] // 重用卡片集合
    
    private var cacheSize: CGSize?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        fatalError("init(coder:) has not been implemented")
    }
}

extension DragCardContainer {
    private func setupUI() {
        backgroundColor = .orange
//        containerView = UIView()
//        addSubview(containerView)
    }
}

extension DragCardContainer {
    public override func layoutSubviews() {
        super.layoutSubviews()
        print("😁")
//        containerView.frame = bounds
        reloadData()
    }
}

extension DragCardContainer {
    /// 重新加载界面
    public func reloadData() {
        if cacheSize != bounds.size {
            modeState.prepare()
        }
        cacheSize = bounds.size
        
//        if superview == nil { return }
//        superview?.setNeedsLayout()
//        superview?.layoutIfNeeded()
//        //
//        let numberOfCount: Int = dataSource?.numberOfCount(self) ?? 0
//        if numberOfCount <= 0 { return }
//        let displayCount = min(numberOfCount, visibleCount)
//        if displayCount <= 0 { return }
//        //
//        let cardWidth = bounds.size.width
//        let cardHeight = bounds.size.height - CGFloat(displayCount - 1) * fixCellSpacing()
//        if cardWidth.isLessThanOrEqualTo(.zero) { return }
//        if cardHeight.isLessThanOrEqualTo(.zero) { return }
//        //
//        var avergeScale: CGFloat = 1.0
//        if displayCount > 1 {
//            avergeScale = CGFloat(1.0 - fixMinimumScale()) / CGFloat(displayCount - 1)
//        }
//        if _currentIndex > numberOfCount {
//            _currentIndex = numberOfCount - 1 // 表示最后一张
//        }
//        if _currentIndex < 0 {
//            _currentIndex = 0 // 第一张
//        }
//        if _currentIndex == 0 && numberOfCount == 0 {
//            return
//        }
//        //
//        activeCardProperties.forEach { p in
//            p.cell.removeFromSuperview()
//        }
//        reusableCells.forEach { cell in
//            cell.isReuse = false
//        }
//        activeCardProperties.removeAll()
//        initialCardProperties.removeAll()
//        initialFirstCellCenter = .zero
//        //
//        for index in 0..<displayCount {
//            let y = fixCellSpacing() * CGFloat(index)
//            let frame = CGRect(x: 0, y: y, width: cardWidth, height: cardHeight)
//            let tmpScale: CGFloat = 1.0 - (avergeScale * CGFloat(index))
//            let transform = CGAffineTransform(scaleX: tmpScale, y: tmpScale)
//
//            do {
//                // 创建一个临时View
//                let tempView = UIView()
//                tempView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
//                tempView.frame = frame
//                tempView.transform = transform
//
//                let property = DragCardProperty()
//                property.frame = tempView.frame
//                property.transform = tempView.transform
//                initialCardProperties.append(property)
//                if index == 0 {
//                    initialFirstCellCenter = tempView.center
//                }
//            }
//            if index + _currentIndex < numberOfCount {
//                if let cell = dataSource?.dragCard(self, indexOfCell: index + _currentIndex) {
//                    cell.isUserInteractionEnabled = false
//                    cell.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
//                    containerView.insertSubview(cell, at: 0)
//                    //
//                    cell.transform = .identity
//                    // 这只`frame`和`transform`的顺序不能颠倒
//                    cell.frame = frame
//                    cell.transform = transform
//                    //
//                    let property = DragCardActiveProperty(cell: cell)
//                    property.frame = cell.frame
//                    property.transform = cell.transform
//                    activeCardProperties.append(property)
//                    //
//                    if !disableDrag {
//                        addPanGesture(for: cell)
//                    }
//                    if !disableClick {
//                        addTapGesture(for: cell)
//                    }
//                }
//            }
//        }
//        guard activeCardProperties.count > 0 else { return }
//        let topCell = activeCardProperties.first!.cell
//        topCell.isUserInteractionEnabled = true
//        delegate?.dragCard(self, didDisplayTopCell: topCell, withIndexAt: _currentIndex)
    }
    
    /// 显示下一张卡片
//    public func nextCard(topCardMovementDirection: DragCardContainer.MovementDirection) {
//        func _horizontalNextCell(isRight: Bool) {
//            if removeDirection == .vertical { return }
//            if activeCardProperties.count <= 0 { return }
//            installNextCard()
//            let distance: CGFloat = 150.0
//            disappear(horizontalMoveDistance: (isRight ? distance : -distance), verticalMoveDistance: -10, movementDirection: isRight ? .right : .left)
//        }
//        func _verticalNextCell(isUp: Bool) {
//            if removeDirection == .horizontal { return }
//            if activeCardProperties.count <= 0 { return }
//            installNextCard()
//            let distance: CGFloat = 30.0
//            disappear(horizontalMoveDistance: 0.0, verticalMoveDistance: (isUp ? -distance : distance), movementDirection: isUp ? .up : .down)
//        }
//        let numberOfCount = dataSource?.numberOfCount(self) ?? 0
//        if numberOfCount <= 0 { return }
//        let displayCount = min(numberOfCount, visibleCount)
//        if displayCount <= 0 { return }
//
//        switch topCardMovementDirection {
//            case .right:
//                _horizontalNextCell(isRight: true)
//            case .left:
//                _horizontalNextCell(isRight: false)
//            case .up:
//                _verticalNextCell(isUp: true)
//            case .down:
//                _verticalNextCell(isUp: false)
//            default:
//                break
//        }
//    }
//
//    /// 撤销
//    /// canRevokeWhenFirstCell: 当已经是第一张卡片的时候，是否还能继续撤销
//    public func revoke(movementDirection: DragCardContainer.MovementDirection) {
//        let numberOfCount = dataSource?.numberOfCount(self) ?? 0
//        if numberOfCount <= 0 { return }
//        let displayCount = min(numberOfCount, visibleCount)
//        if displayCount <= 0 { return }
//        if numberOfCount == 1 && !canRevokeWhenOnlyOneDataSource { return }
//        if numberOfCount > 1 && _currentIndex <= 0 { return }
//        if movementDirection == .identity { return }
//
//        if removeDirection == .horizontal {
//            if movementDirection == .up || movementDirection == .down { return }
//        }
//        if removeDirection == .vertical {
//            if movementDirection == .left || movementDirection == .right { return }
//        }
//        guard let topCell = activeCardProperties.first?.cell else { return } // 顶层卡片
//
//        guard let cell = dataSource?.dragCard(self, indexOfCell: (_currentIndex - 1 < 0) ? 0 : (_currentIndex - 1)) else { return } // 获取上一个卡片
//
//        cell.isUserInteractionEnabled = true
//        cell.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
//        containerView.addSubview(cell)
//
//        _currentIndex = (_currentIndex - 1 < 0) ? 0 : (_currentIndex - 1)
//        // 显示顶层卡片的回调
//        delegate?.dragCard(self, didDisplayTopCell: cell, withIndexAt: _currentIndex)
//
//        if !disableDrag { addPanGesture(for: cell) }
//        if !disableClick { addTapGesture(for: cell) }
//
//        cell.transform = .identity
//        // 这只`frame`和`transform`的顺序不能颠倒
//        cell.frame = topCell.frame
//
//        if removeDirection == .horizontal {
//            var flag: CGFloat = 1.0
//            if movementDirection == .left {
//                flag = -1.0
//            } else if movementDirection == .right {
//                flag = 1.0
//            }
//            cell.transform = CGAffineTransform(rotationAngle: fixCellRotationMaximumAngleAndConvertToRadius() * flag)
//        } else {
//            // 垂直方向不做处理
//            cell.transform = .identity
//        }
//
//        if removeDirection == .horizontal {
//            var flag: CGFloat = 2.0
//            if movementDirection == .left {
//                flag = -0.5
//            } else if movementDirection == .right {
//                flag = 1.5
//            }
//            let tmpWidth = UIScreen.main.bounds.size.width * flag
//            let tmpHeight = initialFirstCellCenter.y - 20.0
//            cell.center = CGPoint(x: tmpWidth, y: tmpHeight)
//        } else {
//            var flag: CGFloat = 2.0
//            if movementDirection == .up {
//                flag = -1.0
//            } else if movementDirection == .down {
//                flag = 2.0
//            }
//            let tmpWidth = initialFirstCellCenter.x
//            let tmpHeight = UIScreen.main.bounds.size.height * flag
//            cell.center = CGPoint(x: tmpWidth, y: tmpHeight)
//        }
//
//        activeCardProperties.first?.cell.isUserInteractionEnabled = false
//
//        let property = DragCardActiveProperty(cell: cell)
//        property.frame = topCell.frame
//        property.transform = topCell.transform
//        activeCardProperties.insert(property, at: 0)
//
//        // 顶层卡片的动画
//        UIView.animate(withDuration: 0.3, animations: {
//            cell.center = self.initialFirstCellCenter
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut, animations: {
//            cell.transform = .identity
//        }, completion: nil)
//
//        // 顶层卡片下面的那些卡片的动画
//        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) {
//            for (index, info) in self.activeCardProperties.enumerated() {
//                if index >= self.initialCardProperties.count { continue }
//                if self.activeCardProperties.count <= displayCount {
//                    if index == 0 { continue }
//                } else {
//                    if index == self.activeCardProperties.count - 1 || index == 0 { continue }
//                }
//
//                /**********************************************************************
//                 4 3  2 1 0
//                 stableInfos    🀫 🀫 🀫 🀫 🀫
//
//                 5 4 3  2 1 0
//                 infos          🀫 🀫 🀫 🀫 🀫 🀫👈这个卡片新添加的
//                 ***********************************************************************/
//                // 需要先设置`transform`，再设置`frame`
//                let willInfo = self.initialCardProperties[index]
//                info.cell.transform = willInfo.transform
//
//                var frame = info.cell.frame
//                frame.origin.y = willInfo.frame.origin.y
//                info.cell.frame = frame
//
//                info.frame = willInfo.frame
//                info.transform = willInfo.transform
//            }
//        } completion: { isFinish in
//            // ...
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            guard let bottomCell = self.activeCardProperties.last?.cell else { return }
//            // 移除最底部的卡片
//            if self.activeCardProperties.count > displayCount {
//                self.addToReusePool(cell: bottomCell)
//                self.activeCardProperties.removeLast()
//            }
//        }
//    }
//
//    /// 获取重用`Cell`
//    public func dequeueReusableCell(withIdentifier identifier: String) -> DragCardCell? {
//        // 先在注册表里面查找
//        var canFind: Bool = false
//        var cellClass: DragCardCell.Type?
//        for (_, p) in registerTables.enumerated() {
//            if p.reuseIdentifier == identifier {
//                canFind = true
//                cellClass = p.cellClass
//                break
//            }
//        }
//        if !canFind || cellClass == nil {
//            return nil
//        }
//        // 在缓存池子里面查找
//        var reusableCell: DragCardCell?
//        for (_, cell) in reusableCells.enumerated() {
//            // 在缓存池子中，且未被使用
//            if cell.reuseIdentifier == identifier, cell.isReuse == false {
//                cell.isReuse = true // 标记为正在使用缓存池子中的Cell
//                reusableCell = cell
//                break
//            }
//        }
//        if reusableCell == nil {
//            // 如果在缓存池子中没有找到，那么新建
//            reusableCell = cellClass!.init(reuseIdentifier: identifier)
//            if reusableCell != nil {
//                reusableCell!.isReuse = true
//                reusableCells.append(reusableCell!)
//            }
//        }
//        for (_, cell) in reusableCells.enumerated() {
//            if !cell.isReuse {
//                cell.removeFromSuperview()
//            }
//        }
//        return reusableCell
//    }
//
//    /// 注册`Cell`
//    public func register<T: DragCardCell>(_ cellClass: T.Type, forCellReuseIdentifier identifier: String) {
//        let className = NSStringFromClass(cellClass)
//        var find: Bool = false
//        for (_, p) in registerTables.enumerated() {
//            if NSStringFromClass(p.cellClass) == className, p.reuseIdentifier == identifier {
//                find = true
//                break
//            }
//        }
//        if find { return }
//        let p = RegisterTable(reuseIdentifier: identifier, cellClass: cellClass)
//        registerTables.append(p)
//    }
}

extension DragCardContainer {
//    private func addPanGesture(for cell: DragCardCell) {
//        removePanGesture(for: cell)
//        if disableDrag { return }
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(panGesture:)))
//        cell.addGestureRecognizer(pan)
//        cell.panGesture = pan
//    }
//
//    private func addTapGesture(for cell: DragCardCell) {
//        removeTapGesture(for: cell)
//        if disableClick { return }
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer(tapGesture:)))
//        cell.addGestureRecognizer(tap)
//        cell.tapGesture = tap
//    }
//
//    private func removePanGesture(for cell: DragCardCell) {
//        guard let pan = cell.panGesture else { return }
//        cell.removeGestureRecognizer(pan)
//    }
//
//    private func removeTapGesture(for cell: DragCardCell) {
//        guard let tap = cell.tapGesture else { return }
//        cell.removeGestureRecognizer(tap)
//    }
}

extension DragCardContainer {
//    internal func addToReusePool(cell: DragCardCell) {
//        guard let identifier = cell.identifier else { return }
//        cell.isReuse = false
//
//        var isContain: Bool = false
//        for (_, c) in reusableCells.enumerated() {
//            if let _identifier = c.identifier, _identifier == identifier, c.reuseIdentifier == cell.reuseIdentifier {
//                isContain = true
//                break
//            }
//        }
//        cell.removeFromSuperview()
//        if isContain { return }
//        reusableCells.append(cell)
//    }
//
//    internal func removeFromReusePool(cell: DragCardCell) {
//        for (index, c) in reusableCells.enumerated() {
//            // 在缓存池子中，且未被使用
//            if let identifier = cell.identifier,
//               let _identifier = c.identifier,
//               cell.reuseIdentifier == c.reuseIdentifier,
//               identifier == _identifier {
//                reusableCells.remove(at: index)
//                break
//            }
//        }
//        cell.removeFromSuperview()
//    }
}

extension DragCardContainer {
//    internal func installNextCard() {
//        let numberOfCount = dataSource?.numberOfCount(self) ?? 0
//        if numberOfCount <= 0 { return }
//        let displayCount = min(numberOfCount, visibleCount)
//        if displayCount <= 0 { return }
//        
//        var cell: DragCardCell?
//        
//        if infiniteLoop {
//            if numberOfCount > displayCount {
//                if _currentIndex + displayCount >= numberOfCount {
//                    // 无剩余卡片可以滑动，把之前滑出去的，加在最下面
//                    cell = dataSource?.dragCard(self, indexOfCell: _currentIndex + displayCount - numberOfCount)
//                } else {
//                    // 还有剩余卡片可以滑动
//                    cell = dataSource?.dragCard(self, indexOfCell: _currentIndex + displayCount)
//                }
//            } else { // 最多只是`maxCount = showCount`，比如总数是3张，一次性显示3张
//                // 滑出去的那张，放在最下面
//                cell = dataSource?.dragCard(self, indexOfCell: _currentIndex)
//            }
//        } else {
//            if _currentIndex + displayCount >= numberOfCount { return } // 无剩余卡片可滑
//            cell = dataSource?.dragCard(self, indexOfCell: _currentIndex + displayCount)
//        }
//        
//        if cell == nil { return }
//        guard let bottomCell = activeCardProperties.last?.cell else { return }
//        
//        cell!.isUserInteractionEnabled = false
//        cell!.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
//        containerView.insertSubview(cell!, at: 0)
//        
//        cell!.transform = .identity
//        // 设置`transform`和`frame`的顺序不能颠倒
//        cell!.transform = bottomCell.transform
//        cell!.frame = bottomCell.frame
//        
//        let property = DragCardActiveProperty(cell: cell!)
//        property.frame = cell!.frame
//        property.transform = cell!.transform
//        activeCardProperties.append(property)
//        
//        if !disableDrag {
//            addPanGesture(for: cell!)
//        }
//        if !disableClick {
//            addTapGesture(for: cell!)
//        }
//    }
//    
//    internal func disappear(horizontalMoveDistance: CGFloat, verticalMoveDistance: CGFloat, movementDirection: DragCardContainer.MovementDirection) {
//        
//        if activeCardProperties.count <= 0 { return }
//        
//        let willRemoveTopCell = activeCardProperties.first!.cell // 临时存储将要移除出去的顶层卡片
//        activeCardProperties.removeFirst() // 从数组里面移除将要移除出去的顶层卡片
//        
//        let tempIndex = _currentIndex // 存储临时索引
//        
//        // 卡片滑出去的回调
//        self.delegate?.dragCard(self, didRemoveTopCell: willRemoveTopCell, withIndex: _currentIndex, movementDirection: movementDirection)
//        
//        if infiniteLoop {
//            if _currentIndex == (dataSource?.numberOfCount(self) ?? 0) - 1 {
//                // 最后一张卡片Remove
//                delegate?.dragCard(self, didFinishRemoveLastCell: willRemoveTopCell)
//                _currentIndex = 0 // 索引置为0
//            } else {
//                _currentIndex = _currentIndex + 1
//            }
//        } else {
//            if _currentIndex == (self.dataSource?.numberOfCount(self) ?? 0) - 1 {
//                // 最后一张卡片Remove
//                delegate?.dragCard(self, didFinishRemoveLastCell: willRemoveTopCell)
//            } else {
//                _currentIndex = _currentIndex + 1
//            }
//        }
//        if let currentTopCell = activeCardProperties.first?.cell {
//            currentTopCell.isUserInteractionEnabled = true
//            delegate?.dragCard(self, didDisplayTopCell: currentTopCell, withIndexAt: _currentIndex)
//        }
//        //
//        UIView.animate(withDuration: 0.1, animations: {
//            // 信息重置
//            for (index, info) in self.activeCardProperties.enumerated() {
//                if index >= self.initialCardProperties.count { continue }
//                // 需要先设置`transform`，再设置`frame`
//                let willInfo = self.initialCardProperties[index]
//                info.cell.transform = willInfo.transform
//                
//                var frame = info.cell.frame
//                frame.origin.y = willInfo.frame.origin.y
//                info.cell.frame = frame
//                
//                info.frame = willInfo.frame
//                info.transform = willInfo.transform
//            }
//        }) { (isFinish) in
//            // ...
//        }
//        
//        //
//        let direction1 = DragCardDirection(horizontalMovementDirection: horizontalMoveDistance > 0.0 ? .right : .left,
//                                           horizontalMovementRatio: horizontalMoveDistance > 0.0 ? 1.0 : -1.0,
//                                           verticalMovementDirection: verticalMoveDistance > 0 ? .down : .up,
//                                           verticalMovementRatio: verticalMoveDistance > 0.0 ? 1.0 : -1.0)
//        let direction2 = DragCardDirection(horizontalMovementDirection: .identity,
//                                           horizontalMovementRatio: .zero,
//                                           verticalMovementDirection: .identity,
//                                           verticalMovementRatio: .zero)
//        UIView.animate(withDuration: 0.25, animations: {
//            self.delegate?.dragCard(self, currentCell: willRemoveTopCell, withIndex: tempIndex, currentCardDirection: direction1, canRemove: false)
//        }) { (isFinish) in
//            if !isFinish { return }
//            UIView.animate(withDuration: 0.25) {
//                self.delegate?.dragCard(self, currentCell: willRemoveTopCell, withIndex: tempIndex, currentCardDirection: direction2, canRemove: true)
//            }
//        }
//        //
//        removeTopCell(topCell: willRemoveTopCell, horizontalMoveDistance: horizontalMoveDistance, verticalMoveDistance: verticalMoveDistance)
//    }
//    
//    internal func removeTopCell(topCell: DragCardCell, horizontalMoveDistance: CGFloat, verticalMoveDistance: CGFloat) {
//        // 顶层卡片的动画: `transform`设置
//        UIView.animate(withDuration: 0.2, animations: {
//            topCell.transform = CGAffineTransform(rotationAngle: horizontalMoveDistance > 0 ? self.fixCellRotationMaximumAngleAndConvertToRadius() : -self.fixCellRotationMaximumAngleAndConvertToRadius())
//        }, completion: nil)
//        
//        // 顶层卡片的动画: `center`设置
//        UIView.animate(withDuration: 0.5, animations: {
//            var tmpWidth: CGFloat = 0.0
//            var tmpHeight: CGFloat = 0.0
//            if self.removeDirection == .horizontal {
//                var flag: CGFloat = 0
//                if horizontalMoveDistance > 0 {
//                    flag = 1.5 // 右边滑出
//                } else {
//                    flag = -1 // 左边滑出
//                }
//                tmpWidth = UIScreen.main.bounds.size.width * CGFloat(flag)
//                tmpHeight = (verticalMoveDistance / horizontalMoveDistance * tmpWidth) + self.initialFirstCellCenter.y
//            } else {
//                var flag: CGFloat = 0
//                if verticalMoveDistance > 0 {
//                    flag = 1.5 // 向下滑出
//                } else {
//                    flag = -1 // 向上滑出
//                }
//                tmpHeight = UIScreen.main.bounds.size.height * CGFloat(flag)
//                tmpWidth = horizontalMoveDistance / verticalMoveDistance * tmpHeight + self.initialFirstCellCenter.x
//            }
//            topCell.center = CGPoint(x: tmpWidth, y: tmpHeight) // 中心点设置
//        }) { (isFinish) in
//            if !isFinish { return }
//            topCell.center = CGPoint(x: UIScreen.main.bounds.size.width * 5, y: UIScreen.main.bounds.size.height * 5) // 动画完成，把`topCell`的中心点设置在屏幕外面很远的地方，防止pop的时候，会看见cell
//            self.addToReusePool(cell: topCell)
//        }
//    }
}
