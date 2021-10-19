//
//  Model.swift
//  DragCardContainer
//
//  Created by galaxy on 2021/10/19.
//

import Foundation
import UIKit

public class Model {
    public let title: String
    public let vc: UIViewController.Type
    
    public init(title: String, vc: UIViewController.Type) {
        self.title = title
        self.vc = vc
    }
}
