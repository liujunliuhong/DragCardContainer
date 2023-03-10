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

private let targetLength: CGFloat = 150.0

public final class ViewController: UIViewController {

    private lazy var cardContainer: DragCardContainer = {
        let cardContainer = DragCardContainer()
        cardContainer.infiniteLoop = true
        cardContainer.dataSource = self
        cardContainer.delegate = self
        cardContainer.visibleCount = 3
        return cardContainer
    }()
    
    private lazy var bottmView: BottomView = {
        let bottmView = BottomView()
        bottmView.likeButton.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        bottmView.passButton.addTarget(self, action: #selector(passAction), for: .touchUpInside)
        bottmView.superLikeButton.addTarget(self, action: #selector(superLikeAction), for: .touchUpInside)
        bottmView.refreshButton.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
        return bottmView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Demo"
        
        
//        let card = DragCardView()
//        card.backgroundColor = RandomColor()
//        view.addSubview(card)
//
//        card.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
//            make.width.equalTo(70)
//            make.height.equalTo(100)
//        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            card.swipe(to: .right)
//        }
        
        view.addSubview(cardContainer)
        view.addSubview(bottmView)
        
        cardContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            make.top.equalToSuperview().offset(150)
            make.bottom.equalToSuperview().offset(-150)
        }
        bottmView.snp.makeConstraints { make in
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
        //cardContainer.reloadData(animation: true)
        cardContainer.rewind(from: .right)
    }
}

extension ViewController: DragCardDataSource {
    public func numberOfCards(_ dragCard: DragCardContainer) -> Int {
        return 10
    }

    public func dragCard(_ dragCard: DragCardContainer, viewForCard index: Int) -> DragCardView {
        let cardView = CardView()
        
        let allowedDirection: [Direction] = [.left, .up, .right]
        cardView.allowedDirection = allowedDirection
        
        for direction in allowedDirection {
            cardView.setOverlay(CardOverlayView(direction: direction), forDirection: direction)
        }
        
        cardView.label.text = "\(index)"
        
        return cardView
    }
}

extension ViewController: DragCardDelegate {
    public func dragCard(_ dragCard: DragCardContainer, displayTopCardAt index: Int, with cardView: DragCardView) {
        print("displayTopCardAt: \(index)")
    }

//    public func dragCard(_ dragCard: DragCardContainer, movementCardAt index: Int, translation: CGPoint, with cardView: DragCardView) {
//        print("movementCardAt: \(index) - \(translation)")
//
//        if let cardView = cardView as? CardView {
//            var horizontalRatio = abs(translation.x) / targetLength
//            if horizontalRatio >= 1.0 {
//                horizontalRatio = 1.0
//            }
//            if translation.x.isLess(than: .zero) {
//                cardView.overlayView.nopeView.alpha = horizontalRatio
//                cardView.overlayView.likeView.alpha = 0
//            } else if translation.x.isEqual(to: .zero) {
//                cardView.overlayView.nopeView.alpha = 0
//                cardView.overlayView.likeView.alpha = 0
//            } else {
//                cardView.overlayView.nopeView.alpha = 0
//                cardView.overlayView.likeView.alpha = horizontalRatio
//            }
//
//            var verticalRatio = abs(translation.y) / targetLength
//            verticalRatio = verticalRatio - horizontalRatio - horizontalRatio
//            if verticalRatio >= 1.0 {
//                verticalRatio = 1.0
//            } else if verticalRatio <= 0 {
//                verticalRatio = 0
//            }
//            if !translation.y.isLess(than: .zero) {
//                verticalRatio = 0.0
//            }
//            cardView.overlayView.superLikeView.alpha = verticalRatio
//
//
//
//            let direction = Direction.fromPoint(translation)
//            switch direction {
//                case .right:
//                    let targetRatio = 1.5
//                    var newHorizontalRatio = horizontalRatio + 1
//
//                    if newHorizontalRatio > targetRatio {
//                        newHorizontalRatio = targetRatio - (newHorizontalRatio - targetRatio)
//                    }
//                    bottmView.passButton.transform = .identity
//                    bottmView.likeButton.transform = CGAffineTransformScale(.identity, newHorizontalRatio, newHorizontalRatio)
//                default:
//                    bottmView.passButton.transform = .identity
//                    bottmView.likeButton.transform = .identity
//            }
//        }
//    }

    public func dragCard(_ dragCard: DragCardContainer, didRemovedTopCardAt index: Int, direction: Direction, with cardView: DragCardView) {
        print("didRemovedTopCardAt: \(index)")
    }

    public func dragCard(_ dragCard: DragCardContainer, didRemovedLast cardView: DragCardView) {
        print("didRemovedLast")
    }

    public func dragCard(_ dragCard: DragCardContainer, didSelectTopCardAt index: Int, with cardView: DragCardView) {
        print("didSelectTopCardAt: \(index)")
        let vc = DetailViewController()
        vc.index = index
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

