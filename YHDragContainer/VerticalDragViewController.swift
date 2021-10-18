//
//  VerticalDragViewController.swift
//  YHDragCard-Swift
//
//  Created by apple on 2019/9/30.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit
//import YHDragCardSwift

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
        self.navigationItem.title = "垂直方向滑动"
        view.addSubview(self.card)
        
        // 请根据具体项目情况在合适的时机进行刷新
        self.card.reloadData(animation: false)
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
    
    func dragCard(_ dragCard: YHDragCard, indexOfCell index: Int) -> YHDragCardCell {
        var cell = dragCard.dequeueReusableCell(withIdentifier: "ID") as? DemoCell
        if cell == nil {
            cell = DemoCell(reuseIdentifier: "ID")
        }
        let text = "索引\(index)\n\n\(self.models[index])"
        cell?.set(title: text)
        return cell!
    }
}

extension VerticalDragViewController: YHDragCardDelegate {
    func dragCard(_ dragCard: YHDragCard, didSelectIndexAt index: Int, with cell: YHDragCardCell) {
        let vc = NextViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
