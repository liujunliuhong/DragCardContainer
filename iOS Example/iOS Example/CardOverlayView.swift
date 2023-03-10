//
//  CardOverlayView.swift
//  iOS Example
//
//  Created by galaxy on 2023/3/3.
//

import UIKit
import DragCardContainer
import SnapKit

public final class CardOverlayView: UIView {
    
    public private(set) lazy var nopeView: OverlayLabelView = {
        let nopeView = OverlayLabelView(withTitle: "NOPE",
                                        color: UIColor(red: 252.0 / 255.0, green: 70.0 / 255.0, blue: 93.0 / 255.0, alpha: 1.0))
        return nopeView
    }()
    
    public private(set) lazy var likeView: OverlayLabelView = {
        let likeView = OverlayLabelView(withTitle: "LIKE",
                                        color: UIColor(red: 49.0 / 255.0, green: 193.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0))
        return likeView
    }()
    
    public private(set) lazy var superLikeView: OverlayLabelView = {
        let superLikeView = OverlayLabelView(withTitle: "SUPER\nLIKE",
                                             color: UIColor(red: 52 / 255, green: 154 / 255, blue: 254 / 255, alpha: 1))
        return superLikeView
    }()
    
    public init(direction: Direction) {
        super.init(frame: .zero)
        
        switch direction {
            case .left:
                addSubview(nopeView)
                nopeView.snp.makeConstraints { make in
                    make.right.equalToSuperview().offset(-20)
                    make.top.equalToSuperview().offset(20)
                }
            case .up:
                addSubview(superLikeView)
                superLikeView.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().offset(-20)
                    make.centerX.equalToSuperview()
                }
            case .right:
                addSubview(likeView)
                likeView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(20)
                    make.left.equalToSuperview().offset(20)
                }
            default:
                break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

