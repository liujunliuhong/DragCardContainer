//
//  Animator.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/3/9.
//

import Foundation
import UIKit


struct Animator {
    internal static func addKeyFrame(withRelativeStartTime relativeStartTime: Double = 0.0,
                                     relativeDuration: Double = 1.0,
                                     animations: @escaping () -> Void) {
        UIView.addKeyframe(withRelativeStartTime: relativeStartTime,
                           relativeDuration: relativeDuration,
                           animations: animations)
    }
    
    internal static func animateKeyFrames(withDuration duration: TimeInterval,
                                          delay: TimeInterval = 0.0,
                                          options: UIView.KeyframeAnimationOptions = [],
                                          animations: @escaping (() -> Void),
                                          completion: ((Bool) -> Void)? = nil) {
        UIView.animateKeyframes(withDuration: duration,
                                delay: delay,
                                options: options,
                                animations: animations,
                                completion: completion)
    }
    
    internal static func animateSpring(withDuration duration: TimeInterval,
                                       delay: TimeInterval = 0.0,
                                       usingSpringWithDamping damping: CGFloat,
                                       initialSpringVelocity: CGFloat = 0.0,
                                       options: UIView.AnimationOptions,
                                       animations: @escaping () -> Void,
                                       completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: options,
                       animations: animations,
                       completion: completion)
    }
}
