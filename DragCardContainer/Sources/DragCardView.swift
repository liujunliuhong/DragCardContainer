//
//  DragCardView.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/3/3.
//

import Foundation
import UIKit

internal protocol CardDelegate: AnyObject {
    func cardDidBeginSwipe(_ card: DragCardView)
    func cardDidCancelSwipe(_ card: DragCardView)
    func cardDidContinueSwipe(_ card: DragCardView)
    func cardDidSwipe(_ card: DragCardView, withDirection direction: Direction)
    func cardDidDragout(_ card: DragCardView)
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
    
    /// The total duration of the rewind animation, measured in seconds.
    public var totalRewindDuration: TimeInterval = 0.3 {
        didSet {
            totalRewindDuration = max(.leastNormalMagnitude, totalRewindDuration)
        }
    }
    
    /// The main content view.
    public lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private lazy var overlayContentView: UIView = {
        let overlayContentView = UIView()
        overlayContentView.setUserInteraction(false)
        return overlayContentView
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
    
    internal weak var delegate: CardDelegate?
    private var internalTouchLocation: CGPoint?
    private var overlays: [Direction: UIView] = [:]
    
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
        overlayContentView.frame = bounds
        overlays.values.forEach { $0.frame = overlayContentView.bounds }
        bringSubviewToFront(overlayContentView)
    }
}

extension DragCardView {
    private func initUI() {
        addPanGesture()
        addTapGesture()
    }
    
    private func setupUI() {
        addSubview(contentView)
        addSubview(overlayContentView)
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
}

extension DragCardView {
    internal func swipe(to direction: Direction) {
        dragout(direction: direction, forced: true)
    }
    
    internal func rewind(from direction: Direction) {
        setUserInteraction(false)
        removeAllAnimations()
        
        let finalTransform = finalTransform(direction, forced: true)
        
        transform = finalTransform
        
        for _direction in allowedDirection.filter({ $0 != direction }) {
            overlay(forDirection: _direction)?.alpha = 0.0
        }
        
        let overlay = overlay(forDirection: direction)
        overlay?.alpha = 1.0
        
        let relativeOverlayDuration = overlay != nil ? 0.1 : 0.0
        
        Animator.animateKeyFrames(withDuration: totalRewindDuration,
                                  options: [.calculationModeLinear]) {
            Animator.addKeyFrame(withRelativeStartTime: 0,
                                 relativeDuration: 1 - relativeOverlayDuration) {
                self.transform = .identity
            }
            Animator.addKeyFrame(withRelativeStartTime: 1 - relativeOverlayDuration,
                                 relativeDuration: relativeOverlayDuration) {
                overlay?.alpha = 0.0
            }
        } completion: { _ in
            self.setUserInteraction(true)
        }
    }
    
    internal func removeAllAnimations() {
        layer.removeAllAnimations()
    }
}

extension DragCardView {
    internal func finalDuration(_ direction: Direction, forced: Bool) -> TimeInterval {
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
    
    private func finalTransform(_ direction: Direction, forced: Bool) -> CGAffineTransform {
        let dragTranslation = CGVector(to: panGestureRecognizer?.translation(in: superview) ?? .zero)
        
        let normalizedDragTranslation = forced ? direction.vector : dragTranslation.normalized
        
        let actualTranslation = CGPoint(finalTranslation(direction, directionVector: normalizedDragTranslation))
        let actualRotationAngle = finalRotationAngle(direction: direction, forced: forced)
        
        let t1 = CGAffineTransform(translationX: actualTranslation.x, y: actualTranslation.y)
        let t2 = t1.rotated(by: actualRotationAngle)
        
        return t2
    }
    
    private func finalTranslation(_ direction: Direction, directionVector: CGVector) -> CGVector {
        let maxScreenLength = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let minimumOffscreenTranslation = CGVector(dx: maxScreenLength,
                                                   dy: maxScreenLength)
        return CGVector(dx: directionVector.dx * minimumOffscreenTranslation.dx,
                        dy: directionVector.dy * minimumOffscreenTranslation.dy)
    }
    
    private func finalRotationAngle(direction: Direction, forced: Bool) -> CGFloat {
        if direction == .up || direction == .down { return .zero }
        
        let rotationDirectionY: CGFloat = direction == .left ? -1.0 : 1.0
        
        if forced {
            return rotationDirectionY * maximumRotationAngle.radius
        }
        
        guard let touchPoint = internalTouchLocation else {
            return rotationDirectionY * maximumRotationAngle.radius
        }
        
        if (direction == .left && touchPoint.y < bounds.height / 2.0) || (direction == .right && touchPoint.y >= bounds.height / 2) {
            return -maximumRotationAngle.radius
        }
        return maximumRotationAngle.radius
    }
}

extension DragCardView {
    private func panForTransform() -> CGAffineTransform {
        func panForRotationAngle() -> CGFloat {
            let superviewTranslation = panGestureRecognizer?.translation(in: superview) ?? .zero
            let percentage = min(abs(superviewTranslation.x) / UIScreen.main.bounds.width, 1)
            
            if superviewTranslation.x.isEqual(to: .zero) {
                return .zero
            }
            
            guard let touchPoint = internalTouchLocation else {
                return .zero
            }
            
            if (superviewTranslation.x.isLess(than: .zero) && touchPoint.y < bounds.height / 2.0) ||
                (!superviewTranslation.x.isLessThanOrEqualTo(.zero) && touchPoint.y >= bounds.height / 2) {
                return -percentage * maximumRotationAngle.radius
            }
            
            return percentage * maximumRotationAngle.radius
        }
        
        let dragTranslation = panGestureRecognizer?.translation(in: superview) ?? .zero
        let translation = CGAffineTransform(translationX: dragTranslation.x,
                                            y: dragTranslation.y)
        return translation.rotated(by: panForRotationAngle())
    }
    
    private func panForOverlayPercentage(_ direction: Direction) -> CGFloat {
        if direction != activeDirection() { return 0 }
        let totalPercentage = allowedDirection.reduce(0) { sum, direction in
            return sum + dragPercentage(on: direction)
        }
        let actualPercentage = 2 * dragPercentage(on: direction) - totalPercentage
        return max(0, min(actualPercentage, 1))
    }
    
    private func dragout(direction: Direction, forced: Bool) {
        setUserInteraction(false)
        
        removeAllAnimations()
        
        let finalDuration = finalDuration(direction, forced: forced)
        let finalTransform = finalTransform(direction, forced: forced)
        
        let overlay = overlay(forDirection: direction)
        
        let relativeOverlayDuration = (forced && overlay != nil) ? 0.1 : 0.0
        
        Animator.animateKeyFrames(withDuration: finalDuration,
                                  options: [.calculationModeLinear]) {
            Animator.addKeyFrame(withRelativeStartTime: relativeOverlayDuration,
                                 relativeDuration: 1 - relativeOverlayDuration) {
                self.transform = finalTransform
            }
            Animator.addKeyFrame(withRelativeStartTime: 0,
                                 relativeDuration: relativeOverlayDuration) {
                overlay?.alpha = 1
            }
            for _direction in self.allowedDirection.filter({ $0 != direction }) {
                self.overlay(forDirection: _direction)?.alpha = 0.0
            }
        } completion: { _ in
            self.delegate?.cardDidDragout(self)
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
    public func setOverlay(_ overlay: UIView?, forDirection direction: Direction) {
        overlays[direction]?.removeFromSuperview()
        overlays[direction] = overlay
        
        if let overlay = overlay {
            overlayContentView.addSubview(overlay)
            overlay.alpha = 0
            overlay.setUserInteraction(false)
        }
    }
    
    public func setOverlays(_ overlays: [Direction: UIView]) {
        for (direction, overlay) in overlays {
            setOverlay(overlay, forDirection: direction)
        }
    }
    
    public func overlay(forDirection direction: Direction) -> UIView? {
        return overlays[direction]
    }
}

extension DragCardView {
    @objc private func handlePan(_ recognizer: PanGestureRecognizer) {
        switch recognizer.state {
            case .possible, .began:
                removeAllAnimations()
                internalTouchLocation = recognizer.location(in: self)
                delegate?.cardDidBeginSwipe(self)
            case .changed:
                transform = panForTransform()
                for (direction, overlay) in overlays {
                    overlay.alpha = panForOverlayPercentage(direction)
                }
                delegate?.cardDidContinueSwipe(self)
            case .ended, .cancelled:
                if let direction = activeDirection() {
                    if dragSpeed(on: direction) >= minimumSwipeSpeed(on: direction) || dragPercentage(on: direction) >= 1 {
                        // dragout
                        dragout(direction: direction, forced: false)
                        delegate?.cardDidSwipe(self, withDirection: direction)
                        return
                    }
                }
                // reset
                removeAllAnimations()
                Animator.animateSpring(withDuration: totalResetDuration,
                                       usingSpringWithDamping: resetSpringDamping,
                                       options: [.curveLinear, .allowUserInteraction]) {
                    self.transform = .identity
                    self.overlays.values.forEach{ $0.alpha = 0 }
                }
                delegate?.cardDidCancelSwipe(self)
            default:
                break
        }
    }
}

extension DragCardView {
    @objc private func handleTap(_ recognizer: TapGestureRecognizer) {
        delegate?.cardDidTap(self)
    }
}
