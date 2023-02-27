//
//  ViewController.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/20.
//

import UIKit
import SnapKit
import DragCardContainer

public class ViewController: UIViewController {

    private lazy var swipeableView: SwipeableView = {
        let swipeableView = SwipeableView()
        return swipeableView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Demo"
        
        view.addSubview(swipeableView)
        swipeableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(70)
            make.top.equalToSuperview().offset(120)
            make.bottom.equalToSuperview().offset(-90)
        }
    }
}

