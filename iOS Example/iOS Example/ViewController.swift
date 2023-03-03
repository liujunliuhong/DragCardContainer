//
//  ViewController.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/20.
//

import UIKit
import SnapKit
import DragCardContainer

private let targetLength: CGFloat = 150.0

public class ViewController: UIViewController {

    private lazy var cardContainer: DragCardContainer = {
        let cardContainer = DragCardContainer()
        cardContainer.infiniteLoop = true
        cardContainer.dataSource = self
        cardContainer.delegate = self
        cardContainer.visibleCount = 3
        cardContainer.allowedDirection = [.left, .right, .up]
        return cardContainer
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Demo"
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "next", style: .plain, target: self, action: #selector(nextAction)),
                                              UIBarButtonItem(title: "rewind_form_right", style: .plain, target: self, action: #selector(rewindFromRightAction)),
                                              UIBarButtonItem(title: "rewind_form_left", style: .plain, target: self, action: #selector(rewindFromLeftAction))]
        
        view.addSubview(cardContainer)
        cardContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            make.top.equalToSuperview().offset(150)
            make.bottom.equalToSuperview().offset(-150)
        }
    }
    
    @objc private func nextAction() {
        //cardContainer.swipeTopCard(to: .right)
        //cardContainer.visibleCount = 5
        cardContainer.currentTopIndex = 3
    }
    
    @objc private func rewindFromRightAction() {
        cardContainer.rewind(from: .right)
    }
    
    @objc private func rewindFromLeftAction() {
        cardContainer.rewind(from: .left)
        
    }
}

extension ViewController: DragCardDataSource {
    public func numberOfCards(_ dragCard: DragCardContainer) -> Int {
        return 10
    }
    
    public func dragCard(_ dragCard: DragCardContainer, viewForCard index: Int) -> DragCardView {
        let cardView = CardView()
        cardView.overlayView.likeView.alpha = 0
        cardView.overlayView.nopeView.alpha = 0
        cardView.overlayView.superLikeView.alpha = 0
        cardView.label.text = "\(index)"
        return cardView
    }
}

extension ViewController: DragCardDelegate {
    public func dragCard(_ dragCard: DragCardContainer, displayTopCardAt index: Int, with cardView: DragCardView) {
        print("displayTopCardAt: \(index)")
    }
    
    public func dragCard(_ dragCard: DragCardContainer, movementCardAt index: Int, translation: CGPoint, with cardView: DragCardView) {
        print("movementCardAt: \(index) - \(translation)")
        
        if let cardView = cardView as? CardView {
            var horizontalRatio = abs(translation.x) / targetLength
            if horizontalRatio >= 1.0 {
                horizontalRatio = 1.0
            }
            if translation.x.isLess(than: .zero) {
                cardView.overlayView.nopeView.alpha = horizontalRatio
                cardView.overlayView.likeView.alpha = 0
            } else if translation.x.isEqual(to: .zero) {
                cardView.overlayView.nopeView.alpha = 0
                cardView.overlayView.likeView.alpha = 0
            } else {
                cardView.overlayView.nopeView.alpha = 0
                cardView.overlayView.likeView.alpha = horizontalRatio
            }

            var verticalRatio = abs(translation.y) / targetLength
            verticalRatio = verticalRatio - horizontalRatio
            if verticalRatio >= 1.0 {
                verticalRatio = 1.0
            } else if verticalRatio <= 0 {
                verticalRatio = 0
            }
            if !translation.y.isLess(than: .zero) {
                verticalRatio = 0.0
            }
            cardView.overlayView.superLikeView.alpha = verticalRatio
        }
    }
    
    public func dragCard(_ dragCard: DragCardContainer, didRemovedTopCardAt index: Int, direction: Direction, with cardView: DragCardView) {
        print("didRemovedTopCardAt: \(index)")
    }
    
    public func dragCard(_ dragCard: DragCardContainer, didRemovedLast cardView: DragCardView) {
        print("didRemovedLast")
    }
    
    public func dragCard(_ dragCard: DragCardContainer, didSelectTopCardAt index: Int, with cardView: DragCardView) {
        print("didSelectTopCardAt: \(index)")
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

