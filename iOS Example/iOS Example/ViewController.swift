//
//  ViewController.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/20.
//

import UIKit
import SnapKit
import DragCardContainer

public class ViewController: UIViewController, DragCardDataSource {

    private lazy var cardContainer: DragCardContainer = {
        let cardContainer = DragCardContainer()
        cardContainer.dataSource = self
        return cardContainer
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Demo"
        
        view.addSubview(cardContainer)
        cardContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(90)
            make.top.equalToSuperview().offset(200)
            make.bottom.equalToSuperview().offset(-200)
        }
    }
    
    public func numberOfCount(_ dragCard: DragCardContainer) -> Int {
        return 6
    }
    
    public func dragCard(_ dragCard: DragCardContainer, viewForCard index: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = RandomColor()
        return view
    }
}


internal func RBA(R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat = 1.0) -> UIColor {
    return UIColor(red: (R / 255.0), green: (G / 255.0), blue: (B / 255.0), alpha: A)
}

/// 获取一个随机颜色
internal func RandomColor() -> UIColor {
    let R: CGFloat = CGFloat(Int.random(in: Range(uncheckedBounds: (0, 255))))
    let G: CGFloat = CGFloat(Int.random(in: Range(uncheckedBounds: (0, 255))))
    let B: CGFloat = CGFloat(Int.random(in: Range(uncheckedBounds: (0, 255))))
    let A: CGFloat = 1.0
    return RBA(R: R, G: G, B: B, A: A)
}
