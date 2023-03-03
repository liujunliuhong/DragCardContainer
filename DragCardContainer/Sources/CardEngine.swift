//
//  CardEngine.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/3/3.
//
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
import QuartzCore

internal final class CardEngine {
    
    deinit {
#if DEBUG
        print("\(self) deinit")
#endif
        flush()
    }
    
    private weak var weakCardContainer: DragCardContainer?
    
    private var displayCardIndex: Int = 0
    
    private var cardModels: [CardModel] = []
    private var dragOutCardModels: [CardModel] = []
    
    private var currentHoldCardModel: CardModel?
    private var activeCardsAnimator: UIViewPropertyAnimator?
    
    private var isPanDirectionUp: Bool = true
    
    private var metrics: Metrics = .default
    
    private var _topIndex: Int?
    internal var topIndex: Int? {
        get {
            _topIndex = cardModels.last?.index
            return _topIndex
        }
        set {
            if let newValue = newValue, newValue >= 0 && newValue <= metrics.numberOfCards - 1 {
                _topIndex = newValue
                start(forceReset: false, animation: false)
            }
        }
    }
    
    internal var cardContainer: DragCardContainer {
        guard let cardContainer = weakCardContainer else {
            fatalError("")
        }
        return cardContainer
    }
    
    internal var cardDataSource: DragCardDataSource {
        guard let cardDataSource = cardContainer.dataSource else {
            fatalError("")
        }
        return cardDataSource
    }
    
    internal init(cardContainer: DragCardContainer) {
        self.weakCardContainer = cardContainer
    }
}

extension CardEngine {
    internal func start(forceReset: Bool, animation: Bool) {
        metrics = Metrics(engine: self)
        //
        if forceReset {
            displayCardIndex = 0
        } else {
            displayCardIndex = _topIndex ?? 0
        }
        //
        flush()
        //
        let displayCount = metrics.visibleCount
        for i in 0..<displayCount {
            installNextCard()
            if i != displayCount - 1 {
                incrementDisplayIndex()
            }
        }
        
        updateAllCardModelsTargetBasicInfo()
        
        if animation {
            let animator = UIViewPropertyAnimator(duration: Default.animationDuration,
                                                  curve: .easeInOut) {
                for model in self.cardModels {
                    model.cardView.layer.transform = CATransform3DIdentity
                    model.cardView.frame = model.targetBasicInfo.frame
                    model.cardView.layer.transform = model.targetBasicInfo.transform3D
                    model.cardView.alpha = model.targetBasicInfo.alpha
                }
            }
            animator.startAnimation()
        } else {
            for model in self.cardModels {
                model.cardView.layer.transform = CATransform3DIdentity
                model.cardView.frame = model.targetBasicInfo.frame
                model.cardView.layer.transform = model.targetBasicInfo.transform3D
                model.cardView.alpha = model.targetBasicInfo.alpha
            }
        }
        
        addPanGestureForTopCard()
        addTapGestureForTopCard()
        
        delegateForDisplayTopCard()
    }
    
    internal func swipeTopCard(to: Direction) {
        if metrics.allowedDirection.intersection(to) == .none {
            return
        }
        
        if let dragOutCardModel = cardModels.last {
            dragOutCardModel.dragOutMovement = autoEndMovement(direction: to)
            dragOutCardModels.append(dragOutCardModel)
            cardModels.removeLast() // remove last
            
            removeTapGesture(dragOutCardModel.cardView)
            removePanGesture(dragOutCardModel.cardView)
            
            addPanGestureForTopCard()
            addTapGestureForTopCard()
        }
        
        incrementDisplayIndex()
        installNextCard()
        
        updateAllCardModelsTargetBasicInfo()
        
        activeCardsAnimator?.stopAnimation(false)
        activeCardsAnimator?.finishAnimation(at: .current)
        activeCardsAnimator = nil
        
        activeCardsAnimator = UIViewPropertyAnimator(duration: Default.animationDuration,
                                                     curve: .easeInOut,
                                                     animations: {
            for model in self.cardModels {
                model.cardView.layer.transform = CATransform3DIdentity
                model.cardView.frame = model.targetBasicInfo.frame
                model.cardView.layer.transform = model.targetBasicInfo.transform3D
                model.cardView.alpha = model.targetBasicInfo.alpha
            }
        })
        activeCardsAnimator?.startAnimation()
        
        dragOut()
    }
    
    internal func rewind(from: Direction) {
        if metrics.allowedDirection.intersection(from) == .none {
            return
        }
        
        var index: Int
        
        if let topModel = cardModels.last {
            index = topModel.index
            
            if metrics.infiniteLoop {
                if index <= 0 {
                    index = metrics.numberOfCards - 1
                } else {
                    index = index - 1
                }
            } else {
                if index <= 0 {
                    return
                }
                index = index - 1
            }
        } else {
            index = metrics.numberOfCards - 1
        }
        
        if index > metrics.numberOfCards - 1 {
            return
        }
        
        let endMovement = autoEndMovement(direction: from)
        let finalTranslation = finalTranslation(movement: endMovement)
        let endTransform = endTransform(movement: endMovement)
        
        let cardView = cardDataSource.dragCard(cardContainer, viewForCard: index)
        
        cardView.layer.anchorPoint = metrics.maximumBasicInfo.anchorPoint
        cardView.layer.transform = CATransform3DIdentity
        cardView.frame = metrics.maximumBasicInfo.frame
        cardView.layer.transform = endTransform
        cardView.alpha = 1
        cardContainer.containerView.addSubview(cardView)
        
        let cardModel = CardModel(cardView: cardView, index: index)
        
        currentHoldCardModel = cardModel
        
        delegateForMovementCard(model: cardModel, translation: finalTranslation)
        
        restoreCard()
    }
    
    internal func addPanGestureForTopCard() {
        if let topModel = cardModels.last {
            addPanGesture(topModel.cardView)
        }
    }
    
    internal func addTapGestureForTopCard() {
        if let topModel = cardModels.last {
            addTapGesture(topModel.cardView)
        }
    }
    
    internal func removePanGestureForTopCard() {
        if let topModel = cardModels.last {
            removePanGesture(topModel.cardView)
        }
    }
    
    internal func removeTapGestureForTopCard() {
        if let topModel = cardModels.last {
            removeTapGesture(topModel.cardView)
        }
    }
}

extension CardEngine {
    private func flush() {
        for model in cardModels {
            model.cardView.removeFromSuperview()
        }
        cardModels.removeAll()
        //
        if let currentHoldCardModel = currentHoldCardModel {
            dragOutCardModels.append(currentHoldCardModel)
        }
        currentHoldCardModel = nil
        //
        dragOut(triggerDelegate: false)
        //
        if let activeCardsAnimator = activeCardsAnimator {
            activeCardsAnimator.stopAnimation(true)
            activeCardsAnimator.finishAnimation(at: .current)
        }
        activeCardsAnimator = nil
    }
    
    private func installNextCard() {
        if !canInstallNextCard() {
            return
        }
        
        let index = displayCardIndex
        
        let cardView = cardDataSource.dragCard(cardContainer, viewForCard: index)
        
        cardView.layer.anchorPoint = metrics.minimumBasicInfo.anchorPoint
        cardView.layer.transform = CATransform3DIdentity
        cardView.frame = metrics.minimumBasicInfo.frame
        cardView.layer.transform = metrics.minimumBasicInfo.transform3D
        cardView.alpha = metrics.minimumBasicInfo.alpha
        cardContainer.containerView.insertSubview(cardView, at: 0)
        
        let cardModel = CardModel(cardView: cardView, index: index)
        cardModels.insert(cardModel, at: 0)
    }
    
    private func restoreCard() {
        guard let currentHoldCardModel = currentHoldCardModel else {
            return
        }
        if !canRestoreCard() {
            return
        }
        
        removePanGestureForTopCard()
        removeTapGestureForTopCard()
        
        restoreDisplayIndex()
        
        cardModels.append(currentHoldCardModel)
        
        updateAllCardModelsTargetBasicInfo()
        
        
        let animator = UIViewPropertyAnimator(duration: Default.animationDuration,
                                              dampingRatio: 0.9) {
            for model in self.cardModels {
                model.cardView.layer.transform = CATransform3DIdentity
                model.cardView.frame = model.targetBasicInfo.frame
                model.cardView.layer.transform = model.targetBasicInfo.transform3D
                model.cardView.alpha = model.targetBasicInfo.alpha
            }
            self.delegateForMovementCard(model: currentHoldCardModel, translation: .zero)
        }
        
        animator.addCompletion { p in
            if p == .end {
                if self.cardModels.count > self.metrics.visibleCount {
                    let willRemoveModels = self.cardModels.prefix(self.cardModels.count - self.metrics.visibleCount)
                    for model in willRemoveModels {
                        model.cardView.removeFromSuperview()
                    }
                    
                    self.cardModels = self.cardModels.suffix(self.metrics.visibleCount)
                }
                self.addPanGestureForTopCard()
                self.addTapGestureForTopCard()
            }
        }
        animator.startAnimation()
        
        delegateForDisplayTopCard()
    }
    
    
    private func incrementDisplayIndex() {
        if !canInstallNextCard() {
            return
        }
        if metrics.infiniteLoop {
            if displayCardIndex >= metrics.numberOfCards - 1 {
                displayCardIndex = 0
            } else {
                displayCardIndex = displayCardIndex + 1
            }
        } else {
            displayCardIndex = displayCardIndex + 1
        }
    }
    
    private func restoreDisplayIndex() {
        if !canRestoreCard() {
            return
        }
        if metrics.infiniteLoop {
            if displayCardIndex <= 0 {
                displayCardIndex = metrics.numberOfCards - 1
            } else {
                displayCardIndex = displayCardIndex - 1
            }
        } else {
            if displayCardIndex > 0 && displayCardIndex <= metrics.numberOfCards - 1 {
                displayCardIndex = displayCardIndex - 1
            }
        }
    }
    
    private func canRestoreCard() -> Bool {
        if metrics.infiniteLoop {
            return true
        } else {
            if displayCardIndex > 0 {
                return true
            }
            return false
        }
    }
    
    private func canInstallNextCard() -> Bool {
        if metrics.infiniteLoop {
            return true
        }
        if displayCardIndex >= 0 && displayCardIndex <= metrics.numberOfCards - 1 {
            return true
        }
        return false
    }
    
    private func updateAllCardModelsTargetBasicInfo() {
        for model in cardModels {
            model.targetBasicInfo = metrics.minimumBasicInfo
        }
        
        let needModifyModels = cardModels.suffix(metrics.visibleCount).reversed()
        for (i, model) in needModifyModels.enumerated() {
            model.targetBasicInfo = metrics.basicInfos[i]
        }
    }
    
    private func shouldDragOut(movement: Movement) -> Bool {
        let translation = movement.translation
        let velocity = movement.velocity
        let bounds = cardContainer.containerView.bounds
        
        func isDirectionAllowed() -> Bool {
            return Direction.fromPoint(translation).intersection(metrics.allowedDirection) != .none
        }
        func isTranslationLargeEnough() -> Bool {
            return abs(translation.x) > metrics.minimumTranslationInPercent * bounds.width || abs(translation.y) > metrics.minimumTranslationInPercent * bounds.height
        }
        func isVelocityLargeEnough() -> Bool {
            return velocity.magnitude > metrics.minimumVelocityInPointPerSecond
        }
        // print("direction: \(Direction.fromPoint(translation))")
        // print("isDirectionAllowed: \(isDirectionAllowed())")
        // print("isTranslationLargeEnough: \(isTranslationLargeEnough())")
        return isDirectionAllowed() && (isTranslationLargeEnough() || isVelocityLargeEnough())
    }
    
    private func horizontalDragFraction(movement: Movement) -> CGFloat {
        let bounds = cardContainer.containerView.bounds
        let translation = movement.translation
        
        let fraction = abs(translation.x) / (metrics.minimumTranslationInPercent * bounds.width)
        
        if fraction.isLessThanOrEqualTo(.zero) {
            return .zero
        } else if !fraction.isLessThanOrEqualTo(1.0) {
            return 1.0
        }
        return fraction
    }
    
    private func rotationAngle(movement: Movement) -> CGFloat {
        let bounds = cardContainer.containerView.bounds
        let translation = movement.translation
        
        var fraction = translation.x / (metrics.minimumTranslationInPercent * bounds.width)
        
        if fraction.isLessThanOrEqualTo(-1.0) {
            fraction = -1.0
        } else if !fraction.isLessThanOrEqualTo(1.0) {
            fraction = 1.0
        }
        
        let cardRotationMaximumAngle = isPanDirectionUp ? metrics.cardRotationMaximumAngle : -metrics.cardRotationMaximumAngle
        
        return (fraction * cardRotationMaximumAngle).radius
    }
    
    private func removePanGesture(_ cardView: UIView) {
        for gesture in (cardView.gestureRecognizers ?? []) {
            if gesture.isKind(of: PanGestureRecognizer.classForCoder()) {
                cardView.removeGestureRecognizer(gesture)
            }
        }
    }
    
    private func removeTapGesture(_ cardView: UIView) {
        for gesture in (cardView.gestureRecognizers ?? []) {
            if gesture.isKind(of: TapGestureRecognizer.classForCoder()) {
                cardView.removeGestureRecognizer(gesture)
            }
        }
    }
    
    private func addPanGesture(_ cardView: UIView) {
        removePanGesture(cardView)
        let panGesture = PanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        cardView.addGestureRecognizer(panGesture)
    }
    
    private func addTapGesture(_ cardView: UIView) {
        removeTapGesture(cardView)
        let tapGesture = TapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        cardView.addGestureRecognizer(tapGesture)
    }
    
    private func autoEndMovement(direction: Direction) -> Movement {
        switch direction {
            case .up:
                let movement = Movement(translation: CGPoint(x: 0,
                                                             y: -1),
                                        velocity: CGPoint(x: 0,
                                                          y: -metrics.minimumVelocityInPointPerSecond))
                return movement
            case .down:
                let movement = Movement(translation: CGPoint(x: 0,
                                                             y: 1),
                                        velocity: CGPoint(x: 0,
                                                          y: metrics.minimumVelocityInPointPerSecond))
                return movement
            case .right:
                let movement = Movement(translation: CGPoint(x: 1,
                                                             y: 0),
                                        velocity: CGPoint(x: metrics.minimumVelocityInPointPerSecond,
                                                          y: 0))
                return movement
            case .left:
                let movement = Movement(translation: CGPoint(x: -1,
                                                             y: 0),
                                        velocity: CGPoint(x: -metrics.minimumVelocityInPointPerSecond,
                                                          y: 0))
                return movement
            default:
                return .default
        }
    }
    
    private func endTransform(movement: Movement) -> CATransform3D {
        let toTranslation = finalTranslation(movement: movement)
        let translationTransform = CATransform3DTranslate(CATransform3DIdentity, toTranslation.x, toTranslation.y, .zero)
        let transform = CATransform3DRotate(translationTransform, metrics.cardRotationMaximumAngle.radius, 0, 0, 1)
        return transform
    }
    
    private func finalTranslation(movement: Movement) -> CGPoint {
        let toTranslation = movement.translation.normalized * max(movement.velocity.magnitude, metrics.minimumVelocityInPointPerSecond)
        return toTranslation
    }
    
    private func dragOut(triggerDelegate: Bool = true) {
        if triggerDelegate {
            delegateForDisplayTopCard()
        }
        
        for model in dragOutCardModels {
            removePanGesture(model.cardView)
            
            if model.dragOutStatus == .ongoing || model.dragOutStatus == .done {
                continue
            }
            
            if triggerDelegate {
                delegateForRemoveTopCard(model: model)
                delegateForFinishRemoveLastCard(model: model)
            }
            
            model.dragOutStatus = .ongoing
            
            let dragOutMovement = model.dragOutMovement
            
            let finalTranslation = finalTranslation(movement: dragOutMovement)
            
            let transform = endTransform(movement: dragOutMovement)
            
            UIView.animate(withDuration: Default.animationDuration * 2.0,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                model.cardView.layer.transform = transform
                model.cardView.alpha = 1
                
                if triggerDelegate {
                    self.delegateForMovementCard(model: model, translation: finalTranslation)
                }
                
            } completion: { _ in
                model.dragOutStatus = .done
                model.cardView.removeFromSuperview()
                
                var canFlush: Bool = true
                for model in self.dragOutCardModels {
                    if model.dragOutStatus != .done {
                        canFlush = false
                        break
                    }
                }
                if canFlush {
                    for model in self.dragOutCardModels {
                        model.cardView.removeFromSuperview()
                    }
                    self.dragOutCardModels.removeAll()
                }
            }
        }
    }
    
    
}

extension CardEngine {
    private func delegateForTapTopCard() {
        guard let topModel = cardModels.last else { return }
        cardContainer.delegate?.dragCard(cardContainer,
                                         didSelectTopCardAt: topModel.index,
                                         with: topModel.cardView)
    }
    
    private func delegateForDisplayTopCard() {
        guard let topModel = cardModels.last else { return }
        cardContainer.delegate?.dragCard(cardContainer,
                                         displayTopCardAt: topModel.index,
                                         with: topModel.cardView)
    }
    
    private func delegateForFinishRemoveLastCard(model: CardModel) {
        if model.index == metrics.numberOfCards - 1 && !metrics.infiniteLoop {
            cardContainer.delegate?.dragCard(cardContainer,
                                             didRemovedLast: model.cardView)
        }
    }
    
    private func delegateForRemoveTopCard(model: CardModel) {
        let direction = Direction.fromPoint(model.dragOutMovement.translation)
        cardContainer.delegate?.dragCard(cardContainer,
                                         didRemovedTopCardAt: model.index,
                                         direction: direction,
                                         with: model.cardView)
    }
    
    private func delegateForMovementCard(model: CardModel, translation: CGPoint) {
        cardContainer.delegate?.dragCard(cardContainer,
                                         movementCardAt: model.index,
                                         translation: translation,
                                         with: model.cardView)
    }
}

extension CardEngine {
    @objc private func handlePan(_ recognizer: PanGestureRecognizer) {
        guard let touchView = recognizer.view else { return }
        let translation = recognizer.translation(in: cardContainer.containerView)
        let locationInTouchView = recognizer.location(in: touchView)
        let velocity = recognizer.velocity(in: cardContainer.containerView)
        
        let movement = Movement(translation: translation, velocity: velocity)
        
        switch recognizer.state {
            case .began:
                isPanDirectionUp = locationInTouchView.y <= touchView.bounds.height / 2.0
                
                currentHoldCardModel = cardModels.last
                cardModels.removeLast() // remove last
                
                incrementDisplayIndex()
                installNextCard()
                
                updateAllCardModelsTargetBasicInfo()
                
                activeCardsAnimator?.stopAnimation(false)
                activeCardsAnimator?.finishAnimation(at: .end)
                activeCardsAnimator = nil
                
                activeCardsAnimator = UIViewPropertyAnimator(duration: Default.animationDuration,
                                                             curve: .easeInOut,
                                                             animations: {
                    for model in self.cardModels {
                        model.cardView.layer.transform = CATransform3DIdentity
                        model.cardView.frame = model.targetBasicInfo.frame
                        model.cardView.layer.transform = model.targetBasicInfo.transform3D
                        model.cardView.alpha = model.targetBasicInfo.alpha
                    }
                })
                
            case .changed:
                // rotate and translate
                let horizontalFractionComplete = horizontalDragFraction(movement: movement)
                activeCardsAnimator?.fractionComplete = horizontalFractionComplete
                
                if let currentHoldCardModel = currentHoldCardModel {
                    let rotationAngle = rotationAngle(movement: movement)
                    let translationTransform = CATransform3DTranslate(CATransform3DIdentity, translation.x, translation.y, .zero)
                    let holdCardTransform = CATransform3DRotate(translationTransform, rotationAngle, 0, 0, 1)
                    
                    currentHoldCardModel.cardView.layer.transform = holdCardTransform
                    
                    currentHoldCardModel.dragOutMovement = movement
                    
                    delegateForMovementCard(model: currentHoldCardModel, translation: translation)
                }
            case .ended, .cancelled:
                if shouldDragOut(movement: movement) {
                    // Drag out
                    activeCardsAnimator?.fractionComplete = 1.0
                    
                    if let currentHoldCardModel = currentHoldCardModel {
                        dragOutCardModels.append(currentHoldCardModel)
                    }
                    currentHoldCardModel = nil
                    
                    addPanGestureForTopCard()
                    addTapGestureForTopCard()
                    
                    dragOut()
                } else {
                    // Restore
                    activeCardsAnimator?.stopAnimation(true)
                    activeCardsAnimator?.finishAnimation(at: .current)
                    activeCardsAnimator = nil
                    
                    restoreCard()
                }
            default:
                break
        }
    }
}

extension CardEngine {
    @objc private func handleTap(_ recognizer: TapGestureRecognizer) {
        delegateForTapTopCard()
    }
}
