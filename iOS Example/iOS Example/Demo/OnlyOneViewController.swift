//
//  OnlyOneViewController.swift
//  DragCardContainer
//
//  Created by galaxy on 2021/10/21.
//

import UIKit
import SnapKit
import DragCardContainer

//public class OnlyOneViewController: BaseViewController {
//    
//    private let titles: [String] = ["水星"]
//    
//    private var cardContainer: DragCardContainer!
//    private var indexLabel: UILabel!
//    private var revokeButton: UIButton!
//    
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        indexLabel = UILabel()
//        indexLabel.textAlignment = .center
//        indexLabel.font = UIFont.systemFont(ofSize: 20)
//        indexLabel.textColor = .black
//        view.addSubview(indexLabel)
//        indexLabel.snp.makeConstraints { make in
//            make.bottom.equalToSuperview().offset(-45)
//            make.left.right.equalToSuperview()
//        }
//        
//        revokeButton = UIButton(type: .system)
//        revokeButton.backgroundColor = .gray
//        revokeButton.setTitle("Revoke", for: .normal)
//        revokeButton.setTitleColor(.white, for: .normal)
//        revokeButton.addTarget(self, action: #selector(revokeAction), for: .touchUpInside)
//        view.addSubview(revokeButton)
//        revokeButton.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(20)
//            make.bottom.equalTo(indexLabel.snp.top).offset(-15)
//            make.height.equalTo(35)
//            make.width.equalTo(60)
//        }
//        
//        cardContainer = DragCardContainer()
//        cardContainer.delegate = self
//        cardContainer.dataSource = self
//        cardContainer.visibleCount = 1
//        cardContainer.minimumScale = 0.8
//        cardContainer.cellRotationMaximumAngle = 15
//        cardContainer.removeDirection = .horizontal
//        cardContainer.infiniteLoop = false
//        cardContainer.register(CardCell.self, forCellReuseIdentifier: "ID")
//        
//        // canRevokeWhenFirstCell设置为true，表示数据源只有1个的时候，能revoke
//        // canRevokeWhenFirstCell设置为fase，表示数据源只有1个的时候，不能revoke
//        cardContainer.canRevokeWhenOnlyOneDataSource = true
//        
//        view.addSubview(cardContainer)
//        
//        cardContainer.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.3)
//            make.centerY.equalToSuperview()
//            make.height.equalToSuperview().multipliedBy(0.3)
//        }
//    }
//}
//
//extension OnlyOneViewController {
//    @objc private func revokeAction() {
//        print("Revoke")
//        cardContainer.revoke(movementDirection: .right)
//    }
//}
//
//
//extension OnlyOneViewController: DragCardDataSource {
//    public func numberOfCount(_ dragCard: DragCardContainer) -> Int {
//        return titles.count
//    }
//    
//    public func dragCard(_ dragCard: DragCardContainer, indexOfCell index: Int) -> DragCardCell {
//        let cell = dragCard.dequeueReusableCell(withIdentifier: "ID") as? CardCell
//        cell?.titleLabel.text = titles[index]
//        return cell ?? DragCardCell()
//    }
//}
//
//extension OnlyOneViewController: DragCardDelegate {
//    public func dragCard(_ dragCard: DragCardContainer, didDisplayTopCell cell: DragCardCell, withIndexAt index: Int) {
//        indexLabel.text = "当前索引: \(index)"
//    }
//    
//    public func dragCard(_ dragCard: DragCardContainer, didFinishRemoveLastCell cell: DragCardCell) {
//        print("最后一个卡片滑完")
//    }
//    
//    public func dragCard(_ dragCard: DragCardContainer, didRemoveTopCell cell: DragCardCell, withIndex index: Int, movementDirection: DragCardContainer.MovementDirection) {
//        print("顶层卡片滑出去了，索引: \(index)")
//    }
//    
//    public func dragCard(_ dragCard: DragCardContainer, didSelectIndexAt index: Int, withTopCell cell: DragCardCell) {
//        print("点击顶层卡片，索引: \(index)")
//        let vc = DetailViewController()
//        vc.navigationItem.title = "索引值：\(index)"
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    public func dragCard(_ dragCard: DragCardContainer, currentCell cell: DragCardCell, withIndex index: Int, currentCardDirection direction: DragCardDirection, canRemove: Bool) {
//        
//    }
//}
