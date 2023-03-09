//
//  DragCardView.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/3/3.
//

import Foundation
import UIKit

internal protocol CardDelegate {
    func cardDidBeginSwipe(_ card: DragCardView)
    func cardDidCancelSwipe(_ card: DragCardView)
    func cardDidContinueSwipe(_ card: DragCardView)
    func cardDidSwipe(_ card: DragCardView, withDirection direction: Direction)
    
    func cardDidTap(_ card: DragCardView)
}


open class DragCardView: UIView {
    
    /// The swipe directions to be detected by the view.
    /// Set this variable to ignore certain directions.
    open var allowedDirection: [Direction] = Direction.horizontal
    
    /// The maximum rotation angle of the card, measured in degree.
    /// Defined as a value in the range `[0, 90]`.
    public var maximumRotationAngle: CGFloat = 20.0 {
        didSet {
            maximumRotationAngle = max(0, min(maximumRotationAngle, 90))
        }
    }
    
    /// The duration of the spring-like animation applied when a swipe is canceled, measured in seconds.
    public var totalResetDuration: TimeInterval = 0.6 {
        didSet {
            totalResetDuration = max(.leastNormalMagnitude, totalResetDuration)
        }
    }
    
    /// The damping coefficient of the spring-like animation applied when a swipe is canceled.
    public var resetSpringDamping: CGFloat = 0.5 {
        didSet {
            resetSpringDamping = max(0, min(resetSpringDamping, 1))
        }
    }
    
    /// The total duration of the swipe animation, measured in seconds.
    public var totalSwipeDuration: TimeInterval = 0.7 {
        didSet {
            totalSwipeDuration = max(.leastNormalMagnitude, totalSwipeDuration)
        }
    }
    
    /// The total duration of the reverse swipe animation, measured in seconds.
    public var totalReverseSwipeDuration: TimeInterval = 0.25 {
        didSet {
            totalReverseSwipeDuration = max(.leastNormalMagnitude, totalReverseSwipeDuration)
        }
    }
    
    /// The main content view.
    public lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    /// The pan gesture recognizer attached to the view.
    public var panGestureRecognizer: PanGestureRecognizer? {
        for gesture in (gestureRecognizers ?? []) {
            if let _gesture_ = gesture as? PanGestureRecognizer {
                return _gesture_
            }
        }
        return nil
    }
    
    /// The tap gesture recognizer attached to the view.
    public var tapGestureRecognizer: TapGestureRecognizer? {
        for gesture in (gestureRecognizers ?? []) {
            if let _gesture_ = gesture as? TapGestureRecognizer {
                return _gesture_
            }
        }
        return nil
    }
    
    /// The minimum required speed on the intended direction to trigger a swipe.
    open func minimumSwipeSpeed(on direction: Direction) -> CGFloat {
        return 1100
    }
    
    /// The minimum required drag distance on the intended direction to trigger a swipe.
    /// Measured from the swipe's initial touch point.
    open func minimumSwipeDistance(on direction: Direction) -> CGFloat {
        return min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 4
    }
    
    private var internalTouchLocation: CGPoint?
    
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
    }
}

extension DragCardView {
    private func initUI() {
        
    }
    
    private func setupUI() {
        addSubview(contentView)
    }
}

extension DragCardView {
    internal func removePanGesture() {
        for gesture in (gestureRecognizers ?? []) {
            if let _gesture_ = gesture as? PanGestureRecognizer {
                removeGestureRecognizer(_gesture_)
            }
        }
    }
    
    internal func removeTapGesture() {
        for gesture in (gestureRecognizers ?? []) {
            if let _gesture_ = gesture as? TapGestureRecognizer {
                removeGestureRecognizer(_gesture_)
            }
        }
    }
    
    internal func addPanGesture() {
        removePanGesture()
        let panGesture = PanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
    }
    
    internal func addTapGesture() {
        removeTapGesture()
        let tapGesture = TapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    internal func swipeDuration(_ direction: Direction, forced: Bool) -> TimeInterval {
        if forced {
            return totalSwipeDuration
        }
        
        let velocityFactor = dragSpeed(on: direction) / minimumSwipeSpeed(on: direction)
        
        // Card swiped below the minimum swipe speed.
        if velocityFactor < 1.0 {
            return totalSwipeDuration
        }
        
        // Card swiped at least the minimum swipe speed -> return relative duration
        return 1.0 / TimeInterval(velocityFactor)
    }
    
    internal func removeAllAnimations() {
        layer.removeAllAnimations()
    }
    
    internal func swipeAction(direction: Direction, forced: Bool) {
        isUserInteractionEnabled = false
        removeAllAnimations()
        
        let duration = swipeDuration(direction, forced: forced)
        
        Animator.animateKeyFrames(withDuration: duration,
                                  options: [.calculationModeLinear]) {
            
        } completion: { _ in
            
        }

        animator.animateSwipe(on: self,
                              direction: direction,
                              forced: forced) { [weak self] finished in
            if let strongSelf = self, finished {
                strongSelf.delegate?.cardDidFinishSwipeAnimation(strongSelf)
            }
        }
    }
    
    
}

extension DragCardView {
    /// The active swipe direction on the view.
    public func activeDirection() -> Direction? {
        return allowedDirection.reduce((CGFloat.zero, nil)) { [weak self] lastResult, direction in
            guard let self = self else { return lastResult }
            let dragPercentage = self.dragPercentage(on: direction)
            return (dragPercentage > lastResult.0) ? (dragPercentage, direction) : lastResult
        }.1
    }
    
    /// The speed of the current drag velocity.
    public func dragSpeed(on direction: Direction) -> CGFloat {
        let velocity = panGestureRecognizer?.velocity(in: superview) ?? .zero
        return abs(direction.vector * CGVector(to: velocity))
    }
    
    /// The percentage of `minimumSwipeDistance` the current drag translation attains in the specified direction.
    public func dragPercentage(on direction: Direction) -> CGFloat {
        let translation = CGVector(to: panGestureRecognizer?.translation(in: superview) ?? .zero)
        let scaleFactor = 1 / minimumSwipeDistance(on: direction)
        let percentage = scaleFactor * (translation * direction.vector)
        return percentage < 0 ? 0 : percentage
    }
}

extension DragCardView {
    private func panForTransform() -> CGAffineTransform {
        let dragTranslation = panGestureRecognizer?.translation(in: superview) ?? .zero
        let translation = CGAffineTransform(translationX: dragTranslation.x,
                                            y: dragTranslation.y)
        let rotation = CGAffineTransform(rotationAngle: panForRotationAngle())
        return translation.concatenating(rotation)
    }
    
    private func panForRotationAngle() -> CGFloat {
        let superviewTranslation = panGestureRecognizer?.translation(in: superview) ?? .zero
        let percentage = min(abs(superviewTranslation.x) / UIScreen.main.bounds.width, 1)
        
        if superviewTranslation.x.isEqual(to: .zero) {
            return .zero
        }
        
        guard let touchPoint = internalTouchLocation else {
            return percentage * maximumRotationAngle.radius
        }
        
        if (superviewTranslation.x.isLess(than: .zero) && touchPoint.y < bounds.height / 2.0) ||
            (!superviewTranslation.x.isLessThanOrEqualTo(.zero) && touchPoint.y >= bounds.height / 2) {
            return -percentage * maximumRotationAngle.radius
        }
        
        return percentage * maximumRotationAngle.radius
    }
}

extension DragCardView {
    private func finalRotationAngle(_ direction: Direction) -> CGFloat {
        if direction == .up || direction == .down { return .zero }
        
        guard let touchPoint = internalTouchLocation else {
            return maximumRotationAngle.radius
        }
        
        if (direction == .left && touchPoint.y < bounds.height / 2.0) || (direction == .right && touchPoint.y >= bounds.height / 2) {
            return -maximumRotationAngle.radius
        }
        return maximumRotationAngle.radius
    }
}

extension DragCardView {
    @objc private func handlePan(_ recognizer: PanGestureRecognizer) {
        switch recognizer.state {
            case .possible, .began:
                internalTouchLocation = recognizer.location(in: self)
            case .changed:
                transform = panForTransform()
            case .ended, .cancelled:
                if let direction = activeDirection() {
                    if dragSpeed(on: direction) >= minimumSwipeSpeed(on: direction) || dragPercentage(on: direction) >= 1 {
                        // swipe
                        return
                    }
                }
                // reset
                removeAllAnimations()
                Animator.animateSpring(withDuration: totalResetDuration,
                                       usingSpringWithDamping: resetSpringDamping,
                                       options: [.curveLinear, .allowUserInteraction]) {
                    self.transform = .identity
                }
            default:
                break
        }
    }
}

extension DragCardView {
    @objc private func handleTap(_ recognizer: TapGestureRecognizer) {
        
    }
}
