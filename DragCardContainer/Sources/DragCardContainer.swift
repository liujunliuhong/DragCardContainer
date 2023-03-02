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
#if DEBUG
        print("\(self.classForCoder) deinit")
#endif
    }
    
    /// DataSource
    public weak var dataSource: DragCardDataSource? {
        didSet {
            reloadDataIfNeeded()
        }
    }
    
    /// Delegate
    public weak var delegate: DragCardDelegate?
    
    /// Visible sard count
    public var visibleCount: Int = Default.visibleCount {
        didSet {
            reloadDataIfNeeded()
        }
    }
    
    /// Card spacing
    public var cardSpacing: CGFloat = Default.cardSpacing {
        didSet {
            reloadDataIfNeeded()
        }
    }
    
    /// Minimum card scale
    public var minimumScale: CGFloat = Default.minimumScale {
        didSet {
            reloadDataIfNeeded()
        }
    }
    
    /// Allow infinite loop
    public var infiniteLoop: Bool = Default.infiniteLoop {
        didSet {
            reloadDataIfNeeded()
        }
    }
    
    /// Allowed direction
    public var allowedDirection = Direction.horizontal {
        didSet {
            reloadDataIfNeeded()
        }
    }
    
    /// Minimum translation in percent base on container width or container height
    public var minimumTranslationInPercent: CGFloat = Default.minimumTranslationInPercent {
        didSet {
            reloadDataIfNeeded()
        }
    }
    
    /// Minimum velocity in point per second
    public var minimumVelocityInPointPerSecond: CGFloat = Default.minimumVelocityInPointPerSecond {
        didSet {
            reloadDataIfNeeded()
        }
    }
    
    /// The card maximum rotation angle
    public var cardRotationMaximumAngle: CGFloat = Default.cardRotationMaximumAngle {
        didSet {
            reloadDataIfNeeded()
        }
    }
    
    
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
    
    
    private lazy var modeState: ModeState = {
        let modeState = ModeState(cardContainer: self)
        return modeState
    }()
    
    internal lazy var containerView = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

extension DragCardContainer {
    private func setupUI() {
        backgroundColor = .orange
        addSubview(containerView)
    }
}

extension DragCardContainer {
    public override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = bounds
        reloadDataIfNeeded()
    }
}

extension DragCardContainer {
    public func rewind(from: Direction) {
        modeState.rewind(from: from)
    }
    
    public func swipeTopCard(to: Direction) {
        modeState.swipeTopCard(to: to)
    }
}

extension DragCardContainer {
    private func reloadDataIfNeeded() {
        if dataSource != nil {
            modeState.prepare()
        }
    }
}
