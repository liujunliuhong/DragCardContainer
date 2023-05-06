//
//  DetailViewController.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/3/6.
//

import UIKit
import SnapKit


public final class DetailViewController: UIViewController {

    public private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 60)
        label.numberOfLines = 0
        return label
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Detail Page"
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
