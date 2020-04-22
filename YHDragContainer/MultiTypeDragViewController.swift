//
//  MultiTypeDragViewController.swift
//  YHDragContainer
//
//  Created by apple on 2020/4/22.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import YHDragCardSwift

class MultiTypeDragViewController: UIViewController {
    
    private let models: [Any?] = ["水星",
                                  UIImage(named: "image1"),
                                  "金星",
                                  "地球",
                                  UIImage(named: "image2"),
                                  "火星",
                                  UIImage(named: "image3"),
                                  "木星",
                                  "土星",
                                  "天王星",
                                  "海王星",
                                  "木卫一",
                                  "土卫一"]
    
    private lazy var card: YHDragCard = {
        let card = YHDragCard(frame: CGRect(x: 50, y: UIApplication.shared.statusBarFrame.size.height + 44.0 + 40.0, width: self.view.frame.size.width - 100 , height: 400))
        card.dataSource = self
        card.delegate = self
        card.minScale = 0.9
        card.removeDirection = .horizontal
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

extension MultiTypeDragViewController: YHDragCardDataSource {
    
    func numberOfCount(_ dragCard: YHDragCard) -> Int {
        return self.models.count
    }
    
    func dragCard(_ dragCard: YHDragCard, indexOfCell index: Int) -> YHDragCardCell {
        let content = self.models[index];
        if let text = content as? String {
            var cell = dragCard.dequeueReusableCell(withIdentifier: "ID1") as? DemoCell
            if cell == nil {
                cell = DemoCell(reuseIdentifier: "ID1")
            }
            cell?.set(title: text)
            return cell!
        } else if let image = content as? UIImage {
            var cell = dragCard.dequeueReusableCell(withIdentifier: "ID2") as? OtherDemoCell
            if cell == nil {
                cell = OtherDemoCell(reuseIdentifier: "ID2")
            }
            cell?.set(image: image)
            return cell!
        } else {
            var cell = dragCard.dequeueReusableCell(withIdentifier: "ID3") as? DemoCell
            if cell == nil {
                cell = DemoCell(reuseIdentifier: "ID3")
            }
            cell?.set(title: nil)
            return cell!
        }
    }
}

extension MultiTypeDragViewController: YHDragCardDelegate {
    func dragCard(_ dragCard: YHDragCard, didDisplayCell cell: YHDragCardCell, withIndexAt index: Int) {
        self.navigationItem.title = "当前卡片索引: \(index + 1)/\(self.models.count)"
    }
    
    func dragCard(_ dragCard: YHDragCard, didSelectIndexAt index: Int, with cell: YHDragCardCell) {
        let vc = NextViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func dragCard(_ dragCard: YHDragCard, didFinishRemoveLastCell cell: YHDragCardCell) {
        self.card.reloadData(animation: true)
    }
}
