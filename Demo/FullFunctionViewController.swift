//
//  FullFunctionViewController.swift
//  DragCardContainer
//
//  Created by jun on 2021/10/21.
//

import UIKit
import SnapKit
#if canImport(DragCard)
import DragCard
#endif

public class FullFunctionViewController: BaseViewController {
    
    private let titles: [String] = ["水星", "金星", "地球", "火星", "木星", "土星", "天王星", "海王星", "木卫一", "土卫一"]
    
    private var cardContainer: DragCardContainer!
    private var indexLabel: UILabel!
    private var nextButton: UIButton!
    private var revokeButton: UIButton!
    private var stateView: UIView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reload", style: .done, target: self, action: #selector(reloadAction))
        
        indexLabel = UILabel()
        indexLabel.textAlignment = .center
        indexLabel.font = UIFont.systemFont(ofSize: 20)
        indexLabel.textColor = .black
        view.addSubview(indexLabel)
        indexLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-45)
            make.left.right.equalToSuperview()
        }
        
        revokeButton = UIButton(type: .system)
        revokeButton.backgroundColor = .gray
        revokeButton.setTitle("Revoke", for: .normal)
        revokeButton.setTitleColor(.white, for: .normal)
        revokeButton.addTarget(self, action: #selector(revokeAction), for: .touchUpInside)
        view.addSubview(revokeButton)
        revokeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(indexLabel.snp.top).offset(-15)
            make.height.equalTo(35)
            make.width.equalTo(60)
        }
        
        nextButton = UIButton(type: .system)
        nextButton.backgroundColor = .gray
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(indexLabel.snp.top).offset(-15)
            make.height.equalTo(35)
            make.width.equalTo(60)
        }
        
        stateView = UIView()
        stateView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 100.0)/2.0, y: UIScreen.main.bounds.size.height - 250, width: 100.0, height: 100.0)
        stateView.backgroundColor = UIColor.purple
        stateView.layer.cornerRadius = 100.0/2.0
        stateView.layer.masksToBounds = true
        view.addSubview(stateView)
        
        cardContainer = DragCardContainer()
        cardContainer.delegate = self
        cardContainer.dataSource = self
        cardContainer.visibleCount = 3
        cardContainer.minimumScale = 0.8
        cardContainer.cellRotationMaximumAngle = 15
        cardContainer.removeDirection = .horizontal
        cardContainer.infiniteLoop = false
        cardContainer.register(CardCell.self, forCellReuseIdentifier: "ID")
        
        view.addSubview(cardContainer)
        
        cardContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150.0)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.height.equalTo(400)
        }
    }
}

extension FullFunctionViewController {
    public override var shouldAutorotate: Bool {
        return false
    }
}

extension FullFunctionViewController {
    @objc private func reloadAction() {
        print("Reload")
        cardContainer.currentIndex = 0
    }
    
    @objc private func revokeAction() {
        print("Revoke")
        cardContainer.revoke(movementDirection: .right)
    }
    
    @objc private func nextAction() {
        print("Next")
        cardContainer.nextCard(topCardMovementDirection: .right)
    }
}


extension FullFunctionViewController: DragCardDataSource {
    public func numberOfCount(_ dragCard: DragCardContainer) -> Int {
        return titles.count
    }
    
    public func dragCard(_ dragCard: DragCardContainer, indexOfCell index: Int) -> DragCardCell {
        let cell = dragCard.dequeueReusableCell(withIdentifier: "ID") as? CardCell
        cell?.titleLabel.text = titles[index]
        return cell ?? DragCardCell()
    }
}

extension FullFunctionViewController: DragCardDelegate {
    public func dragCard(_ dragCard: DragCardContainer, didDisplayTopCell cell: DragCardCell, withIndexAt index: Int) {
        indexLabel.text = "当前索引: \(index)"
    }
    
    public func dragCard(_ dragCard: DragCardContainer, didFinishRemoveLastCell cell: DragCardCell) {
        print("最后一个卡片滑完")
    }
    
    public func dragCard(_ dragCard: DragCardContainer, didRemoveTopCell cell: DragCardCell, withIndex index: Int, movementDirection: DragCardContainer.MovementDirection) {
        print("顶层卡片滑出去了，索引: \(index)")
    }
    
    public func dragCard(_ dragCard: DragCardContainer, didSelectIndexAt index: Int, withTopCell cell: DragCardCell) {
        print("点击顶层卡片，索引: \(index)")
        let vc = DetailViewController()
        vc.navigationItem.title = "索引值：\(index)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    public func dragCard(_ dragCard: DragCardContainer, currentCell cell: DragCardCell, withIndex index: Int, currentCardDirection direction: DragCardDirection, canRemove: Bool) {
        let ratio = abs(direction.horizontalMovementRatio) * 0.2
        self.stateView.transform = CGAffineTransform(scaleX: 1.0+ratio, y: 1.0+ratio)
    }
}
