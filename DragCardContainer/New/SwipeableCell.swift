//
//  SwipeableCell.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/2/27.
//

import UIKit

public final class SwipeableCell: UICollectionViewCell {
    internal lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 60)
        label.numberOfLines = 0
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RandomColor()
        contentView.addSubview(label)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}

