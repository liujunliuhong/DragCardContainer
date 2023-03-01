//
//  ModeState.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/2/27.
//

import Foundation
import UIKit


internal final class ModeState {
    
    private var basicInfos: [BasicInfo] = []
    private weak var weakCardContainer: DragCardContainer?
    
    private var displayCardIndex: Int = 0
    private var cardModels: [CardModel] = []
    
    private var currentHoldCardModel: CardModel?
    private var gestureChangeAnimator: UIViewPropertyAnimator?
    
    internal lazy var metrics: Metrics = {
        let metrics = Metrics(modeState: self)
        return metrics
    }()
    
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
        
        let displayCount = min(metrics.visibleCount, metrics.numberOfCount)
        
        for i in 0..<displayCount {
            installNextCard()
            if i != displayCount - 1 {
                incrementDisplayIndex()
            }
        }
        
        updateAllCardModelsTargetBasicInfo()
        
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
            for model in self.cardModels {
                model.cardView.transform = model.targetBasicInfo.transform
            }
        }
        animator.startAnimation()
        
    }
    
    internal func installNextCard() {
        if !canInstallNextCard() {
            return
        }
        
        let cardView = cardDataSource.dragCard(cardContainer, viewForCard: displayCardIndex)
        
        cardView.layer.anchorPoint = metrics.minimumBasicInfo.anchorPoint
        cardView.frame = metrics.minimumBasicInfo.frame
        cardView.transform = metrics.minimumBasicInfo.transform
        cardContainer.insertSubview(cardView, at: 0)
        
        let cardModel = CardModel(cardView: cardView, modeState: self)
        cardModels.insert(cardModel, at: 0)
    }
    
    private func restoreCard() {
        guard let currentHoldCardModel = currentHoldCardModel else {
            return
        }
        if !canRestoreCard() {
            return
        }
        restoreDisplayIndex()
        cardModels.append(currentHoldCardModel)
        
        updateAllCardModelsTargetBasicInfo()
        
        let animator = UIViewPropertyAnimator(duration: 0.25, dampingRatio: 0.5) {
            for model in self.cardModels {
                model.cardView.transform = model.targetBasicInfo.transform
            }
        }
        animator.startAnimation()
    }
    
    
    internal func incrementDisplayIndex() {
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
    
    internal func restoreDisplayIndex() {
        if !canRestoreCard() {
            return
        }
        if displayCardIndex <= 0 {
            if metrics.infiniteLoop {
                displayCardIndex = metrics.numberOfCount - 1
            }
        } else {
            displayCardIndex = displayCardIndex - 1
        }
    }
    
    private func canRestoreCard() -> Bool {
        if displayCardIndex <= 0 {
            if metrics.infiniteLoop {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    internal func canInstallNextCard() -> Bool {
        if metrics.infiniteLoop {
            return true
        }
        if displayCardIndex >= metrics.numberOfCount - 1 {
            return false
        }
        return true
    }
    
    internal func updateAllCardModelsTargetBasicInfo() {
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
        let bounds = cardContainer.bounds
        
        func areTranslationAndVelocityInTheSameDirection() -> Bool {
            return CGPoint.areInSameTheDirection(translation, p2: velocity)
        }
        func isDirectionAllowed() -> Bool {
            return Direction.fromPoint(translation).intersection(metrics.allowedDirection) != .none
        }
        func isTranslationLargeEnough() -> Bool {
            return abs(translation.x) > metrics.minimumTranslationInPercent * bounds.width || abs(translation.y) > metrics.minimumTranslationInPercent * bounds.height
        }
        func isVelocityLargeEnough() -> Bool {
            return velocity.magnitude > metrics.minimumVelocityInPointPerSecond
        }
        return isDirectionAllowed() && areTranslationAndVelocityInTheSameDirection() && (isTranslationLargeEnough() || isVelocityLargeEnough())
    }
}

extension ModeState {
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: cardContainer)
        let location = recognizer.location(in: cardContainer)
        let velocity = recognizer.velocity(in: cardContainer)
        
        let movement = Movement(location: location, translation: translation, velocity: velocity)
        
        switch recognizer.state {
            case .began:
                print("begin")
                
                currentHoldCardModel = cardModels.last
                cardModels.removeLast() // remove last
                
                incrementDisplayIndex()
                installNextCard()
                
                updateAllCardModelsTargetBasicInfo()
                
                
                gestureChangeAnimator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut, animations: {
                    for model in self.cardModels {
                        model.cardView.transform = model.targetBasicInfo.transform
                    }
                })
                
            case .changed:
                print("changed")
                // rotate and translate
                
            case .ended:
                print("ended")
                if shouldDragOut(movement: movement) {
                    // Drag out
                } else {
                    // Restore
                    restoreCard()
                }
            case .cancelled:
                print("cancelled")
                // Restore
                restoreCard()
            default:
                break
        }
    }
}
