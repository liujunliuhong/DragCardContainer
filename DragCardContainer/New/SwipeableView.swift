//
//  SwipeableView.swift
//  DragCardContainer
//
//  Created by dfsx6 on 2023/2/27.
//

import UIKit

public final class SwipeableView: UIView {
    
    private lazy var layout: Layout = {
        let layout = Layout()
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SwipeableCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(SwipeableCell.classForCoder()))
        collectionView.clipsToBounds = false
        return collectionView
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

extension SwipeableView {
    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
}

extension SwipeableView {
    private func initUI() {
        
    }
    
    private func setupUI() {
        addSubview(collectionView)
    }
}

extension SwipeableView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(SwipeableCell.classForCoder()), for: indexPath) as? SwipeableCell else { return UICollectionViewCell() }
        cell.label.text = "\(indexPath.item)"
        return cell
    }
}

extension SwipeableView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Did Select Item: \(indexPath.item)")
    }
}
