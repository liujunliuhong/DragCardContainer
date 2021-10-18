//
//  OtherDemoCell.swift
//  YHDragContainer
//
//  Created by apple on 2020/4/22.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
//import YHDragCardSwift

class OtherDemoCell: YHDragCardCell {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.masksToBounds = true
        
        self.addSubview(self.imageView)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
    }
}

extension OtherDemoCell {
    public func set(image: UIImage?) {
        self.imageView.image = image
    }
}

