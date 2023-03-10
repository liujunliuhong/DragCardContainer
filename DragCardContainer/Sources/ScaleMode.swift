//
//  ScaleMode.swift
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
import QuartzCore

public final class ScaleMode {
    
    public enum Direction: Equatable {
        case top
        case bottom
        case left
        case right
        case center
    }
    
    /// Card spacing.
    ///
    /// - Warning: if `direction = .center`. This attribute is ignored.
    public var cardSpacing: CGFloat = 10.0 {
        didSet {
            cardSpacing = max(.zero, cardSpacing)
        }
    }
    
    /// Minimum card scale.
    public var minimumScale: CGFloat = 0.8 {
        didSet {
            minimumScale = max(.zero, min(minimumScale, 1.0))
        }
    }
    
    /// Scale direction.
    public var direction: ScaleMode.Direction = .bottom
    
    public static let `default` = ScaleMode()
    
    public init() {}
}


extension ScaleMode: Mode {
    public func cardAnchorPoint() -> CGPoint {
        switch direction {
            case .bottom:
                return CGPoint(x: 0.5, y: 1.0)
            case .top:
                return CGPoint(x: 0.5, y: 0)
            case .left:
                return CGPoint(x: 0, y: 0.5)
            case .right:
                return CGPoint(x: 1, y: 0.5)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
        }
    }
    
    public func cardFrame(visibleCount: Int, containerSize: CGSize) -> CGRect {
        switch direction {
            case .bottom:
                let normalCardWidth = containerSize.width
                let normalCardHeight = containerSize.height - (CGFloat(visibleCount - 1) * CGFloat(cardSpacing))
                let normalCardFrame = CGRect(x: .zero, y: .zero, width: normalCardWidth, height: normalCardHeight)
                return normalCardFrame
            case .top:
                let normalCardWidth = containerSize.width
                let normalCardHeight = containerSize.height - (CGFloat(visibleCount - 1) * CGFloat(cardSpacing))
                let normalCardFrame = CGRect(x: .zero, y: cardSpacing * CGFloat(visibleCount - 1), width: normalCardWidth, height: normalCardHeight)
                return normalCardFrame
            case .left:
                let normalCardWidth = containerSize.width - (CGFloat(visibleCount - 1) * CGFloat(cardSpacing))
                let normalCardHeight = containerSize.height
                let normalCardFrame = CGRect(x: cardSpacing * CGFloat(visibleCount - 1), y: .zero, width: normalCardWidth, height: normalCardHeight)
                return normalCardFrame
            case .right:
                let normalCardWidth = containerSize.width - (CGFloat(visibleCount - 1) * CGFloat(cardSpacing))
                let normalCardHeight = containerSize.height
                let normalCardFrame = CGRect(x: .zero, y: .zero, width: normalCardWidth, height: normalCardHeight)
                return normalCardFrame
            case .center:
                let normalCardWidth = containerSize.width
                let normalCardHeight = containerSize.height
                let normalCardSize = CGSize(width: normalCardWidth, height: normalCardHeight)
                let normalCardFrame = CGRect(x: .zero, y: .zero, width: normalCardWidth, height: normalCardHeight)
                return normalCardFrame
        }
    }
    
    public func basicInfos(visibleCount: Int, containerSize: CGSize) -> [BasicInfo] {
        var magnitudeScale: CGFloat
        if visibleCount <= 1 {
            magnitudeScale = 1
        } else {
            magnitudeScale = CGFloat(1.0 - minimumScale) / CGFloat(visibleCount - 1)
        }
        
        var basicInfos: [BasicInfo] = []
        
        switch direction {
            case .bottom:
                for i in 0..<visibleCount {
                    let scale = 1.0 - magnitudeScale * CGFloat(i)
                    let translation = CGPoint(x: .zero, y: cardSpacing * CGFloat(i))
                    let basicInfo = BasicInfo(translation: translation, scale: scale)
                    basicInfos.append(basicInfo)
                }
            case .top:
                for i in 0..<visibleCount {
                    let scale = 1.0 - magnitudeScale * CGFloat(i)
                    let translation = CGPoint(x: .zero, y: -cardSpacing * CGFloat(i))
                    let basicInfo = BasicInfo(translation: translation, scale: scale)
                    basicInfos.append(basicInfo)
                }
            case .left:
                for i in 0..<visibleCount {
                    let scale = 1.0 - magnitudeScale * CGFloat(i)
                    let translation = CGPoint(x: -cardSpacing * CGFloat(i), y: .zero)
                    let basicInfo = BasicInfo(translation: translation, scale: scale)
                    basicInfos.append(basicInfo)
                }
            case .right:
                for i in 0..<visibleCount {
                    let scale = 1.0 - magnitudeScale * CGFloat(i)
                    let translation = CGPoint(x: cardSpacing * CGFloat(i), y: .zero)
                    let basicInfo = BasicInfo(translation: translation, scale: scale)
                    basicInfos.append(basicInfo)
                }
            case .center:
                for i in 0..<visibleCount {
                    let scale = 1.0 - magnitudeScale * CGFloat(i)
                    let basicInfo = BasicInfo(translation: .zero, scale: scale)
                    basicInfos.append(basicInfo)
                }
        }
        
        return basicInfos
    }
}
