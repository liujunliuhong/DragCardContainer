//
//  ModeState.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/2/27.
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


internal final class ModeState {
    
    deinit {
        flush()
    }
    
    private weak var weakCardContainer: DragCardContainer?
    
    private var displayCardIndex: Int = 0
    
    private var cardModels: [CardModel] = []
    private var dragOutCardModels: [CardModel] = []
    
    private var currentHoldCardModel: CardModel?
    private var activeCardsAnimator: UIViewPropertyAnimator?
    
    private var metrics: Metrics = .default
    
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

extension ModeState {
    internal func prepare() {
        flush()
        //
        metrics = Metrics(modeState: self)
        //
        let displayCount = min(metrics.visibleCount, metrics.numberOfCount)
        for i in 0..<displayCount {
            installNextCard()
            if i != displayCount - 1 {
                incrementDisplayIndex()
            }
        }
        
        updateAllCardModelsTargetBasicInfo()
        
        let animator = UIViewPropertyAnimator(duration: Default.animationDuration,
                                              curve: .easeInOut) {
            for model in self.cardModels {
                model.cardView.transform = .identity
                model.cardView.frame = model.targetBasicInfo.frame
                model.cardView.transform = model.targetBasicInfo.transform
            }
        }
        animator.startAnimation()
        
        addPanGestureForTopCard()
        addTapGestureForTopCard()
        
        delegateForDisplayTopCard()
    }
    
    internal func swipeTopCard(to: Direction) {
        if metrics.allowedDirection.intersection(to) == .none {
            return
        }
        
        if let dragOutCardModel = cardModels.last {
            dragOutCardModel.dragOutMovement = endMovement(direction: to)
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
        
        activeCardsAnimator = UIViewPropertyAnimator(duration: Default.animationDuration,
                                                     curve: .easeInOut,
                                                     animations: {
            for model in self.cardModels {
                model.cardView.transform = .identity
                model.cardView.frame = model.targetBasicInfo.frame
                model.cardView.transform = model.targetBasicInfo.transform
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
                    index = metrics.numberOfCount - 1
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
            index = metrics.numberOfCount - 1
        }
        
        
        if index > metrics.numberOfCount - 1 {
            return
        }
        
        let endMovement = endMovement(direction: from)
        let endTransform = endTransform(movement: endMovement)
        
        let cardView = cardDataSource.dragCard(cardContainer, viewForCard: index)
        
        cardView.layer.anchorPoint = metrics.maximumBasicInfo.anchorPoint
        cardView.transform = .identity
        cardView.frame = metrics.maximumBasicInfo.frame
        cardView.transform = endTransform
        cardContainer.containerView.addSubview(cardView)
        
        let cardModel = CardModel(cardView: cardView, index: index)
        
        currentHoldCardModel = cardModel
        
        restoreCard()
    }
}

extension ModeState {
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
        //
        displayCardIndex = 0
    }
    
    private func installNextCard() {
        if !canInstallNextCard() {
            return
        }
        
        let index = displayCardIndex
        
        let cardView = cardDataSource.dragCard(cardContainer, viewForCard: index)
        
        cardView.layer.anchorPoint = metrics.minimumBasicInfo.anchorPoint
        cardView.transform = .identity
        cardView.frame = metrics.minimumBasicInfo.frame
        cardView.transform = metrics.minimumBasicInfo.transform
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
                                              dampingRatio: 0.8) {
            for model in self.cardModels {
                model.cardView.transform = .identity
                model.cardView.frame = model.targetBasicInfo.frame
                model.cardView.transform = model.targetBasicInfo.transform
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
            if displayCardIndex >= metrics.numberOfCount - 1 {
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
                displayCardIndex = metrics.numberOfCount - 1
            } else {
                displayCardIndex = displayCardIndex - 1
            }
        } else {
            if displayCardIndex > 0 && displayCardIndex <= metrics.numberOfCount - 1 {
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
        if displayCardIndex >= 0 && displayCardIndex <= metrics.numberOfCount - 1 {
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
        //        print("direction: \(Direction.fromPoint(translation))")
        //        print("isDirectionAllowed: \(isDirectionAllowed())")
        //        print("isTranslationLargeEnough: \(isTranslationLargeEnough())")
        
        return isDirectionAllowed() && (isTranslationLargeEnough() || isVelocityLargeEnough())
    }
    
    private func dragFraction(movement: Movement) -> CGFloat {
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
        return (fraction * metrics.cardRotationMaximumAngle).radius
    }
    
    private func removePanGestureForTopCard() {
        if let topModel = cardModels.last {
            removePanGesture(topModel.cardView)
        }
    }
    
    private func removePanGesture(_ cardView: UIView) {
        for gesture in (cardView.gestureRecognizers ?? []) {
            if gesture.isKind(of: PanGestureRecognizer.classForCoder()) {
                cardView.removeGestureRecognizer(gesture)
            }
        }
    }
    
    private func removeTapGestureForTopCard() {
        if let topModel = cardModels.last {
            removeTapGesture(topModel.cardView)
        }
    }
    
    private func removeTapGesture(_ cardView: UIView) {
        for gesture in (cardView.gestureRecognizers ?? []) {
            if gesture.isKind(of: TapGestureRecognizer.classForCoder()) {
                cardView.removeGestureRecognizer(gesture)
            }
        }
    }
    
    private func addPanGestureForTopCard() {
        if let topModel = cardModels.last {
            addPanGesture(topModel.cardView)
        }
    }
    
    private func addPanGesture(_ cardView: UIView) {
        removePanGesture(cardView)
        let panGesture = PanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        cardView.addGestureRecognizer(panGesture)
    }
    
    private func addTapGestureForTopCard() {
        if let topModel = cardModels.last {
            addTapGesture(topModel.cardView)
        }
    }
    
    private func addTapGesture(_ cardView: UIView) {
        removeTapGesture(cardView)
        let tapGesture = TapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        cardView.addGestureRecognizer(tapGesture)
    }
    
    private func endMovement(direction: Direction) -> Movement {
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
                                                             y: -0.5),
                                        velocity: CGPoint(x: metrics.minimumVelocityInPointPerSecond,
                                                          y: 0))
                return movement
            case .left:
                let movement = Movement(translation: CGPoint(x: -1,
                                                             y: -0.5),
                                        velocity: CGPoint(x: -metrics.minimumVelocityInPointPerSecond,
                                                          y: 0))
                return movement
            default:
                return .default
        }
    }
    
    private func endTransform(movement: Movement) -> CGAffineTransform {
        let toTranslation = finalTranslation(movement: movement)
        let translationTransform = CGAffineTransform(translationX: toTranslation.x, y: toTranslation.y)
        
        print("😄\(toTranslation)")
        
        let rotationTransform = CGAffineTransform(rotationAngle: metrics.cardRotationMaximumAngle.radius)
        
        let transform = translationTransform.concatenating(rotationTransform)
        
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
            
            //let initialSpringVelocity = dragOutMovement.velocity.magnitude
            
            let transform = endTransform(movement: dragOutMovement)
            
            UIView.animate(withDuration: Default.animationDuration * 2.0,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                model.cardView.transform = transform
                
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

extension ModeState {
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
        if model.index == metrics.numberOfCount - 1 && !metrics.infiniteLoop {
            cardContainer.delegate?.dragCard(cardContainer,
                                             didFinishRemoveLast: model.cardView)
        }
    }
    
    private func delegateForRemoveTopCard(model: CardModel) {
        let direction = Direction.fromPoint(model.dragOutMovement.translation)
        cardContainer.delegate?.dragCard(cardContainer,
                                         didRemoveTopCardAt: model.index,
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

extension ModeState {
    @objc private func handlePan(_ recognizer: PanGestureRecognizer) {
        let translation = recognizer.translation(in: cardContainer.containerView)
        //let location = recognizer.location(in: cardContainer.containerView)
        let velocity = recognizer.velocity(in: cardContainer.containerView)
        
        let movement = Movement(translation: translation, velocity: velocity)
        
        switch recognizer.state {
            case .began:
                print("begin")
                
                currentHoldCardModel = cardModels.last
                cardModels.removeLast() // remove last
                
                incrementDisplayIndex()
                installNextCard()
                
                updateAllCardModelsTargetBasicInfo()
                
                activeCardsAnimator?.stopAnimation(false)
                activeCardsAnimator?.finishAnimation(at: .end)
                activeCardsAnimator = UIViewPropertyAnimator(duration: Default.animationDuration,
                                                             curve: .easeInOut,
                                                             animations: {
                    for model in self.cardModels {
                        model.cardView.transform = .identity
                        model.cardView.frame = model.targetBasicInfo.frame
                        model.cardView.transform = model.targetBasicInfo.transform
                    }
                })
                
            case .changed:
                print("changed")
                // rotate and translate
                activeCardsAnimator?.fractionComplete = dragFraction(movement: movement)
                
                if let currentHoldCardModel = currentHoldCardModel {
                    let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
                    
                    let rotationAngle = rotationAngle(movement: movement)
                    let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
                    
                    let holdCardTransform = translationTransform.concatenating(rotationTransform)
                    
                    currentHoldCardModel.cardView.transform = holdCardTransform
                    
                    currentHoldCardModel.dragOutMovement = movement
                    
                    delegateForMovementCard(model: currentHoldCardModel, translation: translation)
                }
            case .ended, .cancelled:
                print("ended or cancelled")
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
                    
                    restoreCard()
                }
            default:
                break
        }
    }
}

extension ModeState {
    @objc private func handleTap(_ recognizer: TapGestureRecognizer) {
        delegateForTapTopCard()
    }
}
