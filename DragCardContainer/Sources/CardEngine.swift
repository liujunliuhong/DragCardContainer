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
    
    private var currentResetCardModel: CardModel?
    private var willOutModels: [CardModel] = []
    
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
            fatalError("`cardContainer` is `nil`")
        }
        return cardContainer
    }
    
    internal var cardDataSource: DragCardDataSource {
        guard let cardDataSource = cardContainer.dataSource else {
            fatalError("`cardDataSource` is `nil`")
        }
        return cardDataSource
    }
    
    internal init(cardContainer: DragCardContainer) {
        self.weakCardContainer = cardContainer
        setup()
    }
}

extension CardEngine {
    private func setup() {
        
    }
}

extension CardEngine {
    internal func start(forceReset: Bool, animation: Bool) {
        metrics = Metrics(engine: self)
        //
        if forceReset {
            displayCardIndex = 0
        } else {
            displayCardIndex = topIndex ?? 0
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
        
        updateAllCardModelsCurrentBasicInfo()
        updateAllCardModelsTargetBasicInfo()
        
        for model in cardModels {
            model.cardView.removeAllAnimations()
        }
        
        func final() {
            for model in cardModels {
                model.cardView.transform = model.targetBasicInfo.transform
            }
        }
        
        if animation {
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: .curveLinear) {
                final()
            }
        } else {
            final()
        }
        
        addPanGestureForTopCard()
        addTapGestureForTopCard()
        setUserInteractionForTopCard(true)
        
        delegateForDisplayTopCard()
    }
    
    internal func swipeTopCard(to: Direction) {
        guard let topModel = cardModels.last else { return }
        
        willOutModels.append(topModel)
        
        let duration = swipeDuration(for: topModel.cardView, direction: to, forced: true)
        
        topModel.cardView.isOld = true
        topModel.cardView.swipe(to: to)
        
        delegateForRemoveTopCard(model: topModel, direction: to)
        delegateForFinishRemoveLastCard(model: topModel)
        
        removePanGesture(topModel.cardView)
        removeTapGesture(topModel.cardView)
        
        updateAllCardModelsCurrentBasicInfo()
        
        cardModels.removeLast()
        
        addPanGestureForTopCard()
        addTapGestureForTopCard()
        setUserInteractionForTopCard(true)
        
        incrementDisplayIndex()
        installNextCard()
        
        delegateForDisplayTopCard()
        
        updateAllCardModelsTargetBasicInfo()
        
        for model in cardModels {
            model.cardView.removeAllAnimations()
        }
        
        let delay = swipeDelay(for: topModel.cardView, forced: true)
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: [.curveLinear, .allowUserInteraction]) {
            for model in self.cardModels {
                model.cardView.transform = model.targetBasicInfo.transform
            }
        }
    }
    
    internal func rewind(from: Direction) {
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
        
        let cardView = cardDataSource.dragCard(cardContainer, viewForCard: index)
        
        cardView.layer.anchorPoint = metrics.cardAnchorPoint
        cardView.frame = metrics.cardFrame
        cardView.transform = .identity
        cardView.delegate = self
        cardContainer.containerView.addSubview(cardView)
        
        cardView.rewind(from: from)
        
        let cardModel = CardModel(cardView: cardView, index: index)
        cardModel.currentBasicInfo = metrics.maximumBasicInfo
        
        currentResetCardModel = cardModel
        
        restoreAllCards()
    }
}

extension CardEngine {
    internal func setUserInteractionForTopCard(_ isEnabled: Bool) {
        guard let topModel = cardModels.last else { return }
        topModel.cardView.isUserInteractionEnabled = isEnabled
    }
    
    internal func addPanGestureForTopCard() {
        guard let topModel = cardModels.last else { return }
        addPanGesture(topModel.cardView)
    }
    
    internal func addTapGestureForTopCard() {
        guard let topModel = cardModels.last else { return }
        addTapGesture(topModel.cardView)
    }
    
    internal func removePanGestureForTopCard() {
        guard let topModel = cardModels.last else { return }
        removePanGesture(topModel.cardView)
    }
    
    internal func removeTapGestureForTopCard() {
        guard let topModel = cardModels.last else { return }
        removeTapGesture(topModel.cardView)
    }
    
    private func removePanGesture(_ cardView: DragCardView) {
        cardView.removePanGesture()
    }
    
    private func removeTapGesture(_ cardView: DragCardView) {
        cardView.removeTapGesture()
    }
    
    private func addPanGesture(_ cardView: DragCardView) {
        cardView.removePanGesture()
        cardView.addPanGesture()
    }
    
    private func addTapGesture(_ cardView: DragCardView) {
        cardView.removeTapGesture()
        cardView.addTapGesture()
    }
}

extension CardEngine {
    private func flush() {
        for model in cardModels {
            model.cardView.removeAllAnimations()
            model.cardView.removeFromSuperview()
        }
        cardModels.removeAll()
        //
        if let currentResetCardModel = currentResetCardModel {
            currentResetCardModel.cardView.isOld = true
        }
        currentResetCardModel = nil
        //
        willOutModels.forEach { model in
            model.cardView.isOld = true
        }
        willOutModels.removeAll()
    }
    
    private func installNextCard() {
        if !canInstallNextCard() {
            return
        }
        
        let index = displayCardIndex
        
        let cardView = cardDataSource.dragCard(cardContainer, viewForCard: index)
        
        cardView.layer.anchorPoint = metrics.cardAnchorPoint
        cardView.frame = metrics.cardFrame
        cardView.transform = metrics.minimumBasicInfo.transform
        cardView.delegate = self
        cardView.isUserInteractionEnabled = false
        cardContainer.containerView.insertSubview(cardView, at: 0)
        
        let cardModel = CardModel(cardView: cardView, index: index)
        cardModel.currentBasicInfo = metrics.minimumBasicInfo
        cardModels.insert(cardModel, at: 0)
    }
    
    private func restoreAllCards() {
        guard let currentResetCardModel = currentResetCardModel else {
            return
        }
        if !canRestoreCard() {
            return
        }
        
        let duration = currentResetCardModel.cardView.totalRewindDuration / 2.0
        
        removePanGestureForTopCard()
        removeTapGestureForTopCard()
        setUserInteractionForTopCard(false)
        
        restoreDisplayIndex()
        
        updateAllCardModelsCurrentBasicInfo()
        
        cardModels.append(currentResetCardModel)
        
        updateAllCardModelsTargetBasicInfo()
        
        for model in cardModels {
            if model != currentResetCardModel {
                model.cardView.removeAllAnimations()
            }
        }
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: [.curveLinear, .allowUserInteraction]) {
            for model in self.cardModels {
                if model != currentResetCardModel {
                    model.cardView.transform = model.targetBasicInfo.transform
                }
            }
        } completion: { finished in
            if !finished { return }
            if self.cardModels.count > self.metrics.visibleCount {
                
                let tmpModels = Array(self.cardModels.suffix(self.metrics.visibleCount))
                
                let willRemoveModels = Array(self.cardModels.prefix(self.cardModels.count - self.metrics.visibleCount))
                for model in willRemoveModels {
                    model.cardView.removeFromSuperview()
                }
                
                self.cardModels = tmpModels
            }
            self.currentResetCardModel = nil
        }
        
        addPanGestureForTopCard()
        addTapGestureForTopCard()
        setUserInteractionForTopCard(true)
        
        delegateForDisplayTopCard()
    }
    
    private func updateAllCardModelsCurrentBasicInfo() {
        for model in cardModels {
            model.currentBasicInfo = metrics.minimumBasicInfo
        }
        
        let needModifyModels = cardModels.suffix(metrics.visibleCount).reversed()
        for (i, model) in needModifyModels.enumerated() {
            model.currentBasicInfo = metrics.basicInfos[i]
        }
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
    
    private func swipeDelay(for card: DragCardView, forced: Bool) -> TimeInterval {
        let duration = card.totalSwipeDuration
        let relativeOverlayDuration = card.relativeSwipeOverlayFadeDuration
        let delay = duration * TimeInterval(relativeOverlayDuration)
        return forced ? delay : 0
    }
    
    private func swipeDuration(for card: DragCardView, direction: Direction, forced: Bool) -> TimeInterval {
        return card.finalDuration(direction, forced: forced) / 2.0
    }
}

extension CardEngine {
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
//            if displayCardIndex > 0 && displayCardIndex <= metrics.numberOfCards - 1 {
                displayCardIndex = displayCardIndex - 1
//            }
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
}

extension CardEngine: CardDelegate {
    internal func cardDidBeginSwipe(_ card: DragCardView) {
        if cardModels.isEmpty { return }
        
        if card.isOld { return }
        
        updateAllCardModelsCurrentBasicInfo()
        
        currentResetCardModel = cardModels.last
        
        cardModels.removeLast() // remove last
        
        incrementDisplayIndex()
        installNextCard()
        
        updateAllCardModelsTargetBasicInfo()
        
        for model in cardModels {
            model.cardView.removeAllAnimations()
        }
    }
    
    internal func cardDidContinueSwipe(_ card: DragCardView) {
        if card.isOld { return }
        
        let panTranslation = card.panGestureRecognizer?.translation(in: card.superview) ?? .zero
        let minimumSideLength = min(cardContainer.bounds.width, cardContainer.bounds.height)
        let percentage = min(abs(panTranslation.x) / minimumSideLength, 1)
        
        for model in cardModels {
            let scale = model.currentBasicInfo.scale + (model.targetBasicInfo.scale - model.currentBasicInfo.scale) * percentage
            let translation = model.currentBasicInfo.translation + (model.targetBasicInfo.translation - model.currentBasicInfo.translation) * percentage
            
            let t1 = CGAffineTransform(translationX: translation.x, y: translation.y)
            let t2 = t1.scaledBy(x: scale, y: scale)
            
            model.cardView.transform = t2
        }
    }
    
    internal func cardDidCancelSwipe(_ card: DragCardView) {
        if card.isOld { return }
        
        restoreAllCards()
    }
    
    internal func cardDidSwipe(_ card: DragCardView, withDirection direction: Direction) {
        if card.isOld { return }
        
        let duration = swipeDuration(for: card, direction: direction, forced: false)
        
        for model in cardModels {
            model.cardView.removeAllAnimations()
        }
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: [.curveLinear, .allowUserInteraction]) {
            for model in self.cardModels {
                model.cardView.transform = model.targetBasicInfo.transform
            }
        }
        
        delegateForDisplayTopCard()
        
        if let currentResetCardModel = currentResetCardModel {
            delegateForRemoveTopCard(model: currentResetCardModel, direction: direction)
            delegateForFinishRemoveLastCard(model: currentResetCardModel)
            
            willOutModels.append(currentResetCardModel)
        }
        currentResetCardModel = nil
        
        addPanGestureForTopCard()
        addTapGestureForTopCard()
        setUserInteractionForTopCard(true)
    }
    
    internal func cardDidDragout(_ card: DragCardView) {
        for (index, model) in willOutModels.enumerated() {
            if model.cardView.identifier == card.identifier {
                card.removeFromSuperview()
                willOutModels.remove(at: index)
                break
            }
        }
        
        print("😄\(displayCardIndex)")
    }
    
    internal func cardDidTap(_ card: DragCardView) {
        if card.isOld { return }
        
        delegateForTapTopCard()
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
    
    private func delegateForRemoveTopCard(model: CardModel, direction: Direction) {
        cardContainer.delegate?.dragCard(cardContainer,
                                         didRemovedTopCardAt: model.index,
                                         direction: direction,
                                         with: model.cardView)
    }
}
