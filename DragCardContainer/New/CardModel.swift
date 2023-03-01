//
//  CardModel.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/3/1.
//

import Foundation
import UIKit

internal final class CardModel {
    internal let cardView: UIView
    
    internal var targetBasicInfo: BasicInfo = .default
    
    internal var modeState: ModeState {
        guard let modeState = weakModeState else {
            fatalError("")
        }
        return modeState
    }
    
    private weak var weakModeState: ModeState?
    
    
    
    private var animator: UIViewPropertyAnimator?
    
    
    internal init(cardView: UIView, modeState: ModeState) {
        self.cardView = cardView
        self.weakModeState = modeState
    }
}

extension CardModel {
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: modeState.cardContainer)
        let location = recognizer.location(in: modeState.cardContainer)
        let velocity = recognizer.velocity(in: modeState.cardContainer)
        
        switch recognizer.state {
            case .began:
                print("begin")
                if modeState.canInstallNextCard() {
                    modeState.incrementDisplayIndex()
                    modeState.installNextCard()
                    modeState.updateAllCardModelsTargetBasicInfo()
                }
            case .changed:
                print("changed")
                
            case .ended:
                print("ended")
                
            case .cancelled:
                print("cancelled")
            default:
                break
        }
    }
}
