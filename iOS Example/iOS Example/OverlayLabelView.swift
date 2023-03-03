//
//  OverlayLabelView.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/3/3.
//

import UIKit
import SnapKit

public final class OverlayLabelView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    public init(withTitle title: String, color: UIColor) {
        super.init(frame: CGRect.zero)
        
        layer.borderColor = color.cgColor
        layer.borderWidth = 4
        layer.cornerRadius = 4
        
        addSubview(titleLabel)
        titleLabel.textColor = color
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       attributes: NSAttributedString.Key.overlayAttributes)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

extension NSAttributedString.Key {
    fileprivate static var overlayAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 42)!,NSAttributedString.Key.kern: 5.0]
}
