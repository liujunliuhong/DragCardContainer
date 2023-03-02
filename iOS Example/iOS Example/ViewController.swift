//
//  ViewController.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/20.
//

import UIKit
import SnapKit
import DragCardContainer

public class ViewController: UIViewController {

    private lazy var cardContainer: DragCardContainer = {
        let cardContainer = DragCardContainer()
        cardContainer.infiniteLoop = false
        cardContainer.dataSource = self
        cardContainer.delegate = self
        //cardContainer.visibleCount = 2
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
            make.centerX.equalToSuperview()//.offset(-100)
            make.width.equalTo(150)
            make.centerY.equalToSuperview()
            make.height.equalTo(250)
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
    public func numberOfCount(_ dragCard: DragCardContainer) -> Int {
        return 1
    }
    
    public func dragCard(_ dragCard: DragCardContainer, viewForCard index: Int) -> UIView {
        let label = UILabel()
        label.backgroundColor = RandomColor()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 60)
        label.text = "\(index)"
        label.isUserInteractionEnabled = true
        return label
    }
}

extension ViewController: DragCardDelegate {
    public func dragCard(_ dragCard: DragCardContainer, displayTopCardAt index: Int, with card: UIView) {
        print("displayTopCardAt: \(index)")
    }
    
    public func dragCard(_ dragCard: DragCardContainer, movementCardAt index: Int, translation: CGPoint, with card: UIView) {
        print("movementCardAt: \(index) - \(translation)")
    }
    
    public func dragCard(_ dragCard: DragCardContainer, didRemovedTopCardAt index: Int, direction: Direction, with card: UIView) {
        print("didRemoveTopCardAt: \(index)")
    }
    
    public func dragCard(_ dragCard: DragCardContainer, didRemovedLast card: UIView) {
        print("didRemovedLast")
    }
    
    public func dragCard(_ dragCard: DragCardContainer, didSelectTopCardAt index: Int, with card: UIView) {
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
