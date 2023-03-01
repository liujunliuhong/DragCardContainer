//
//  Default.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/3/1.
//

import Foundation

internal struct Default {
    internal static let minimumTranslationInPercent: CGFloat = 0.5
    internal static let minimumVelocityInPointPerSecond: CGFloat = 750
    internal static let cardRotationMaximumAngle: CGFloat = 20.0
    internal static let allowedDirection = Direction.horizontal
    internal static let infiniteLoop: Bool = false
    internal static let minimumScale: CGFloat = 0.8
    internal static let cardSpacing: CGFloat = 10.0
    internal static let visibleCount: Int = 3
    internal static let animationDuration: TimeInterval = 0.25
}
