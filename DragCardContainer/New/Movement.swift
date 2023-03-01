//
//  Movement.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/3/1.
//

import Foundation

public struct Movement {
    public let location: CGPoint
    public let translation: CGPoint
    public let velocity: CGPoint
    
    internal init(location: CGPoint, translation: CGPoint, velocity: CGPoint) {
        self.location = location
        self.translation = translation
        self.velocity = velocity
    }
}
