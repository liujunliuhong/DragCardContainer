//
//  VerticalDragViewController.swift
//  YHDragCard-Swift
//
//  Created by apple on 2019/9/30.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit



class VerticalDragViewController: UIViewController {
    
    let models: [String] = ["水星",
                            "金星",
                            "地球",
                            "火星",
                            "木星"]
    lazy var card: YHDragCard = {
        let card = YHDragCard(frame: CGRect(x: 50, y: UIApplication.shared.statusBarFrame.size.height + 44.0 + 40.0, width: self.view.frame.size.width - 100 , height: 400))
        card.dataSource = self
        card.delegate = self
        card.minScale = 0.9
        card.removeDirection = .vertical // 垂直滑动
        card.demarcationAngle = 45.0 // 设置夹角
        return card
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(self.card)
    }
}

extension VerticalDragViewController{
    // 刷新
    @objc func reload() {
        self.card.reloadData(animation: true)
    }
}



extension VerticalDragViewController: YHDragCardDataSource {
    func numberOfCount(_ dragCard: YHDragCard) -> Int {
        return self.models.count
    }
    func dragCard(_ dragCard: YHDragCard, indexOfCard index: Int) -> UIView {
        let label = UILabel()
        label.text = "\(index) -- \(self.models[index])"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textAlignment = .center
        label.backgroundColor = .orange
        label.layer.cornerRadius = 5.0
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.masksToBounds = true
        return label
    }
}

extension VerticalDragViewController: YHDragCardDelegate {
    func dragCard(_ dragCard: YHDragCard, didDisplayCard card: UIView, withIndexAt index: Int) {
        self.navigationItem.title = "\(index + 1)/\(self.models.count)"
    }
    
    func dragCard(_ dragCard: YHDragCard, didSelectIndexAt index: Int, with card: UIView) {
        print("点击卡片:\(index)")
    }
    
    func dragCard(_ dragCard: YHDragCard, didRemoveCard card: UIView, withIndex index: Int, removeDirection: YHDragCardDirection.Direction) {
        print("索引为\(index)的卡片滑出去了")
    }
    
    func dragCard(_ dragCard: YHDragCard, didFinishRemoveLastCard card: UIView) {
        reload()
    }
    
    func dragCard(_ dragCard: YHDragCard, currentCard card: UIView, withIndex index: Int, currentCardDirection direction: YHDragCardDirection, canRemove: Bool) {
        
    }
}

