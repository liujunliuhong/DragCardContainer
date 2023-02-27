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

fileprivate func RBA(R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat = 1.0) -> UIColor {
    return UIColor(red: (R / 255.0), green: (G / 255.0), blue: (B / 255.0), alpha: A)
}

/// 获取一个随机颜色
fileprivate func RandomColor() -> UIColor {
    let R: CGFloat = CGFloat(Int.random(in: Range(uncheckedBounds: (0, 255))))
    let G: CGFloat = CGFloat(Int.random(in: Range(uncheckedBounds: (0, 255))))
    let B: CGFloat = CGFloat(Int.random(in: Range(uncheckedBounds: (0, 255))))
    let A: CGFloat = 1.0
    return RBA(R: R, G: G, B: B, A: A)
}
