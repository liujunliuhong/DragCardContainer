//
//  BottomView.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/3/6.
//

import UIKit
import SnapKit

public final class BottomView: UIView {
    
    public private(set) lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "heart"), for: .normal)
        return button
    }()
    
    public private(set) lazy var passButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "pass"), for: .normal)
        return button
    }()
    
    public private(set) lazy var superLikeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "lightning"), for: .normal)
        return button
    }()
    
    public private(set) lazy var refreshButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "refresh"), for: .normal)
        return button
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BottomView {
    private func initUI() {
        
    }
    
    private func setupUI() {
        let buttons = [refreshButton, passButton, superLikeButton, likeButton]
        var leftButton: UIButton?
        for button in buttons {
            addSubview(button)
            if leftButton == nil {
                button.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.width.equalTo(50)
                }
            } else {
                button.snp.makeConstraints { make in
                    make.left.equalTo(leftButton!.snp.right).offset(20)
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.width.equalTo(50)
                }
            }
            leftButton = button
        }
        
        if leftButton != nil {
            leftButton!.snp.makeConstraints { make in
                make.right.equalToSuperview()
            }
        }
    }
}
