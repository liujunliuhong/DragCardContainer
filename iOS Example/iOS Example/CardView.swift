//
//  CardView.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/3/3.
//

import UIKit
import SnapKit
import DragCardContainer

public final class CardView: DragCardView {
    public private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 60)
        label.numberOfLines = 0
        return label
    }()
    
    public private(set) lazy var overlayView: CardOverlayView = {
        let overlayView = CardOverlayView()
        overlayView.isUserInteractionEnabled = false
        return overlayView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        setupUI()
        bindViewModel()
        other()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardView {
    private func initUI() {
        backgroundColor = .orange
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
    }
    
    private func setupUI() {
        contentView.addSubview(label)
        contentView.addSubview(overlayView)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        
    }
    
    private func other() {
        
    }
}
