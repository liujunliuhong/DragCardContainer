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
    
    public lazy var cardContainer: DragCardContainer = {
        let cardContainer = DragCardContainer()
        cardContainer.delegate = self
        cardContainer.dataSource = self
        cardContainer.visibleCount = 3
        cardContainer.minimumScale = 0.3
        cardContainer.register(Cell.self, forCellReuseIdentifier: "ID")
        return cardContainer
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cardContainer)
        cardContainer.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
            make.top.equalToSuperview().offset(100.0)
            make.bottom.equalToSuperview().offset(-100)
        }
        
        cardContainer.reloadData()
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
