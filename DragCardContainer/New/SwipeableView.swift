//
//  SwipeableView.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/2/27.
//

import UIKit

internal func RBA(R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat = 1.0) -> UIColor {
    return UIColor(red: (R / 255.0), green: (G / 255.0), blue: (B / 255.0), alpha: A)
}

/// 获取一个随机颜色
internal func RandomColor() -> UIColor {
    let R: CGFloat = CGFloat(Int.random(in: Range(uncheckedBounds: (0, 255))))
    let G: CGFloat = CGFloat(Int.random(in: Range(uncheckedBounds: (0, 255))))
    let B: CGFloat = CGFloat(Int.random(in: Range(uncheckedBounds: (0, 255))))
    let A: CGFloat = 1.0
    return RBA(R: R, G: G, B: B, A: A)
}


public final class SwipeableView: UIView {
    
    
    
    private lazy var testView: UIView = {
        let testView = UIView()
        testView.backgroundColor = RandomColor()
        return testView
    }()
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        return animator
    }()
    
    public var cardSpacing: CGFloat = 10.0
    public var minimumScale: CGFloat = 0.8
    
    
    private var attachmentBehavior: UIAttachmentBehavior?
    private var snapBehavior: UISnapBehavior?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SwipeableView {
    public override func layoutSubviews() {
        super.layoutSubviews()
        testView.frame = bounds
    }
}

extension SwipeableView {
    private func initUI() {
        
    }
    
    private func setupUI() {
        addSubview(testView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        testView.addGestureRecognizer(pan)
    }
}

extension SwipeableView {
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        let location = recognizer.location(in: self)
        let velocity = recognizer.velocity(in: self)
        
        switch recognizer.state {
            case .began:
                print("begin")
                print("😄\(location)")
                
                if let snapBehavior = snapBehavior {
                    animator.removeBehavior(snapBehavior)
                }
                
                // UIViewPropertyAnimator
                
                let snapBehavior = UISnapBehavior(item: testView, snapTo: location)
                snapBehavior.damping = 1.0
                animator.addBehavior(snapBehavior)
                self.snapBehavior = snapBehavior
                
//                let attachmentBehavior = UIAttachmentBehavior(item: testView, attachedToAnchor: location)
//                attachmentBehavior.length = 0
//                attachmentBehavior.damping = 0
//                animator.addBehavior(attachmentBehavior)
//                self.attachmentBehavior = attachmentBehavior
            case .changed:
                print("changed")
                if let attachmentBehavior = attachmentBehavior {
                    attachmentBehavior.anchorPoint = location
                }
            case .ended, .cancelled:
                print("ended or cancelled")
            default:
                break
        }
    }
}

extension SwipeableView {
    
}
