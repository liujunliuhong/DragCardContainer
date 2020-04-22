//
//  HorizontalDragViewController.swift
//  YHDragCard-Swift
//
//  Created by apple on 2019/9/30.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit
import YHDragCardSwift

class HorizontalDragViewController: UIViewController {
    
    private let models: [String] = ["水星",
                                    "金星",
                                    "地球",
                                    "火星",
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
    
    lazy var reloadItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "刷新", style: .plain, target: self, action: #selector(reload))
    }()
    
    lazy var revokeButton: UIButton = {
        let revokeButton = UIButton(type: .system)
        revokeButton.setTitle("撤销", for: .normal)
        revokeButton.backgroundColor = .gray
        revokeButton.setTitleColor(.white, for: .normal)
        revokeButton.frame = CGRect(x: 50, y: self.card.frame.origin.y + self.card.frame.size.height + 40, width: 100, height: 40)
        revokeButton.addTarget(self, action: #selector(revokeAction), for: .touchUpInside)
        return revokeButton
    }()
    
    lazy var nextButton: UIButton = {
        let nextButton = UIButton(type: .system)
        nextButton.setTitle("下一张", for: .normal)
        nextButton.backgroundColor = .gray
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.frame = CGRect(x: UIScreen.main.bounds.size.width - 50.0 - 100.0, y: self.card.frame.origin.y + self.card.frame.size.height + 40, width: 100, height: 40)
        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return nextButton
    }()
    
    lazy var stateView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: (UIScreen.main.bounds.size.width - 100.0)/2.0, y: self.revokeButton.frame.origin.y+self.revokeButton.frame.size.height+40, width: 100.0, height: 100.0)
        view.backgroundColor = UIColor.purple
        view.layer.cornerRadius = 100.0/2.0
        view.layer.masksToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = reloadItem
        view.addSubview(self.card)
        view.addSubview(revokeButton)
        view.addSubview(nextButton)
        view.addSubview(stateView)
        
        // 请根据具体项目情况在合适的时机进行刷新
        self.card.reloadData(animation: false)
    }
}

extension HorizontalDragViewController{
    // 刷新
    @objc func reload() {
        self.card.reloadData(animation: true)
    }
    // 撤销
    @objc func revokeAction() {
        self.card.revoke(direction: .left)
    }
    // 下一张卡片
    @objc func nextAction() {
        self.card.nextCard(direction: .right)
    }
}



extension HorizontalDragViewController: YHDragCardDataSource {
    
    func numberOfCount(_ dragCard: YHDragCard) -> Int {
        return self.models.count
    }
    
    func dragCard(_ dragCard: YHDragCard, indexOfCell index: Int) -> YHDragCardCell {
        var cell = dragCard.dequeueReusableCell(withIdentifier: "ID") as? DemoCell
        if cell == nil {
            cell = DemoCell(reuseIdentifier: "ID")
        }
        let text = "索引：\(index)\n\n\(self.models[index])"
        cell?.set(title: text)
        return cell!
    }
}

extension HorizontalDragViewController: YHDragCardDelegate {
    func dragCard(_ dragCard: YHDragCard, didDisplayCell cell: YHDragCardCell, withIndexAt index: Int) {
        self.navigationItem.title = "当前卡片索引: \(index + 1)/\(self.models.count)"
    }
    
    func dragCard(_ dragCard: YHDragCard, didSelectIndexAt index: Int, with cell: YHDragCardCell) {
        let vc = NextViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func dragCard(_ dragCard: YHDragCard, didRemoveCell cell: YHDragCardCell, withIndex index: Int, removeDirection: YHDragCardMoveDirection) {
        print("索引为\(index)的卡片滑出去了")
        switch removeDirection {
        case .up:
            print("向上移除")
        case .down:
            print("向下移除")
        case .left:
            print("向左移除")
        case .right:
            print("向右移除")
        case .none:
            print("default")
        }
    }
    
    func dragCard(_ dragCard: YHDragCard, didFinishRemoveLastCell cell: YHDragCardCell) {
        self.reload()
    }
    
    func dragCard(_ dragCard: YHDragCard, currentCell cell: YHDragCardCell, withIndex index: Int, currentCardDirection direction: YHDragCardDirection, canRemove: Bool) {
        let ratio = abs(direction.horizontalRatio) * 0.2
        self.stateView.transform = CGAffineTransform(scaleX: 1.0+ratio, y: 1.0+ratio)
    }
}

