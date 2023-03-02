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
    internal let cardSpacing: CGFloat
    internal let infiniteLoop: Bool
    internal let allowedDirection: Direction
    internal let minimumTranslationInPercent: CGFloat
    internal let minimumVelocityInPointPerSecond: CGFloat
    internal let cardRotationMaximumAngle: CGFloat
    internal let minimumScale: CGFloat
    
    internal let numberOfCount: Int
    internal let normalCardSize: CGSize
    internal let basicInfos: [BasicInfo]
    
    internal var minimumBasicInfo: BasicInfo {
        assert(!basicInfos.isEmpty, "")
        return basicInfos.last!
    }
    
    internal var maximumBasicInfo: BasicInfo {
        assert(!basicInfos.isEmpty, "")
        return basicInfos.first!
    }
    
    internal init(modeState: ModeState) {
        let numberOfCount = modeState.cardDataSource.numberOfCount(modeState.cardContainer)
        assert(numberOfCount >= 0, "`numberOfCount` must be greater or equal to 0")
        self.numberOfCount = numberOfCount
        
        let visibleCount = modeState.cardContainer.visibleCount
        assert(visibleCount > 0, "`visibleCount` must be greater than 0")
        self.visibleCount = visibleCount
        
        let cardSpacing = modeState.cardContainer.cardSpacing
        assert(!cardSpacing.isLessThanOrEqualTo(.zero), "`cardSpacing` must be greater than 0")
        self.cardSpacing = cardSpacing
        
        let minimumScale = modeState.cardContainer.minimumScale
        assert(minimumScale.isLessThanOrEqualTo(1.0), "`minimumScale` must be less than or equal to 1.0")
        
        var magnitudeScale: CGFloat
        if visibleCount <= 1 {
            magnitudeScale = 1
        } else {
            magnitudeScale = CGFloat(1.0 - minimumScale) / CGFloat(visibleCount - 1)
        }
        self.minimumScale = minimumScale
        
        self.infiniteLoop = modeState.cardContainer.infiniteLoop
        self.allowedDirection = modeState.cardContainer.allowedDirection
        self.minimumTranslationInPercent = modeState.cardContainer.minimumTranslationInPercent
        self.minimumVelocityInPointPerSecond = modeState.cardContainer.minimumVelocityInPointPerSecond
        self.cardRotationMaximumAngle = modeState.cardContainer.cardRotationMaximumAngle
        
        let normalCardWidth = modeState.cardContainer.bounds.width
        let normalCardHeight = modeState.cardContainer.bounds.height - (CGFloat(visibleCount - 1) * CGFloat(cardSpacing))
        self.normalCardSize = CGSize(width: normalCardWidth, height: normalCardHeight)
        
        var basicInfos: [BasicInfo] = []
        for i in 0..<visibleCount {
            let anchorPoint = CGPoint(x: 0.5, y: 1.0)
            let scale = 1.0 - magnitudeScale * CGFloat(i)
            let basicInfo = BasicInfo(transform: CGAffineTransform(scaleX: scale, y: scale),
                                      frame: CGRect(x: .zero,
                                                    y: cardSpacing * CGFloat(i),
                                                    width: normalCardWidth,
                                                    height: normalCardHeight),
                                      anchorPoint: anchorPoint)
            basicInfos.append(basicInfo)
        }
        self.basicInfos = basicInfos
    }
    
    internal static let `default` = Metrics(visibleCount: Default.visibleCount,
                                            cardSpacing: Default.cardSpacing,
                                            infiniteLoop: Default.infiniteLoop,
                                            allowedDirection: Default.allowedDirection,
                                            minimumTranslationInPercent: Default.minimumTranslationInPercent,
                                            minimumVelocityInPointPerSecond: Default.minimumVelocityInPointPerSecond,
                                            cardRotationMaximumAngle: Default.cardRotationMaximumAngle,
                                            minimumScale: Default.minimumScale,
                                            numberOfCount: 0,
                                            normalCardSize: .zero,
                                            basicInfos: [])
    
    private init(visibleCount: Int,
                 cardSpacing: CGFloat,
                 infiniteLoop: Bool,
                 allowedDirection: Direction,
                 minimumTranslationInPercent: CGFloat,
                 minimumVelocityInPointPerSecond: CGFloat,
                 cardRotationMaximumAngle: CGFloat,
                 minimumScale: CGFloat,
                 numberOfCount: Int,
                 normalCardSize: CGSize,
                 basicInfos: [BasicInfo]) {
        self.visibleCount = visibleCount
        self.cardSpacing = cardSpacing
        self.infiniteLoop = infiniteLoop
        self.allowedDirection = allowedDirection
        self.minimumTranslationInPercent = minimumTranslationInPercent
        self.minimumVelocityInPointPerSecond = minimumVelocityInPointPerSecond
        self.cardRotationMaximumAngle = cardRotationMaximumAngle
        self.minimumScale = minimumScale
        self.numberOfCount = numberOfCount
        self.normalCardSize = normalCardSize
        self.basicInfos = basicInfos
    }
}
