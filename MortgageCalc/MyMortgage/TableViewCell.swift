//
//  TableViewCell.swift
//  MyMortgage
//
//  Created by Priya on 24/01/2017.
//  Copyright © 2017 Dunlysis. All rights reserved.
//

import UIKit


class TableViewCell:UICollectionViewCell {
    var contentLbl:UILabel!
    var didSetupConstraints = false

        override init(frame: CGRect) {
            super.init(frame: frame)
    
            self.setupCell()
            self.customize()
            self.setNeedsUpdateConstraints()
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentLbl = UILabel()
        contentView.addSubview(contentLbl)
    }

    func customize() {
        contentView.backgroundColor = UIColor().themeBackgroundColor
    }
    
    func render(text: String, atIndex: NSIndexPath) {
        contentLbl.font = UIFont.systemFont(ofSize: 13)
        contentLbl.textColor = UIColor.black
        contentLbl.text = text
        contentLbl.numberOfLines = 0
        contentLbl.font = UIFont.smallFont()
        if (atIndex as NSIndexPath).section == 0 {
            contentView.backgroundColor = UIColor().borderColor
        } else {
            if ((atIndex as NSIndexPath).section)%2 == 0 {
                contentView.backgroundColor = UIColor().columnColor
            } else {
                contentView.backgroundColor = UIColor().primaryBackgroundColor
            }
        }
    }
    
    override func updateConstraints() {
        if (!didSetupConstraints) {
            contentLbl.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}
