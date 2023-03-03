//
//  DragCardView.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/3/3.
//

import Foundation
import UIKit

open class DragCardView: UIView {
    
    public lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
        setupUI()
    }
}

extension DragCardView {
    open override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }
}

extension DragCardView {
    private func initUI() {
        
    }
    
    private func setupUI() {
        addSubview(contentView)
    }
}
