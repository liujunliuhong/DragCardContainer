//
//  CardCell.swift
//  DragCardContainer
//
//  Created by jun on 2021/10/21.
//

import UIKit
import SnapKit
import DragCardContainer

//public class CardCell: DragCardCell {
//    public lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 20)
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    public required init(reuseIdentifier: String) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        backgroundColor = .orange
//        layer.cornerRadius = 5.0
//        layer.borderWidth = 1.0
//        layer.borderColor = UIColor.black.cgColor
//        layer.masksToBounds = true
//
//        addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//}
