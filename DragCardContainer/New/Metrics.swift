//
//  Metrics.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/3/1.
//

import Foundation
import UIKit

internal final class Metrics {
    
    internal let numberOfCount: Int
    internal let visibleCount: Int
    internal let cardSpacing: CGFloat
    internal let infiniteLoop: Bool
    internal let allowedDirection: Direction
    internal let minimumTranslationInPercent: CGFloat
    internal let minimumVelocityInPointPerSecond: CGFloat
    internal let cardRotationMaximumAngle: CGFloat
    internal let minimumScale: CGFloat
    internal let magnitudeScale: CGFloat
    internal let normalCardSize: CGSize
    internal let normalCardFrame: CGRect
    internal let basicInfos: [BasicInfo]
    
    internal var minimumBasicInfo: BasicInfo {
        return basicInfos.last!
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
        let magnitudeScale = CGFloat(1.0 - minimumScale) / CGFloat(visibleCount - 1)
        self.minimumScale = minimumScale
        self.magnitudeScale = magnitudeScale
        
        self.infiniteLoop = modeState.cardContainer.infiniteLoop
        self.allowedDirection = modeState.cardContainer.allowedDirection
        self.minimumTranslationInPercent = modeState.cardContainer.minimumTranslationInPercent
        self.minimumVelocityInPointPerSecond = modeState.cardContainer.minimumVelocityInPointPerSecond
        self.cardRotationMaximumAngle = cardRotationMaximumAngle
        
        let normalCardWidth = modeState.cardContainer.bounds.width
        let normalCardHeight = modeState.cardContainer.bounds.height - (CGFloat(visibleCount - 1) * CGFloat(cardSpacing))
        self.normalCardSize = CGSize(width: normalCardWidth, height: normalCardHeight)
        self.normalCardFrame = CGRect(origin: .zero, size: normalCardSize)
        
        var basicInfos: [BasicInfo] = []
        for i in 0..<visibleCount {
            let anchorPoint = CGPoint(x: 0.5, y: 1.0)
            let scale = 1.0 - magnitudeScale * CGFloat(i)
            let basicInfo = BasicInfo(transform: CGAffineTransform(scaleX: scale, y: scale),
                                      frame: normalCardFrame,
                                      anchorPoint: anchorPoint)
            basicInfos.append(basicInfo)
        }
        self.basicInfos = basicInfos
    }
}
