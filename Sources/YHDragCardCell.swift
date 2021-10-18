//
//  YHDragCardCell.swift
//  Pods
//
//  Created by apple on 2020/4/21.
//

import UIKit

@objc open class YHDragCardCell: UIView {
    @objc public let reuseIdentifier: String
    @objc public init(reuseIdentifier: String) {
        self.reuseIdentifier = reuseIdentifier
        super.init(frame: .zero)
        self.yh_reuseIdentifier = reuseIdentifier
        self.yh_internalIdentifier = UUID().uuidString
        self.yh_is_reuse = false
    }
    //@IBInspectable
    open override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @available(iOS, unavailable)
    @objc public override init(frame: CGRect) {
        self.reuseIdentifier = ""
        super.init(frame: frame)
    }
    
    @available(iOS, unavailable)
    @objc public init() {
        self.reuseIdentifier = ""
        super.init(frame: .zero)
    }
    
    @available(iOS, unavailable)
    @objc public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
