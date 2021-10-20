//
//  NavigationController.swift
//  DragCardContainer
//
//  Created by galaxy on 2021/10/20.
//

import UIKit

public class NavigationController: UINavigationController {

    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override var shouldAutorotate: Bool {
        return viewControllers.last?.shouldAutorotate ?? false
    }
}
