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
    
    /// Visible card count.
    public var visibleCount: Int = Default.visibleCount {
        didSet {
            reloadDataIfNeeded()
        }
    }
    
    /// Mode
    public var mode: Mode = Default.mode {
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
    
    /// Minimum translation in percent base on container width or container height.
    public var minimumTranslationInPercent: CGFloat = Default.minimumTranslationInPercent {
        didSet {
            reloadDataIfNeeded()
        }
    }
    
    /// Minimum velocity in point per second.
    public var minimumVelocityInPointPerSecond: CGFloat = Default.minimumVelocityInPointPerSecond {
        didSet {
            reloadDataIfNeeded()
        }
    }
    
    /// The card maximum rotation angle.
    public var cardRotationMaximumAngle: CGFloat = Default.cardRotationMaximumAngle {
        didSet {
            reloadDataIfNeeded()
        }
    }
    
    /// Current top index.
    public var currentTopIndex: Int? {
        set {
            engine.topIndex = newValue
        }
        get {
            return engine.topIndex
        }
    }
    
    /// Disable drag action for top card.
    public var disableTopCardDrag: Bool = false {
        didSet {
            if disableTopCardDrag {
                engine.removePanGestureForTopCard()
            } else {
                engine.addPanGestureForTopCard()
            }
        }
    }
    
    /// Disable click action for top card.
    public var disableTopCardClick: Bool = false {
        didSet {
            if disableTopCardClick {
                engine.removeTapGestureForTopCard()
            } else {
                engine.addTapGestureForTopCard()
            }
        }
    }
    
    private lazy var engine: CardEngine = {
        let engine = CardEngine(cardContainer: self)
        return engine
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
    public func reloadData(animation: Bool = false) {
        engine.start(forceReset: true, animation: animation)
    }
    
    public func rewind(from: Direction) {
        engine.rewind(from: from)
    }
    
    public func swipeTopCard(to: Direction) {
        engine.swipeTopCard(to: to)
    }
}

extension DragCardContainer {
    private func reloadDataIfNeeded() {
        if dataSource != nil {
            engine.start(forceReset: false, animation: false)
        }
    }
}
