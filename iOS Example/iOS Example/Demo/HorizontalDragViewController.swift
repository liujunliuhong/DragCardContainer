//
//  HorizontalDragViewController.swift
//  DragCardContainer
//
//  Created by galaxy on 2021/10/19.
//

import UIKit
import SnapKit
import DragCardContainer



public class HorizontalDragViewController: BaseViewController {
    
    private let titles: [String] = ["水星", "金星", "地球", "火星", "木星", "土星", "天王星", "海王星", "木卫一", "土卫一"]
    
    private var cardContainer: DragCardContainer!
    private var indexLabel: UILabel!
    
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
        
        
        
        cardContainer = DragCardContainer()
        cardContainer.delegate = self
        cardContainer.dataSource = self
        cardContainer.visibleCount = 3
        cardContainer.minimumScale = 0.8
        cardContainer.cellRotationMaximumAngle = 15
        cardContainer.removeDirection = .horizontal
        cardContainer.register(CardCell.self, forCellReuseIdentifier: "ID")
        view.addSubview(cardContainer)
        
        cardContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
    }
}

extension HorizontalDragViewController {
    @objc private func reloadAction() {
        cardContainer.currentIndex = 0
    }
}


extension HorizontalDragViewController: DragCardDataSource {
    public func numberOfCount(_ dragCard: DragCardContainer) -> Int {
        return titles.count
    }
    
    public func dragCard(_ dragCard: DragCardContainer, indexOfCell index: Int) -> DragCardCell {
        let cell = dragCard.dequeueReusableCell(withIdentifier: "ID") as? CardCell
        cell?.titleLabel.text = titles[index]
        return cell ?? DragCardCell()
    }
}

extension HorizontalDragViewController: DragCardDelegate {
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
        
    }
}
