//
//  Direction.swift
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

public struct Direction: OptionSet, CustomStringConvertible {
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static let none = Direction([])
    public static let left = Direction(rawValue: 1 << 0)
    public static let right = Direction(rawValue: 1 << 1)
    public static let down = Direction(rawValue: 1 << 2)
    public static let up = Direction(rawValue: 1 << 3)
    
    public static let horizontal: Direction = [left, right]
    public static let vertical: Direction = [up, down]
    
    public static let all: Direction = [horizontal, vertical]
    
    public var description: String {
        switch self {
            case .none:
                return "None"
            case .left:
                return "Left"
            case .right:
                return "Right"
            case .up:
                return "Up"
            case .down:
                return "Down"
            default:
                return "Unknown"
        }
    }
}

extension Direction {
    public static func fromPoint(_ point: CGPoint) -> Direction {
        switch (point.x, point.y) {
            case let (x, y) where abs(x) >= abs(y) && x > 0:
                return .right
            case let (x, y) where abs(x) >= abs(y) && x < 0:
                return .left
            case let (x, y) where abs(x) < abs(y) && y < 0:
                return .up
            case let (x, y) where abs(x) < abs(y) && y > 0:
                return .down
            case (_, _):
                return .none
        }
    }
}
