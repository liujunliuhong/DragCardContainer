//
//  OrientationChangeViewController.swift
//  YHDragContainer
//
//  Created by galaxy on 2020/10/24.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
//import YHDragCardSwift

private func portraitFrame() -> CGRect {
    let top: CGFloat = 100.0
    let left: CGFloat = 20.0
    let width: CGFloat = UIScreen.main.bounds.size.width - left - left
    let height: CGFloat = 400
    return CGRect(x: left, y: top, width: width, height: height)
}

private func landscapeFrame() -> CGRect {
    let top: CGFloat = 100.0
    let left: CGFloat = 90.0
    let width: CGFloat = UIScreen.main.bounds.size.width - left - left
    let height: CGFloat = UIScreen.main.bounds.size.height - top - 50.0
    return CGRect(x: left, y: top, width: width, height: height)
}

class OrientationChangeViewController: UIViewController {
    
    deinit {
        self.removeNotification()
    }
    
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
        let card = YHDragCard(frame: .zero)
        card.dataSource = self
        card.delegate = self
        card.minScale = 0.9
        card.removeDirection = .horizontal
        return card
    }()
    
    lazy var reloadItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "刷新", style: .plain, target: self, action: #selector(reload))
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = reloadItem
        
        self.addNotification()
        
        view.addSubview(self.card)
        
        self.orientationDidChange()
    }
}

extension OrientationChangeViewController {
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func orientationDidChange() {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            self.card.frame = portraitFrame()
            self.card.reloadData(animation: false)
        } else {
            self.card.frame = landscapeFrame()
            self.card.reloadData(animation: false)
        }
    }
}

extension OrientationChangeViewController{
    // 刷新
    @objc func reload() {
        self.card.reloadData(animation: true)
    }
}



extension OrientationChangeViewController: YHDragCardDataSource {
    
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

extension OrientationChangeViewController: YHDragCardDelegate {
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
}

