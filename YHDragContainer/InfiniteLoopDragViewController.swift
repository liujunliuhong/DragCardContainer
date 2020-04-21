//
//  InfiniteLoopDragViewController.swift
//  YHDragCard-Swift
//
//  Created by apple on 2019/9/30.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit
import YHDragCardSwift

class InfiniteLoopDragViewController: UIViewController {
    
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
        card.removeDirection = .horizontal
        card.infiniteLoop = true // 无限滑动
        return card
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(self.card)
        
        // 请根据具体项目情况在合适的时机进行刷新
        self.card.reloadData(animation: false)
    }
}


extension InfiniteLoopDragViewController: YHDragCardDataSource {
    func numberOfCount(_ dragCard: YHDragCard) -> Int {
        return self.models.count
    }
    
    func dragCard(_ dragCard: YHDragCard, indexOfCell index: Int) -> YHDragCardCell {
        var cell = dragCard.dequeueReusableCard(withIdentifier: "ID") as? DemoCell
        if cell == nil {
            cell = DemoCell(reuseIdentifier: "ID")
        }
        let text = "索引\(index)\n\n\(self.models[index])"
        cell?.set(title: text)
        return cell!
    }
}

extension InfiniteLoopDragViewController: YHDragCardDelegate {
    func dragCard(_ dragCard: YHDragCard, didDisplayCell cell: YHDragCardCell, withIndexAt index: Int) {
        self.navigationItem.title = "当前卡片索引: \(index + 1)/\(self.models.count)"
    }
    
    func dragCard(_ dragCard: YHDragCard, didSelectIndexAt index: Int, with cell: YHDragCardCell) {
        print("点击卡片索引:\(index)")
        let vc = NextViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
