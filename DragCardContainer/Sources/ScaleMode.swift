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
    public var cardSpacing: CGFloat = 10.0
    
    /// Minimum card scale.
    public var minimumScale: CGFloat = 0.8
    
    /// Minimum card alpha.
    public var minimumCardAlpha: CGFloat = 1
    
    /// Scale direction.
    public var direction: ScaleMode.Direction = .bottom
    
    public static let `default` = ScaleMode()
    
    public init() {}
}


extension ScaleMode: Mode {
    public func basicInfos(visibleCount: Int, containerSize: CGSize) -> [BasicInfo] {
        assert(minimumScale.isLessThanOrEqualTo(1.0), "`minimumScale` must be less than or equal to 1.0")
        assert(!minimumScale.isLessThanOrEqualTo(.zero), "`minimumScale` must be greater than 0")
        
        if direction != .center {
            assert(!cardSpacing.isLessThanOrEqualTo(.zero), "`cardSpacing` must be greater than 0")
        }
        
        var magnitudeScale: CGFloat
        if visibleCount <= 1 {
            magnitudeScale = 1
        } else {
            magnitudeScale = CGFloat(1.0 - minimumScale) / CGFloat(visibleCount - 1)
        }
        
        var magnitudeAlpha: CGFloat
        if visibleCount <= 1 {
            magnitudeAlpha = 1
        } else {
            magnitudeAlpha = CGFloat(1.0 - minimumCardAlpha) / CGFloat(visibleCount - 1)
        }
        
        
        var basicInfos: [BasicInfo] = []
        
        switch direction {
            case .bottom:
                let normalCardWidth = containerSize.width
                let normalCardHeight = containerSize.height - (CGFloat(visibleCount - 1) * CGFloat(cardSpacing))
                let normalCardFrame = CGRect(x: .zero, y: .zero, width: normalCardWidth, height: normalCardHeight)
                
                for i in 0..<visibleCount {
                    let anchorPoint = CGPoint(x: 0.5, y: 1.0)
                    let scale = 1.0 - magnitudeScale * CGFloat(i)
                    let alpha = 1.0 - magnitudeAlpha * CGFloat(i)
                    
                    let translate = CATransform3DTranslate(CATransform3DIdentity, 0, cardSpacing * CGFloat(i), 0)
                    let transform3D = CATransform3DScale(translate, scale, scale, 1.0)
                    
                    let basicInfo = BasicInfo(transform3D: transform3D,
                                              frame: normalCardFrame,
                                              anchorPoint: anchorPoint,
                                              alpha: alpha)
                    basicInfos.append(basicInfo)
                }
            case .top:
                let normalCardWidth = containerSize.width
                let normalCardHeight = containerSize.height - (CGFloat(visibleCount - 1) * CGFloat(cardSpacing))
                let normalCardFrame = CGRect(x: .zero, y: cardSpacing * CGFloat(visibleCount - 1), width: normalCardWidth, height: normalCardHeight)
                
                for i in 0..<visibleCount {
                    let anchorPoint = CGPoint(x: 0.5, y: 0)
                    let scale = 1.0 - magnitudeScale * CGFloat(i)
                    let alpha = 1.0 - magnitudeAlpha * CGFloat(i)
                    
                    let translate = CATransform3DTranslate(CATransform3DIdentity, 0, -cardSpacing * CGFloat(i), 0)
                    let transform3D = CATransform3DScale(translate, scale, scale, 1.0)
                    
                    let basicInfo = BasicInfo(transform3D: transform3D,
                                              frame: normalCardFrame,
                                              anchorPoint: anchorPoint,
                                              alpha: alpha)
                    basicInfos.append(basicInfo)
                }
            case .left:
                let normalCardWidth = containerSize.width - (CGFloat(visibleCount - 1) * CGFloat(cardSpacing))
                let normalCardHeight = containerSize.height
                let normalCardFrame = CGRect(x: cardSpacing * CGFloat(visibleCount - 1), y: .zero, width: normalCardWidth, height: normalCardHeight)
                
                for i in 0..<visibleCount {
                    let anchorPoint = CGPoint(x: 0, y: 0.5)
                    let scale = 1.0 - magnitudeScale * CGFloat(i)
                    let alpha = 1.0 - magnitudeAlpha * CGFloat(i)
                    
                    let translate = CATransform3DTranslate(CATransform3DIdentity, -cardSpacing * CGFloat(i), 0, 0)
                    let transform3D = CATransform3DScale(translate, scale, scale, 1.0)
                    
                    let basicInfo = BasicInfo(transform3D: transform3D,
                                              frame: normalCardFrame,
                                              anchorPoint: anchorPoint,
                                              alpha: alpha)
                    basicInfos.append(basicInfo)
                }
            case .right:
                let normalCardWidth = containerSize.width - (CGFloat(visibleCount - 1) * CGFloat(cardSpacing))
                let normalCardHeight = containerSize.height
                let normalCardFrame = CGRect(x: .zero, y: .zero, width: normalCardWidth, height: normalCardHeight)
                
                for i in 0..<visibleCount {
                    let anchorPoint = CGPoint(x: 1, y: 0.5)
                    let scale = 1.0 - magnitudeScale * CGFloat(i)
                    let alpha = 1.0 - magnitudeAlpha * CGFloat(i)
                    
                    let translate = CATransform3DTranslate(CATransform3DIdentity, cardSpacing * CGFloat(i), 0, 0)
                    let transform3D = CATransform3DScale(translate, scale, scale, 1.0)
                    
                    let basicInfo = BasicInfo(transform3D: transform3D,
                                              frame: normalCardFrame,
                                              anchorPoint: anchorPoint,
                                              alpha: alpha)
                    basicInfos.append(basicInfo)
                }
            case .center:
                let normalCardWidth = containerSize.width
                let normalCardHeight = containerSize.height
                let normalCardSize = CGSize(width: normalCardWidth, height: normalCardHeight)
                
                for i in 0..<visibleCount {
                    let anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    let scale = 1.0 - magnitudeScale * CGFloat(i)
                    let alpha = 1.0 - magnitudeAlpha * CGFloat(i)
                    
                    let newTransform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1.0)
                    
                    let basicInfo = BasicInfo(transform3D: newTransform3D,
                                              frame: CGRect(x: .zero,
                                                            y: .zero,
                                                            width: normalCardSize.width,
                                                            height: normalCardSize.height),
                                              anchorPoint: anchorPoint,
                                              alpha: alpha)
                    basicInfos.append(basicInfo)
                }
        }
        
        return basicInfos
    }
}
