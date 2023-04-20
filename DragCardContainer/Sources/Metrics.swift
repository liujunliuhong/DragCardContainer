//
//  Metrics.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/3/1.
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

internal final class Metrics {
    internal let visibleCount: Int
    internal let infiniteLoop: Bool
    
    internal let cardAnchorPoint: CGPoint
    internal let cardFrame: CGRect
    
    internal let numberOfCards: Int
    internal let basicInfos: [BasicInfo]
    
    internal var minimumBasicInfo: BasicInfo {
        assert(!basicInfos.isEmpty, "`basicInfos` can not empty")
        return basicInfos.last!
    }
    
    internal var maximumBasicInfo: BasicInfo {
        assert(!basicInfos.isEmpty, "`basicInfos` can not empty")
        return basicInfos.first!
    }
    
    internal init(engine: CardEngine) {
        let numberOfCards = engine.cardDataSource.numberOfCards(engine.cardContainer)
        assert(numberOfCards >= 0, "`numberOfCards` must be greater or equal to 0")
        self.numberOfCards = numberOfCards
        
        let visibleCount = engine.cardContainer.visibleCount
        assert(visibleCount > 0, "`visibleCount` must be greater than 0")
        self.visibleCount = visibleCount
        
        let mode = engine.cardContainer.mode
        self.infiniteLoop = engine.cardContainer.infiniteLoop
        
        self.basicInfos = mode.basicInfos(visibleCount: visibleCount,
                                          containerSize: engine.cardContainer.bounds.size)
        self.cardAnchorPoint = mode.cardAnchorPoint()
        self.cardFrame = mode.cardFrame(visibleCount: visibleCount, containerSize: engine.cardContainer.bounds.size)
    }
    
    internal static let `default` = Metrics(visibleCount: Default.visibleCount,
                                            infiniteLoop: Default.infiniteLoop,
                                            cardAnchorPoint: Default.cardAnchorPoint,
                                            cardFrame: Default.cardFrame,
                                            numberOfCards: 0,
                                            basicInfos: [])
    
    private init(visibleCount: Int,
                 infiniteLoop: Bool,
                 cardAnchorPoint: CGPoint,
                 cardFrame: CGRect,
                 numberOfCards: Int,
                 basicInfos: [BasicInfo]) {
        self.visibleCount = visibleCount
        self.infiniteLoop = infiniteLoop
        self.cardAnchorPoint = cardAnchorPoint
        self.cardFrame = cardFrame
        self.numberOfCards = numberOfCards
        self.basicInfos = basicInfos
    }
}
