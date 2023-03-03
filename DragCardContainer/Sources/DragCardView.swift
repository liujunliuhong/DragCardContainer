//
//  DragCardView.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/3/3.
//

import Foundation
import UIKit

open class DragCardView: UIView {
    
    public lazy var alphaOverlayContainerView: UIView = {
        let alphaOverlayContainerView = UIView()
        alphaOverlayContainerView.isUserInteractionEnabled = false
        return alphaOverlayContainerView
    }()
    
    public lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    public private(set) var alphaOverlays: [Direction: UIView] = [:]
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
        setupUI()
    }
}

extension DragCardView {
    open override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
        alphaOverlayContainerView.frame = bounds
        
        allAlphaOverlays().forEach{ $0.frame = bounds }
        
        bringSubviewToFront(alphaOverlayContainerView)
    }
}

extension DragCardView {
    private func initUI() {
        
    }
    
    private func setupUI() {
        addSubview(contentView)
        addSubview(alphaOverlayContainerView)
    }
}

extension DragCardView {
    public func setAlphaOverlay(_ alphaOverlay: UIView, forDirection direction: Direction) {
        alphaOverlays[direction]?.removeFromSuperview()
        alphaOverlays[direction] = alphaOverlay
        
        alphaOverlayContainerView.addSubview(alphaOverlay)
        alphaOverlay.alpha = 0
        alphaOverlay.isUserInteractionEnabled = false
    }
    
    public func alphaOverlay(forDirection direction: Direction) -> UIView? {
        return alphaOverlays[direction]
    }
    
    public func allAlphaOverlays() -> [UIView] {
        return alphaOverlays.values.map{ $0 }
    }
}
