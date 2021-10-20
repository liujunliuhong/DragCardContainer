//
//  HorizontalDragViewController.swift
//  DragCardContainer
//
//  Created by galaxy on 2021/10/19.
//

import UIKit
import SnapKit
#if canImport(DragCard)
import DragCard
#endif

public class HorizontalDragViewController: BaseViewController {
    
    private let titles: [String] = ["水星", "金星", "地球", "火星", "木星", "土星", "天王星", "海王星", "木卫一", "土卫一"]
    
    private var cardContainer: DragCardContainer!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        cardContainer = DragCardContainer()
        cardContainer.delegate = self
        cardContainer.dataSource = self
        cardContainer.visibleCount = 4
        cardContainer.minimumScale = 0.8
        cardContainer.register(Cell.self, forCellReuseIdentifier: "ID")
        view.addSubview(cardContainer)
        
        cardContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.cardContainer.visibleCount = 6
        }
    }
}


extension HorizontalDragViewController: DragCardDataSource {
    public func numberOfCount(_ dragCard: DragCardContainer) -> Int {
        return titles.count
    }
    
    public func dragCard(_ dragCard: DragCardContainer, indexOfCell index: Int) -> DragCardCell {
        let cell = dragCard.dequeueReusableCell(withIdentifier: "ID") as? Cell
        cell?.titleLabel.text = titles[index]
        return cell ?? DragCardCell()
    }
}

extension HorizontalDragViewController: DragCardDelegate {
    public func dragCard(_ dragCard: DragCardContainer, didDisplayTopCell cell: DragCardCell, withIndexAt index: Int) {
        print("显示顶层卡片，索引: \(index)")
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


fileprivate class Cell: DragCardCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    required init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = .orange
        layer.cornerRadius = 5.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
