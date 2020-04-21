//
//  DemoCell.swift
//  YHDragContainer
//
//  Created by apple on 2020/4/21.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import YHDragCardSwift

@objc public class DemoCell: YHDragCardCell {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    @objc public override init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .orange
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.masksToBounds = true
        
        self.addSubview(self.label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = self.bounds
    }
}

extension DemoCell {
    @objc public func set(title: String) {
        self.label.text = title
    }
}
