//
//  YHDragCardCell.swift
//  Pods
//
//  Created by apple on 2020/4/21.
//

import UIKit

open class YHDragCardCell: UIView {
    public let reuseIdentifier: String
    public init(reuseIdentifier: String) {
        self.reuseIdentifier = reuseIdentifier
        super.init(frame: .zero)
        self.yh_set(reuseIdentifier: reuseIdentifier)
    }
    
    internal override init(frame: CGRect) {
        self.reuseIdentifier = ""
        super.init(frame: frame)
    }
    
    internal init() {
        self.reuseIdentifier = ""
        super.init(frame: .zero)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
