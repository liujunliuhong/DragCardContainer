//
//  ViewController.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/20.
//

import UIKit
import SnapKit
import DragCardContainer
import CoreGraphics

private let titles: [String] = ["水星", "金星", "地球", "火星", "木星", "土星", "天王星", "海王星", "木卫一", "土卫一"]
private let allowedDirection: [Direction] = [.left, .up, .right]

public final class ViewController: UIViewController {

    private lazy var cardContainer: DragCardContainer = {
        let cardContainer = DragCardContainer()
        // 是否可以无限滑动
        cardContainer.infiniteLoop = false
        // 数据源
        cardContainer.dataSource = self
        // 代理
        cardContainer.delegate = self
        // 可见卡片数量
        cardContainer.visibleCount = 3
        // 是否可以打印日志
        cardContainer.enableLog = true
        // 是否禁用卡片拖动
        cardContainer.disableTopCardDrag = false
        // 是否禁用卡片点击
        cardContainer.disableTopCardClick = false
        
        let mode = ScaleMode()
        // 卡片之间间距
        mode.cardSpacing = 10
        // 方向（可以运行Demo，修改该参数看实际效果）
        mode.direction = .bottom
        // 最小缩放比例
        mode.minimumScale = 0.7
        // 卡片最大旋转角度
        mode.maximumAngle = 0
        // 赋值mode
        cardContainer.mode = mode
        
        return cardContainer
    }()
    
    private lazy var bottomView: BottomView = {
        let bottomView = BottomView()
        bottomView.likeButton.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        bottomView.passButton.addTarget(self, action: #selector(passAction), for: .touchUpInside)
        bottomView.superLikeButton.addTarget(self, action: #selector(superLikeAction), for: .touchUpInside)
        bottomView.refreshButton.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
        return bottomView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(cardContainer)
        view.addSubview(bottomView)
        
        cardContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            make.top.equalToSuperview().offset(150)
            make.bottom.equalToSuperview().offset(-150)
        }
        bottomView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cardContainer.snp.bottom).offset(35)
            make.height.equalTo(50)
        }
    }
}

extension ViewController {
    @objc private func likeAction() {
        cardContainer.swipeTopCard(to: .right)
    }

    @objc private func passAction() {
        cardContainer.swipeTopCard(to: .left)
    }

    @objc private func superLikeAction() {
        cardContainer.swipeTopCard(to: .up)
    }

    @objc private func refreshAction() {
        cardContainer.reloadData(forceReset: true, animation: true)
    }
}

extension ViewController: DragCardDataSource {
    public func numberOfCards(_ dragCard: DragCardContainer) -> Int {
        return titles.count
    }

    public func dragCard(_ dragCard: DragCardContainer, viewForCard index: Int) -> DragCardView {
        let cardView = CardView()
        
        cardView.allowedDirection = allowedDirection
        
        for direction in allowedDirection {
            cardView.setOverlay(CardOverlayView(direction: direction), forDirection: direction)
        }
        
        cardView.label.text = "Index: \(index)\n\(titles[index])"
        
        return cardView
    }
}

extension ViewController: DragCardDelegate {
    public func dragCard(_ dragCard: DragCardContainer, displayTopCardAt index: Int, with cardView: DragCardView) {
        print("displayTopCardAt: \(index)")
        navigationItem.title = "Index: \(index)"
    }
    
    public func dragCard(_ dragCard: DragCardContainer, didRemovedTopCardAt index: Int, direction: Direction, with cardView: DragCardView) {
        print("didRemovedTopCardAt: \(index)")
    }

    public func dragCard(_ dragCard: DragCardContainer, didRemovedLast cardView: DragCardView) {
        print("didRemovedLast")
    }

    public func dragCard(_ dragCard: DragCardContainer, didSelectTopCardAt index: Int, with cardView: DragCardView) {
        print("didSelectTopCardAt: \(index)")
        
        let vc = DetailViewController()
        vc.label.text = titles[index]
        navigationController?.pushViewController(vc, animated: true)
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

