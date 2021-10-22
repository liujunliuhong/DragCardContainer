//
//  ViewController.swift
//  DragCardContainer
//
//  Created by jun on 2021/10/19.
//

import UIKit

public class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(_Cell.classForCoder(), forCellReuseIdentifier: "cellID")
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .always
        }
        return tableView
    }()
    
    private var dataSource: [Model] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Demo"
        automaticallyAdjustsScrollViewInsets = true
        view.addSubview(tableView)
        
        self.dataSource = [Model(title: "水平方向滑动（屏幕可旋转）", vc: HorizontalDragViewController.self),
                           Model(title: "垂直方向滑动（屏幕可旋转）", vc: VerticalDragViewController.self),
                           Model(title: "无限滑动（屏幕可旋转）", vc: InfiniteLoopDragViewController.self),
                           Model(title: "只有一个数据源，仍可撤销（屏幕可旋转）", vc: OnlyOneViewController.self),
                           Model(title: "完整示例", vc: FullFunctionViewController.self)]
        self.tableView.reloadData()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as? _Cell
        let model = dataSource[indexPath.row]
        cell?.titleLabel.text = model.title
        return cell ?? UITableViewCell()
    }
}

extension ViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataSource[indexPath.row]
        let vc = model.vc.init()
        vc.navigationItem.title = model.title
        navigationController?.pushViewController(vc, animated: true)
    }
}

fileprivate class _Cell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 15, y: 0, width: bounds.size.width - 15 - 15, height: bounds.size.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
