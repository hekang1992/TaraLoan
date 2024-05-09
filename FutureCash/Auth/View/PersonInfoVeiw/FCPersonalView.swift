//
//  FCPersonalView.swift
//  FutureCash
//
//  Created by apple on 2024/5/8.
//

import UIKit

class FCPersonalView: UIView {
    
    var block: (() -> Void)?
    
    var block1: (() -> Void)?
    
    var modelArray: [ExceptModel]?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .clear
        return bgView
    }()
    
    lazy var iconImageView1: UIImageView = {
        let iconImageView1 = UIImageView()
        iconImageView1.contentMode = .scaleAspectFill
        iconImageView1.clipsToBounds = true
        iconImageView1.image = UIImage(named: "bg1")
        iconImageView1.isUserInteractionEnabled = true
        return iconImageView1
    }()
    
    lazy var iconImageView2: UIImageView = {
        let iconImageView2 = UIImageView()
        iconImageView2.image = UIImage(named: "personalImage")
        iconImageView2.isUserInteractionEnabled = true
        return iconImageView2
    }()
    
    lazy var downImageView: UIImageView = {
        let downImageView = UIImageView()
        downImageView.image = UIImage(named: "down")
        midImageView.isUserInteractionEnabled = true
        return downImageView
    }()
    
    lazy var midImageView: UIImageView = {
        let midImageView = UIImageView()
        midImageView.image = UIImage(named: "middle")
        midImageView.isUserInteractionEnabled = true
        return midImageView
    }()
    
    lazy var upImageView: UIImageView = {
        let upImageView = UIImageView()
        upImageView.image = UIImage(named: "upimage")
        upImageView.isUserInteractionEnabled = true
        return upImageView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(FCWenBenCell.self, forCellReuseIdentifier: "FCWenBenCell")
        tableView.register(FCGenderCell.self, forCellReuseIdentifier: "FCGenderCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(iconImageView1)
        iconImageView1.addSubview(iconImageView2)
        iconImageView1.addSubview(downImageView)
        iconImageView1.addSubview(midImageView)
        iconImageView1.addSubview(upImageView)
        iconImageView1.addSubview(tableView)
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        iconImageView1.snp.makeConstraints { make in
            make.edges.equalTo(bgView)
        }
        
        upImageView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView2.snp.bottom).offset(6.px())
            make.left.right.equalTo(iconImageView1)
            make.height.equalTo(95.px())
        }
        downImageView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(iconImageView1)
            make.height.equalTo(95.px())
        }
        midImageView.snp.makeConstraints { make in
            make.top.equalTo(upImageView.snp.bottom)
            make.bottom.equalTo(downImageView.snp.top)
            make.left.right.equalTo(iconImageView1)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(upImageView.snp.top).offset(30.px())
            make.bottom.equalTo(downImageView.snp.bottom).offset(-10.px())
            make.left.right.equalTo(iconImageView1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let vc = self.viewController  {
            let height = UIViewController.getTopBarHeights(for: vc)
            iconImageView2.snp.makeConstraints { make in
                make.centerX.equalTo(bgView)
                make.size.equalTo(CGSizeMake(363.px(), 105.px()))
                make.top.equalTo(height.totalHeight + 4.px())
            }
        }
    }
}

extension FCPersonalView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = UIView()
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "fpnfitbtn"), for: .normal)
        btn.addTarget(self, action: #selector(conFirmClick), for: .touchUpInside)
        footView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerX.bottom.equalTo(footView)
            make.height.equalTo(86.px())
            make.width.equalTo(183.px())
        }
        return footView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 120.px()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let modelArray = modelArray else { return UITableViewCell() }
        let model = modelArray[indexPath.row]
        switch (model.ourselves, model.conceive) {
        case ("f1", "similar"):
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FCGenderCell", for: indexPath) as? FCGenderCell {
                configureGenderCell(cell, with: model)
                return cell
            }
        case ("f1", _),("f2", _), (_, _):
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FCWenBenCell", for: indexPath) as? FCWenBenCell {
                configureCell(cell, with: model)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func configureGenderCell(_ cell: FCGenderCell, with model: ExceptModel) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.model = model
    }
    
    func configureCell(_ cell: FCWenBenCell, with model: ExceptModel) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.model = model
        if model.ourselves == "f1" && model.conceive != "similar" {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "Slicexialee")
            imageView.contentMode = .center
            imageView.frame = CGRect(x: 0, y: 0, width: 25.px(), height: 25.px())
            cell.nameField.rightView = imageView
            cell.nameField.rightViewMode = .always
        }
    }
    
    @objc func conFirmClick() {
        
    }
    
}
