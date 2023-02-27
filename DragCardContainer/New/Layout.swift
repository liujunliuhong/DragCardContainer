//
//  Layout.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/2/27.
//

import Foundation
import UIKit


internal final class Layout: UICollectionViewLayout {
    
    private var mCollectionView: UICollectionView {
        guard let collectionView = collectionView else {
            fatalError("`collectionView` should not be `nil`")
        }
        return collectionView
    }
    
    private lazy var modeState: ModeState = {
        let modeState = ModeState(layout: self)
        return modeState
    }()
    
    internal override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension Layout {
    internal override func prepare() {
        super.prepare()
        
        let numberOfItems = mCollectionView.numberOfItems(inSection: 0)
        
        var itemModels: [ItemModel] = []
        for _ in 0..<numberOfItems {
            let itemModel = ItemModel()
            itemModels.append(itemModel)
        }
        modeState.setItemModels(itemModels)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width * 10,
                      height: UIScreen.main.bounds.size.height * 2)
    }
    
    internal override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    internal override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attrs: [UICollectionViewLayoutAttributes] = []
        
        for index in 0..<modeState.itemModels.count {
            if index == 0 {
                let indexPath = IndexPath(item: index, section: 0)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attr.frame = mCollectionView.bounds
//                attr.transform = CGAffineTransform(translationX: mCollectionView.contentOffset.x,
//                                                   y: mCollectionView.contentOffset.y)
                attrs.append(attr)
            }
        }
        
        
        
        return attrs
    }
}
