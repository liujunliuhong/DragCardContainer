//
//  YHDragCard.swift
//  FNDating
//
//  Created by apple on 2019/9/26.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit

// MARK: - 数据源
public protocol YHDragCardDataSource: NSObjectProtocol {
    
    /// 卡片总数
    /// - Parameter dragCard: 容器
    func numberOfCount(_ dragCard: YHDragCard) -> Int
    
    /// 每个索引对应的卡片
    /// - Parameter dragCard: 容器
    /// - Parameter indexOfCard: 索引
    func dragCard(_ dragCard: YHDragCard, indexOfCard index: Int) -> UIView
}

// MARK: - 代理
public protocol YHDragCardDelegate: NSObjectProtocol {
    
    /// 显示顶层卡片的回调
    /// - Parameter dragCard: 容器
    /// - Parameter card: 卡片
    /// - Parameter index: 索引
    func dragCard(_ dragCard: YHDragCard, didDisplayCard card: UIView, withIndexAt index: Int)
    
    /// 点击顶层卡片的回调
    /// - Parameter dragCard: 容器
    /// - Parameter index: 点击的顶层卡片的索引
    /// - Parameter card: 点击的定测卡片
    func dragCard(_ dragCard: YHDragCard, didSelectIndexAt index: Int, with card: UIView)
    
    /// 最后一个卡片滑完的回调(当`infiniteLoop`设置为`true`,也会走该回调)
    /// - Parameter dragCard: 容器
    /// - Parameter card: 最后一张卡片
    func dragCard(_ dragCard: YHDragCard, didFinishRemoveLastCard card: UIView)
    
    /// 顶层卡片滑出去的回调
    /// - Parameter dragCard: 容器
    /// - Parameter card: 滑出去的卡片
    /// - Parameter index: 滑出去的卡片的索引
    /// - Parameter removeDirection: 卡片移除方向
    /// 当最后一个卡片滑出去时，会和`didFinishRemoveLastCard`代理同时回调
    func dragCard(_ dragCard: YHDragCard, didRemoveCard card:UIView, withIndex index: Int, removeDirection: YHDragCardDirection.Direction)
    
    /// 当前卡片的滑动位置信息的回调
    /// - Parameter dragCard: 容器
    /// - Parameter card: 顶层滑动的卡片
    /// - Parameter index: 卡片索引
    /// - Parameter direction: 卡片方向信息
    /// - Parameter canRemove: 卡片所处的位置是否可以移除
    /// 该代理可以用来干什么:
    /// 1.实现在滑动过程中，控制容器外部某个控件的形变、颜色、透明度等等
    /// 2、实现在滑动过程中，控制卡片内部某个按钮的形变、颜色、透明度等等(比如：右滑，like按钮逐渐显示；左滑，unlike按钮逐渐显示)
    func dragCard(_ dragCard: YHDragCard, currentCard card: UIView, withIndex index: Int, currentCardDirection direction: YHDragCardDirection, canRemove: Bool)
}

public extension YHDragCardDelegate {
    func dragCard(_ dragCard: YHDragCard, didDisplayCard card: UIView, withIndexAt index: Int) {}
    func dragCard(_ dragCard: YHDragCard, didSelectIndexAt index: Int, with card: UIView) {}
    func dragCard(_ dragCard: YHDragCard, didFinishRemoveLastCard card: UIView) {}
    func dragCard(_ dragCard: YHDragCard, didRemoveCard card:UIView, withIndex index: Int, removeDirection: YHDragCardDirection.Direction) {}
    func dragCard(_ dragCard: YHDragCard, currentCard card: UIView, withIndex index: Int, currentCardDirection direction: YHDragCardDirection, canRemove: Bool) {}
}




// MARK: - 卡片的滑动信息
public struct YHDragCardDirection {
    /// 卡片方向
    public enum Direction {
        case `default`   // default
        case left        // 向左
        case right       // 向右
        case up          // 向上
        case down        // 向下
    }
    
    public var horizontal: YHDragCardDirection.Direction = .default
    public var vertical: YHDragCardDirection.Direction = .default
    public var horizontalRatio: CGFloat = 0.0
    public var verticalRatio: CGFloat = 0.0
}






// MARK: - 存储卡片的位置信息
public class YHDragCardStableInfo: NSObject {
    public var transform: CGAffineTransform
    public var frame: CGRect
    init(transform: CGAffineTransform, frame: CGRect) {
        self.transform = transform
        self.frame = frame
        super.init()
    }
}

public class YHDragCardInfo: YHDragCardStableInfo {
    public let card: UIView
    init(card: UIView, transform: CGAffineTransform, frame: CGRect) {
        self.card = card
        super.init(transform: transform, frame: frame)
    }
}

public extension YHDragCardInfo {
    override var description: String {
        return getInfo()
    }
    
    override var debugDescription: String {
        return getInfo()
    }
    
    func getInfo() -> String {
        return "[Card] \(card)\n[Transform] \(transform)\n[Frame] \(frame)"
    }
}



// MARK: - 方向
public enum YHDragCardRemoveDirection {
    case horizontal
    case vertical
}




// MARK: - runtime动态添加属性
fileprivate extension UIView {
    struct AssociatedKeys {
        static var panGestureKey = "com.yinhe.yhdragcard.panGestureKey"
        static var tapGestureKey = "com.yinhe.yhdragcard.tapGestureKey"
    }
    var yh_drag_card_panGesture: UIPanGestureRecognizer? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.panGestureKey) as? UIPanGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.panGestureKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var yh_drag_card_tapGesture: UITapGestureRecognizer? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tapGestureKey) as? UITapGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tapGestureKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}



/// Swift版本卡牌滑动库
/// 对比Swift和OC版本，个人还是更喜欢Swift，语法简洁
/// 框架难点:如何在滑动的过程中动态的控制下面几张卡片的位置形变(很多其他三方库都未实现该功能)
// MARK: - YHDragCard
public class YHDragCard: UIView {
    deinit {
        //print("YHDragCard deinit")
    }
    
    /// 数据源
    public weak var dataSource: YHDragCardDataSource?
    
    /// 协议
    public weak var delegate: YHDragCardDelegate?
    
    /// 可见卡片数量，默认3
    /// 取值范围:大于0
    /// 内部会根据`visibleCount`和`numberOfCount(_ dragCard: YHDragCard)`来纠正初始显示的卡片数量
    public var visibleCount: Int = 3
    
    /// 卡片之间的间隙，默认10.0
    /// 如果小于0.0，默认0.0
    /// 如果大于容器高度的一半，默认为容器高度一半
    public var cardSpacing: CGFloat = 10.0
    
    /// 最底部那张卡片的缩放比例，默认0.8
    /// 其余卡片的缩放比例会进行自动计算
    /// 取值范围:0.1 - 1.0
    /// 如果小于0.1，默认0.1
    /// 如果大于1.0，默认1.0
    public var minScale: CGFloat = 0.8
    
    /// 移除方向(一般情况下是水平方向移除的，但是有些设计是垂直方向移除的)
    /// 默认水平方向
    public var removeDirection: YHDragCardRemoveDirection = .horizontal
    
    /// 水平方向上最大移除距离，默认屏幕宽度1/4
    /// 取值范围:大于10.0
    /// 如果小于10.0，默认10.0
    /// 如果水平方向上能够移除卡片，请设置该属性的值
    public var horizontalRemoveDistance: CGFloat = UIScreen.main.bounds.size.width / 4.0
    
    /// 水平方向上最大移除速度，默认1000.0
    /// 取值范围:大于100.0。如果小于100.0，默认100.0
    /// 如果水平方向上能够移除卡片，请设置该属性的值
    public var horizontalRemoveVelocity: CGFloat = 1000.0
    
    /// 垂直方向上最大移除距离，默认屏幕高度1/4
    /// 取值范围:大于50.0
    /// 如果小于50.0，默认50.0
    /// 如果垂直方向上能够移除卡片，请设置该属性的值
    public var verticalRemoveDistance: CGFloat = UIScreen.main.bounds.size.height / 4.0
    
    /// 垂直方向上最大移除速度，默认500.0
    /// 取值范围:大于100.0。如果小于100.0，默认100.0
    /// 如果垂直方向上能够移除卡片，请设置该属性的值
    public var verticalRemoveVelocity: CGFloat = 500.0
    
    /// 侧滑角度，默认10.0度(最大会旋转10.0度)
    /// 取值范围:0.0 - 90.0
    /// 如果小于0.0，默认0.0
    /// 如果大于90.0，默认90.0
    /// 当`removeDirection`设置为`vertical`时，会忽略该属性
    /// 在滑动过程中会根据`horizontalRemoveDistance`和`removeMaxAngle`来动态计算卡片的旋转角度
    /// 目前我还没有遇到过在垂直方向上能移除卡片的App，因此如果上下滑动，卡片的旋转效果很小，只有在水平方向上滑动，才能观察到很明显的旋转效果
    /// 因为我也不知道当垂直方向上滑动时，怎么设置卡片的旋转效果🤣
    public var removeMaxAngle: CGFloat = 10.0
    
    /// 卡片滑动方向和纵轴之间的角度，默认5.0
    /// 取值范围:5.0 - 85.0
    /// 如果小于5.0，默认5.0
    /// 如果大于85.0，默认85.0
    /// 如果水平方向滑动能移除卡片，请把该值设置的尽量小
    /// 如果垂直方向能够移除卡片，请把该值设置的大点
    public var demarcationAngle: CGFloat = 5.0
    
    /// 是否无限滑动
    public var infiniteLoop: Bool = false
    
    /// 是否禁用拖动
    public var disableDrag: Bool = false {
        didSet {
            for (_, info) in self.infos.enumerated() {
                if disableDrag {
                    removePanGesture(for: info.card)
                } else {
                    addPanGesture(for: info.card)
                }
            }
        }
    }
    
    /// 是否禁用卡片的点击事件
    public var disableClick: Bool = false {
        didSet {
            for (_, info) in self.infos.enumerated() {
                if disableClick {
                    removeTapGesture(for: info.card)
                } else {
                    addTapGesture(for: info.card)
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    /// 当前索引
    /// 顶层卡片的索引(直接与用户发生交互)
    private var currentIndex: Int = 0
    
    /// 初始化顶层卡片的位置
    private var initialFirstCardCenter: CGPoint = .zero
    
    /// 存储的卡片信息
    private var infos: [YHDragCardInfo] = [YHDragCardInfo]()
    
    /// 存储卡片位置信息(一直存在的)
    private var stableInfos: [YHDragCardStableInfo] = [YHDragCardStableInfo]()
    
    /// 是否正在撤销
    /// 避免在短时间内多次调用revoke方法，必须等上一张卡片revoke完成，才能revoke下一张卡片
    private var isRevoking: Bool = false
    
    /// 是否正在调用`nextCard`方法
    /// 避免在短时间内多次调用nextCard方法，必须`nextCard`完成，才能继续下一次`nextCard`
    private var isNexting: Bool = false
    
    /// 目前暂时只支持纯frame的方式初始化
    /// - Parameter frame: frame
    override public init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = .gray
    }
    
    
    @available(iOS, unavailable)
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func didMoveToSuperview() {
        reloadData(animation: false)
    }
}

public extension YHDragCard {
    
    /// 刷新整个卡片，回到初始状态
    /// - Parameter animation: 是否动画
    func reloadData(animation: Bool) {
        _reloadData(animation: animation)
    }
    
    /// 显示下一张卡片(与removeDirection相关联)
    /// - Parameter direction: 方向
    /// right  向右移除顶层卡片
    /// left   向左移除顶层卡片
    /// up     向上移除顶层卡片
    /// down   向下移除顶层卡片
    func nextCard(direction: YHDragCardDirection.Direction) {
        _nextCard(direction: direction)
    }
    
    /// 撤销(与`removeDirection`相关联)，当`infiniteLoop`为`true`时，只能撤销当前循环的卡片
    /// - Parameter direction: 从哪个方向撤销
    /// right  从右撤销卡片
    /// left   从左撤销卡片
    /// up     从上撤销卡片
    /// down   从下撤销卡片
    func revoke(direction: YHDragCardDirection.Direction) {
        _revoke(direction: direction)
    }
}


private extension YHDragCard {
    private func _reloadData(animation: Bool) {
        self.infos.forEach { (transform) in
            transform.card.removeFromSuperview()
        }
        self.infos.removeAll()
        self.stableInfos.removeAll()
        self.currentIndex = 0
        
        // 纠正
        let maxCount: Int = self.dataSource?.numberOfCount(self) ?? 0
        let showCount: Int = min(maxCount, self.visibleCount)
        
        if showCount <= 0 { return }
        
        var scale: CGFloat = 1.0
        if showCount > 1 {
            scale = CGFloat(1.0 - self.correctScale()) / CGFloat(showCount - 1)
        }
        
        let cardWidth = self.bounds.size.width
        let cardHeight: CGFloat = self.bounds.size.height - CGFloat(showCount - 1) * self.correctCardSpacing()
        
        assert(cardHeight > 0, "请检查`cardSpacing`的取值")
        
        for index in 0..<showCount {
            let y = self.correctCardSpacing() * CGFloat(index)
            let frame = CGRect(x: 0, y: y, width: cardWidth, height: cardHeight)
            
            let tmpScale: CGFloat = 1.0 - (scale * CGFloat(index))
            let transform = CGAffineTransform(scaleX: tmpScale, y: tmpScale)
            
            if let card = self.dataSource?.dragCard(self, indexOfCard: index) {
                card.isUserInteractionEnabled = false
                card.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
                insertSubview(card, at: 0) //
                
                card.transform = .identity
                card.frame = frame
                
                if animation {
                    UIView.animate(withDuration: 0.25, animations: {
                        card.transform = transform
                    }, completion: nil)
                } else {
                    card.transform = transform
                }
                
                let info = YHDragCardInfo(card: card, transform: card.transform, frame: card.frame)
                self.infos.append(info)
                
                let stableInfo = YHDragCardStableInfo(transform: card.transform, frame: card.frame)
                self.stableInfos.append(stableInfo)
                
                if !disableDrag {
                    self.addPanGesture(for: card)
                }
                if !disableClick {
                    self.addTapGesture(for: card)
                }
                
                if index == 0 {
                    self.initialFirstCardCenter = card.center
                }
            } else {
                fatalError("card不能为空")
            }
        }
        self.infos.first?.card.isUserInteractionEnabled = true
        
        // 显示顶层卡片的回调
        if let topCard = self.infos.first?.card {
            self.delegate?.dragCard(self, didDisplayCard: topCard, withIndexAt: self.currentIndex)
        }
    }
    
    private func _nextCard(direction: YHDragCardDirection.Direction) {
        if self.isNexting { return }
        switch direction {
        case .right:
            self.horizontalNextCard(isRight: true)
        case .left:
            self.horizontalNextCard(isRight: false)
        case .up:
            self.verticalNextCard(isUp: true)
        case .down:
            self.verticalNextCard(isUp: false)
        default:
            break
        }
    }
    
    private func _revoke(direction: YHDragCardDirection.Direction) {
        if self.currentIndex <= 0 { return }
        if direction == .default { return }
        if self.isRevoking { return }
        if self.removeDirection == .horizontal {
            if direction == .up || direction == .down { return }
        }
        if self.removeDirection == .vertical {
            if direction == .left || direction == .right { return }
        }
        guard let topCard = self.infos.first?.card else { return } // 顶层卡片
        
        guard let card = self.dataSource?.dragCard(self, indexOfCard: self.currentIndex - 1) else { return } // 获取上一个卡片
        
        card.isUserInteractionEnabled = false
        card.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        addSubview(card)
        
        if !self.disableDrag {
            self.addPanGesture(for: card)
        }
        if !self.disableClick {
            self.addTapGesture(for: card)
        }
        
        card.transform = .identity
        card.frame = topCard.frame
        
        if self.removeDirection == .horizontal {
            var flag: CGFloat = 1.0
            if direction == .left {
                flag = -1.0
            } else if direction == .right {
                flag = 1.0
            }
            card.transform = CGAffineTransform(rotationAngle: self.correctRemoveMaxAngleAndToRadius() * flag)
        } else {
            // 垂直方向不做处理
            card.transform = .identity
        }
        
        if self.removeDirection == .horizontal {
            var flag: CGFloat = 2.0
            if direction == .left {
                flag = -0.5
            } else if direction == .right {
                flag = 1.5
            }
            let tmpWidth = UIScreen.main.bounds.size.width * flag
            let tmpHeight = self.initialFirstCardCenter.y - 20.0
            card.center = CGPoint(x: tmpWidth, y: tmpHeight)
        } else {
            var flag: CGFloat = 2.0
            if direction == .up {
                flag = -1.0
            } else if direction == .down {
                flag = 2.0
            }
            let tmpWidth = self.initialFirstCardCenter.x
            let tmpHeight = UIScreen.main.bounds.size.height * flag
            card.center = CGPoint(x: tmpWidth, y: tmpHeight)
        }
        
        self.infos.first?.card.isUserInteractionEnabled = false
        
        let info = YHDragCardInfo(card: card, transform: topCard.transform, frame: topCard.frame)
        self.infos.insert(info, at: 0)
        
        self.isRevoking = true
        
        do {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let self = self else { return }
                card.center = self.initialFirstCardCenter
            }, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // 延迟0.1秒
                UIView.animate(withDuration: 0.2, animations: { // 花费0.2秒使`transform`变为`identity`
                    card.transform = .identity
                }, completion: nil)
            }
        }
        
        do {
            UIView.animate(withDuration: 0.08, animations: { [weak self] in
                guard let self = self else { return }
                for (index, info) in self.infos.enumerated() {
                    if self.infos.count <= self.visibleCount {
                        if index == 0 { continue }
                    } else {
                        if index == self.infos.count - 1 || index == 0 { continue }
                    }
                    
                    /**********************************************************************
                                    4 3  2 1 0
                     stableInfos    🀫 🀫 🀫 🀫 🀫
                     
                                    5 4 3  2 1 0
                     infos          🀫 🀫 🀫 🀫 🀫 🀫👈这个卡片新添加的
                     ***********************************************************************/
                    let willInfo = self.stableInfos[index]
                    
                    info.card.transform = willInfo.transform
                    
                    var frame = info.card.frame
                    frame.origin.y = willInfo.frame.origin.y
                    info.card.frame = frame
                }
            }) { [weak self] (isFinish) in
                guard let self = self else { return }
                
                for (index, info) in self.infos.enumerated() {
                    if self.infos.count <= self.visibleCount {
                        if index == 0 { continue }
                    } else {
                        if index == self.infos.count - 1 || index == 0 { continue }
                    }
                    let willInfo = self.stableInfos[index]
                    
                    let willTransform = willInfo.transform
                    let willFrame = willInfo.frame
                    
                    info.transform = willTransform
                    info.frame = willFrame
                }
                
                guard let bottomCard = self.infos.last?.card else { return }
                
                // 移除最底部的卡片
                if self.infos.count > self.visibleCount {
                    bottomCard.removeFromSuperview()
                    self.infos.removeLast()
                }
                
                self.currentIndex = self.currentIndex - 1
                card.isUserInteractionEnabled = true
                
                self.isRevoking = false
                
                // 显示顶层卡片的回调
                self.delegate?.dragCard(self, didDisplayCard: card, withIndexAt: self.currentIndex)
            }
        }
    }
}


private extension YHDragCard {
    
    /// 把下一张卡片添加到`container`的最底部
    private func installNextCard() {
        let maxCount: Int = self.dataSource?.numberOfCount(self) ?? 0
        let showCount: Int = min(maxCount, self.visibleCount)
        if showCount <= 0 { return }
        
        var card: UIView?
        
        
        // 判断
        if !self.infiniteLoop {
            if self.currentIndex + showCount >= maxCount { return } // 无剩余卡片可滑,return
            card = self.dataSource?.dragCard(self, indexOfCard: self.currentIndex + showCount)
        } else {
            if maxCount > showCount {
                // 无剩余卡片可以滑动，把之前滑出去的，加在最下面
                if self.currentIndex + showCount >= maxCount {
                    card = self.dataSource?.dragCard(self, indexOfCard: self.currentIndex + showCount - maxCount)
                } else {
                    // 还有剩余卡片可以滑动
                    card = self.dataSource?.dragCard(self, indexOfCard: self.currentIndex + showCount)
                }
            } else { // 最多只是`maxCount = showCount`，比如总数是3张，一次性显示3张
                // 滑出去的那张，放在最下面
                card = self.dataSource?.dragCard(self, indexOfCard: self.currentIndex)
            }
        }
        
        
        guard let _card = card else { return }
        guard let bottomCard = self.infos.last?.card else { return }
        
        _card.isUserInteractionEnabled = false
        _card.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        insertSubview(_card, at: 0)
        
        _card.transform = .identity
        _card.transform = bottomCard.transform
        _card.frame = bottomCard.frame
        
        let info = YHDragCardInfo(card: _card, transform: _card.transform, frame: _card.frame)
        self.infos.append(info) // append
        
        if !self.disableDrag {
            self.addPanGesture(for: _card)
        }
        if !self.disableClick {
            self.addTapGesture(for: _card)
        }
    }
    
    
    /// 给卡片添加pan手势
    /// - Parameter card: 卡片
    private func addPanGesture(for card: UIView) {
        self.removePanGesture(for: card)
        if self.disableDrag { return }
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(panGesture:)))
        card.addGestureRecognizer(pan)
        card.yh_drag_card_panGesture = pan
    }
    
    private func addTapGesture(for card: UIView) {
        self.removeTapGesture(for: card)
        if self.disableClick { return }
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer(tapGesture:)))
        card.addGestureRecognizer(tap)
        card.yh_drag_card_tapGesture = tap
    }
    
    private func removePanGesture(for card: UIView) {
        if let pan = card.yh_drag_card_panGesture {
            card.removeGestureRecognizer(pan)
        }
    }
    
    private func removeTapGesture(for card: UIView) {
        if let tap = card.yh_drag_card_tapGesture {
            card.removeGestureRecognizer(tap)
        }
    }
    
    private func horizontalNextCard(isRight: Bool) {
        if self.removeDirection == .vertical { return }
        self.installNextCard()
        let width: CGFloat = 150.0
        self.isNexting = true
        self.autoDisappear(horizontalMoveDistance: (isRight ? width : -width), verticalMoveDistance: -10, removeDirection: isRight ? .right : .left)
    }
    
    private func verticalNextCard(isUp: Bool) {
        if removeDirection == .horizontal { return }
        self.installNextCard()
        self.isNexting = true
        self.autoDisappear(horizontalMoveDistance: 0.0, verticalMoveDistance: (isUp ? -30.0 : 30.0), removeDirection: isUp ? .up : .down)
    }
}


private extension YHDragCard {
    /// 纠正minScale   [0.1, 1.0]
    private func correctScale() -> CGFloat {
        var scale = self.minScale
        if scale > 1.0 { scale = 1.0 }
        if scale <= 0.1 { scale = 0.1 }
        return scale
    }
    
    /// 纠正cardSpacing  [0.0, bounds.size.height / 2.0]
    private func correctCardSpacing() -> CGFloat {
        var spacing: CGFloat = self.cardSpacing
        if self.cardSpacing.isLess(than: .zero) {
            spacing = .zero
        } else if self.cardSpacing > bounds.size.height / 2.0 {
            spacing = bounds.size.height / 2.0
        }
        return spacing
    }
    
    /// 纠正侧滑角度，并把侧滑角度转换为弧度  [0.0, 90.0]
    private func correctRemoveMaxAngleAndToRadius() -> CGFloat {
        var angle: CGFloat = self.removeMaxAngle
        if angle.isLess(than: .zero) {
            angle = .zero
        } else if angle > 90.0 {
            angle = 90.0
        }
        return angle / 180.0 * CGFloat(Double.pi)
    }
    
    /// 纠正水平方向上的最大移除距离，内部做了判断 [10.0, ∞)
    private func correctHorizontalRemoveDistance() -> CGFloat {
        return self.horizontalRemoveDistance < 10.0 ? 10.0 : self.horizontalRemoveDistance
    }
    
    /// 纠正水平方向上的最大移除速度  [100.0, ∞)
    private func correctHorizontalRemoveVelocity() -> CGFloat {
        return self.horizontalRemoveVelocity < 100.0 ? 100.0 : self.horizontalRemoveVelocity
    }
    
    /// 纠正垂直方向上的最大移距离  [50.0, ∞)
    private func correctVerticalRemoveDistance() -> CGFloat {
        return self.verticalRemoveDistance < 50.0 ? 50.0 : self.verticalRemoveDistance
    }
    
    /// 纠正垂直方向上的最大移除速度  [100.0, ∞)
    private func correctVerticalRemoveVelocity() -> CGFloat {
        return self.verticalRemoveVelocity < 100.0 ? 100.0 : self.verticalRemoveVelocity
    }
    
    /// 纠正卡片滑动方向和纵轴之间的角度，并且转换为弧度   [5.0, 85.0]
    private func correctDemarcationAngle() -> CGFloat {
        var angle = self.demarcationAngle
        if self.demarcationAngle < 5.0 {
            angle = 5.0
        } else if self.demarcationAngle > 85.0 {
            angle = 85.0
        }
        return angle / 180.0 * CGFloat(Double.pi)
    }
}


private extension YHDragCard {
    
    /// tap手势
    /// - Parameter tapGesture: gesture
    @objc private func tapGestureRecognizer(tapGesture: UITapGestureRecognizer) {
        guard let card = self.infos.first?.card else { return }
        self.delegate?.dragCard(self, didSelectIndexAt: self.currentIndex, with: card)
    }
    
    
    /// pan手势
    /// - Parameter panGesture: gesture
    @objc private func panGestureRecognizer(panGesture: UIPanGestureRecognizer) {
        guard let cardView = panGesture.view else { return }
        let movePoint = panGesture.translation(in: self)
        let velocity = panGesture.velocity(in: self)
        
        switch panGesture.state {
        case .began:
            //print("begin")
            // 把下一张卡片添加到最底部
            self.installNextCard() // 显示下一张卡片
        case .changed:
            //print("changed")
            let currentPoint = CGPoint(x: cardView.center.x + movePoint.x, y: cardView.center.y + movePoint.y)
            // 设置手指拖住的那张卡牌的位置
            cardView.center = currentPoint
            
            // 垂直方向上的滑动比例
            let verticalMoveDistance: CGFloat = cardView.center.y - self.initialFirstCardCenter.y
            var verticalRatio = verticalMoveDistance / self.correctVerticalRemoveDistance()
            if verticalRatio < -1.0 {
                verticalRatio = -1.0
            } else if verticalRatio > 1.0 {
                verticalRatio = 1.0
            }
            
            // 水平方向上的滑动比例
            let horizontalMoveDistance: CGFloat = cardView.center.x - self.initialFirstCardCenter.x
            var horizontalRatio = horizontalMoveDistance / self.correctHorizontalRemoveDistance()
            
            if horizontalRatio < -1.0 {
                horizontalRatio = -1.0
            } else if horizontalRatio > 1.0 {
                horizontalRatio = 1.0
            }
            
            // 设置手指拖住的那张卡牌的旋转角度
            let rotationAngle = horizontalRatio * self.correctRemoveMaxAngleAndToRadius()
            cardView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            // 复位
            panGesture.setTranslation(.zero, in: self)
            
            if self.removeDirection == .horizontal {
                // 卡牌变化
                self.moving(ratio: abs(horizontalRatio))
            } else {
                // 卡牌变化
                self.moving(ratio: abs(verticalRatio))
            }
            
            // 滑动过程中的方向设置
            var horizontal: YHDragCardDirection.Direction = .default
            var vertical: YHDragCardDirection.Direction = .default
            if horizontalRatio > 0.0 {
                horizontal = .right
            } else if horizontalRatio < 0.0 {
                horizontal = .left
            }
            if verticalRatio > 0.0 {
                vertical = .down
            } else if verticalRatio < 0.0 {
                vertical = .up
            }
            // 滑动过程中的回调
            let direction = YHDragCardDirection(horizontal: horizontal, vertical: vertical, horizontalRatio: horizontalRatio, verticalRatio: verticalRatio)
            self.delegate?.dragCard(self, currentCard: cardView, withIndex: self.currentIndex, currentCardDirection: direction, canRemove: false)
            
        case .ended:
            //print("ended")
            let horizontalMoveDistance: CGFloat = cardView.center.x - self.initialFirstCardCenter.x
            let verticalMoveDistance: CGFloat = cardView.center.y - self.initialFirstCardCenter.y
            if self.removeDirection == .horizontal {
                if (abs(horizontalMoveDistance) > self.horizontalRemoveDistance || abs(velocity.x) > self.horizontalRemoveVelocity) &&
                    abs(verticalMoveDistance) > 0.1 && // 避免分母为0
                    abs(horizontalMoveDistance) / abs(verticalMoveDistance) >= tan(self.correctDemarcationAngle()){
                    // 消失
                    self.disappear(horizontalMoveDistance: horizontalMoveDistance, verticalMoveDistance: verticalMoveDistance, removeDirection: horizontalMoveDistance.isLess(than: .zero) ? .left : .right)
                } else {
                    // 复位
                    self.restore()
                }
            } else {
                if (abs(verticalMoveDistance) > self.self.verticalRemoveDistance || abs(velocity.y) > self.verticalRemoveVelocity) &&
                    abs(verticalMoveDistance) > 0.1 && // 避免分母为0
                    abs(horizontalMoveDistance) / abs(verticalMoveDistance) <= tan(self.correctDemarcationAngle()) {
                    // 消失
                    self.disappear(horizontalMoveDistance: horizontalMoveDistance, verticalMoveDistance: verticalMoveDistance, removeDirection: verticalMoveDistance.isLess(than: .zero) ? .up : .down)
                } else {
                    // 复位
                    self.restore()
                }
            }
        case .cancelled, .failed:
            //print("cancelled or failed")
            self.restore()
        default:
            break
        }
    }
}


private extension YHDragCard {
    private func moving(ratio: CGFloat) {
        // 1、infos数量小于等于visibleCount
        // 2、infos数量大于visibleCount（infos数量最多只比visibleCount多1）
        var ratio = ratio
        if ratio.isLess(than: .zero) {
            ratio = 0.0
        } else if ratio > 1.0 {
            ratio = 1.0
        }
        
        // index = 0 是最顶部的卡片
        // index = info.count - 1 是最下面的卡片
        for (index, info) in self.infos.enumerated() {
            if self.infos.count <= self.visibleCount {
                if index == 0 { continue }
            } else {
                if index == self.infos.count - 1 || index == 0 { continue }
            }
            let willInfo = self.infos[index - 1]
            
            let currentTransform = info.transform
            let currentFrame = info.frame
            
            let willTransform = willInfo.transform
            let willFrame = willInfo.frame
            
            info.card.transform = CGAffineTransform(scaleX:currentTransform.a - (currentTransform.a - willTransform.a) * ratio,
                                                    y: currentTransform.d - (currentTransform.d - willTransform.d) * ratio)
            var frame = info.card.frame
            frame.origin.y = currentFrame.origin.y - (currentFrame.origin.y - willFrame.origin.y) * ratio;
            info.card.frame = frame
        }
    }
    
    /// 自动消失
    /// - Parameters:
    ///   - horizontalMoveDistance: 水平移动距离
    ///   - verticalMoveDistance:  垂直移动距离
    private func autoDisappear(horizontalMoveDistance: CGFloat, verticalMoveDistance: CGFloat, removeDirection: YHDragCardDirection.Direction) {
        if self.infos.count <= 0 {
            return
        }
        
        let topCard = self.infos.first! // 临时存储顶层卡片
        self.infos.removeFirst() // 移除顶层卡片
        
        // 顶层卡片下面的那些卡片的动画
        UIView.animate(withDuration: 0.08, animations: { [weak self] in
            guard let self = self else { return }
            // 信息重置
            for (index, info) in self.infos.enumerated() {
                let willInfo = self.stableInfos[index]
                
                info.card.transform = willInfo.transform
                
                var frame = info.card.frame
                frame.origin.y = willInfo.frame.origin.y
                info.card.frame = frame
                
                info.frame = willInfo.frame
                info.transform = willInfo.transform
            }
            
        }) { [weak self] (isFinish) in
            guard let self = self else { return }
            if !isFinish { return }
            
            self.isNexting = false
            
            // 卡片滑出去的回调
            self.delegate?.dragCard(self, didRemoveCard: topCard.card, withIndex: self.currentIndex, removeDirection: removeDirection)
            
            
            // 顶部的卡片Remove
            if self.currentIndex == (self.dataSource?.numberOfCount(self) ?? 0) - 1 {
                // 卡片只有最后一张了，此时闭包不回调出去
                // 最后一张卡片移除出去的回调
                self.delegate?.dragCard(self, didFinishRemoveLastCard: topCard.card)
                
                if self.infiniteLoop {
                    if let tmpTopCard = self.infos.first?.card {
                        self.currentIndex = 0 // 如果最后一个卡片滑出去了，且可以无限滑动，那么把索引置为0
                        tmpTopCard.isUserInteractionEnabled = true // 使顶层卡片可以响应事件
                        self.delegate?.dragCard(self, didDisplayCard: tmpTopCard, withIndexAt: self.currentIndex)
                    }
                }
                
            } else {
                // 如果不是最后一张卡片移出去，则把索引+1
                self.currentIndex = self.currentIndex + 1
                self.infos.first?.card.isUserInteractionEnabled = true
                
                // 显示当前卡片的回调
                if let tmpTopCard = self.infos.first?.card {
                    self.delegate?.dragCard(self, didDisplayCard: tmpTopCard, withIndexAt: self.currentIndex)
                }
            }
        }
        
        
        // 自动消失时，这儿加上个动画，这样外部就自带动画了
        do {
            let currentIndex = self.currentIndex
            let direction1 = YHDragCardDirection(horizontal: horizontalMoveDistance > 0.0 ? .right : .left, vertical: verticalMoveDistance > 0 ? .down : .up, horizontalRatio: horizontalMoveDistance > 0.0 ? 1.0 : -1.0, verticalRatio: verticalMoveDistance > 0.0 ? 1.0 : -1.0)
            
            let direction2 = YHDragCardDirection(horizontal: .default, vertical: .default, horizontalRatio: 0.0, verticalRatio: 0.0)
            
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                guard let self = self else { return }
                self.delegate?.dragCard(self, currentCard: topCard.card, withIndex: currentIndex, currentCardDirection: direction1, canRemove: false)
            }) { (isFinish) in
                if !isFinish { return }
                UIView.animate(withDuration: 0.25) { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.dragCard(self, currentCard: topCard.card, withIndex: currentIndex, currentCardDirection: direction2, canRemove: true)
                }
            }
        }
        
        
        do {
            // 顶层卡片的动画: 自动消失时，设置个旋转角度
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let self = self else { return }
                topCard.card.transform = CGAffineTransform(rotationAngle: horizontalMoveDistance > 0 ? self.correctRemoveMaxAngleAndToRadius() : -self.correctRemoveMaxAngleAndToRadius())
                }, completion: nil)
            
            // 顶层卡片的动画: center设置
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                guard let self = self else { return }
                if self.removeDirection == .horizontal {
                    var flag: CGFloat = 0
                    if horizontalMoveDistance > 0 {
                        flag = 1.5 // 右边滑出
                    } else {
                        flag = -1 // 左边滑出
                    }
                    let tmpWidth = UIScreen.main.bounds.size.width * CGFloat(flag)
                    let tmpHeight = (verticalMoveDistance / horizontalMoveDistance * tmpWidth) + self.initialFirstCardCenter.y
                    topCard.card.center = CGPoint(x: tmpWidth, y: tmpHeight) // 中心点设置
                } else {
                    var flag: CGFloat = 0
                    if verticalMoveDistance > 0 {
                        flag = 1.5 // 向下滑出
                    } else {
                        flag = -1 // 向上滑出
                    }
                    let tmpHeight = UIScreen.main.bounds.size.height * CGFloat(flag)
                    let tmpWidth = horizontalMoveDistance / verticalMoveDistance * tmpHeight + self.initialFirstCardCenter.x
                    topCard.card.center = CGPoint(x: tmpWidth, y: tmpHeight) // 中心点设置
                }
            }) { (isFinish) in
                if !isFinish { return }
                topCard.card.removeFromSuperview()
            }
        }
    }
    
    /// 顶层卡片消失
    /// - Parameter horizontalMoveDistance: 水平移动距离(相对于initialFirstCardCenter)
    /// - Parameter verticalMoveDistance: 垂直移动距离(相对于initialFirstCardCenter)
    private func disappear(horizontalMoveDistance: CGFloat, verticalMoveDistance: CGFloat, removeDirection: YHDragCardDirection.Direction) {
        
        if self.infos.count <= 0 {
            return
        }
        
        let topCard = self.infos.first! // 临时存储顶层卡片
        self.infos.removeFirst() // 移除顶层卡片
        
        
        UIView.animate(withDuration: 0.08, animations: { [weak self] in
            guard let self = self else { return }
            // 信息重置
            for (index, info) in self.infos.enumerated() {
                let willInfo = self.stableInfos[index]
                
                info.card.transform = willInfo.transform
                
                var frame = info.card.frame
                frame.origin.y = willInfo.frame.origin.y
                info.card.frame = frame
                
                info.frame = willInfo.frame
                info.transform = willInfo.transform
            }
            
            // 这儿加上动画的原因是：回调给外部的时候就自带动画了
            let direction = YHDragCardDirection(horizontal: .default, vertical: .default, horizontalRatio: 0.0, verticalRatio: 0.0)
            self.delegate?.dragCard(self, currentCard: topCard.card, withIndex: self.currentIndex, currentCardDirection: direction, canRemove: true)
            
        }) { [weak self] (isFinish) in
            guard let self = self else { return }
            if !isFinish { return }
            
            
            
            self.isNexting = false
            
            // 卡片滑出去的回调
            self.delegate?.dragCard(self, didRemoveCard: topCard.card, withIndex: self.currentIndex, removeDirection: removeDirection)
            
            
            // 顶部的卡片Remove
            if self.currentIndex == (self.dataSource?.numberOfCount(self) ?? 0) - 1 {
                // 卡片只有最后一张了，此时闭包不回调出去
                // 最后一张卡片移除出去的回调
                self.delegate?.dragCard(self, didFinishRemoveLastCard: topCard.card)
                
                if self.infiniteLoop {
                    if let tmpTopCard = self.infos.first?.card {
                        self.currentIndex = 0 // 如果最后一个卡片滑出去了，且可以无限滑动，那么把索引置为0
                        tmpTopCard.isUserInteractionEnabled = true // 使顶层卡片可以响应事件
                        self.delegate?.dragCard(self, didDisplayCard: tmpTopCard, withIndexAt: self.currentIndex)
                    }
                }
            } else {
                // 如果不是最后一张卡片移出去，则把索引+1
                self.currentIndex = self.currentIndex + 1
                self.infos.first?.card.isUserInteractionEnabled = true
                
                // 显示当前卡片的回调
                if let tmpTopCard = self.infos.first?.card {
                    self.delegate?.dragCard(self, didDisplayCard: tmpTopCard, withIndexAt: self.currentIndex)
                }
            }
        }
        
        
        // 顶层卡片的动画
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else { return }
            if self.removeDirection == .horizontal {
                var flag: Int = 0
                if horizontalMoveDistance > 0 {
                    flag = 2 // 右边滑出
                } else {
                    flag = -1 // 左边滑出
                }
                let tmpWidth = UIScreen.main.bounds.size.width * CGFloat(flag)
                let tmpHeight = (verticalMoveDistance / horizontalMoveDistance * tmpWidth) + self.initialFirstCardCenter.y
                topCard.card.center = CGPoint(x: tmpWidth, y: tmpHeight) // 中心点设置
            } else {
                var flag: Int = 0
                if verticalMoveDistance > 0 {
                    flag = 2 // 向下滑出
                } else {
                    flag = -1 // 向上滑出
                }
                let tmpHeight = UIScreen.main.bounds.size.height * CGFloat(flag)
                let tmpWidth = horizontalMoveDistance / verticalMoveDistance * tmpHeight + self.initialFirstCardCenter.x
                topCard.card.center = CGPoint(x: tmpWidth, y: tmpHeight) // 中心点设置
            }
        }) { (isFinish) in
            if !isFinish { return }
            topCard.card.removeFromSuperview()
        }
    }
    
    /// 重置所有卡片位置信息
    private func restore() {
        // 这儿加上动画的原因是：回调给外部的时候就自带动画了
        guard let topCard = self.infos.first?.card else { return }
        UIView.animate(withDuration: 0.08) { [weak self] in
            guard let self = self else { return }
            let direction = YHDragCardDirection(horizontal: .default, vertical: .default, horizontalRatio: 0.0, verticalRatio: 0.0)
            self.delegate?.dragCard(self, currentCard: topCard, withIndex: self.currentIndex, currentCardDirection: direction, canRemove: false)
        }
        //
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        guard let self = self else { return }
                        for (_, info) in self.infos.enumerated() {
                            info.card.transform = info.transform
                            info.card.frame = info.frame
                        }
        }) { [weak self] (isFinish) in
            guard let self = self else { return }
            if isFinish {
                // 只有当infos数量大于visibleCount时，才移除最底部的卡片
                if self.infos.count > self.visibleCount {
                    if let info = self.infos.last {
                        info.card.removeFromSuperview()
                    }
                    self.infos.removeLast()
                }
            }
        }
    }
}


