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
    internal let mode: Mode
    internal let infiniteLoop: Bool
    internal let allowedDirection: Direction
    internal let minimumTranslationInPercent: CGFloat
    internal let minimumVelocityInPointPerSecond: CGFloat
    internal let cardRotationMaximumAngle: CGFloat
    
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
        
        self.mode = engine.cardContainer.mode
        self.infiniteLoop = engine.cardContainer.infiniteLoop
        self.allowedDirection = engine.cardContainer.allowedDirection
        self.minimumTranslationInPercent = engine.cardContainer.minimumTranslationInPercent
        self.minimumVelocityInPointPerSecond = engine.cardContainer.minimumVelocityInPointPerSecond
        self.cardRotationMaximumAngle = engine.cardContainer.cardRotationMaximumAngle
        
        self.basicInfos = mode.basicInfos(visibleCount: visibleCount,
                                          containerSize: engine.cardContainer.bounds.size)
    }
    
    internal static let `default` = Metrics(visibleCount: Default.visibleCount,
                                            mode: Default.mode,
                                            infiniteLoop: Default.infiniteLoop,
                                            allowedDirection: Default.allowedDirection,
                                            minimumTranslationInPercent: Default.minimumTranslationInPercent,
                                            minimumVelocityInPointPerSecond: Default.minimumVelocityInPointPerSecond,
                                            cardRotationMaximumAngle: Default.cardRotationMaximumAngle,
                                            numberOfCards: 0,
                                            basicInfos: [])
    
    private init(visibleCount: Int,
                 mode: Mode,
                 infiniteLoop: Bool,
                 allowedDirection: Direction,
                 minimumTranslationInPercent: CGFloat,
                 minimumVelocityInPointPerSecond: CGFloat,
                 cardRotationMaximumAngle: CGFloat,
                 numberOfCards: Int,
                 basicInfos: [BasicInfo]) {
        self.visibleCount = visibleCount
        self.mode = mode
        self.infiniteLoop = infiniteLoop
        self.allowedDirection = allowedDirection
        self.minimumTranslationInPercent = minimumTranslationInPercent
        self.minimumVelocityInPointPerSecond = minimumVelocityInPointPerSecond
        self.cardRotationMaximumAngle = cardRotationMaximumAngle
        self.numberOfCards = numberOfCards
        self.basicInfos = basicInfos
    }
}
