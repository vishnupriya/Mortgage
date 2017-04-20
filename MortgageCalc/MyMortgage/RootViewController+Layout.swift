//
//  RootViewController+Layout.swift
//  MyMortgage
//
//  Created by Priya on 15/12/2016.
//  Copyright © 2016 Dunlysis. All rights reserved.
//

import UIKit

extension RootViewController {
        
    override func updateViewConstraints() {
        let fieldHeight = 40
        let edgeInset = 40
        let vInset = 20
        let hInset = 20
        let fieldWidth = 140

        if (!didSetupConstraints) {
            contentView.snp.makeConstraints { make in
                make.left.right.equalTo(view)
                make.top.equalTo(view).offset(edgeInset)
                make.bottom.equalTo(view)
            }
            
            mortgageView.snp.makeConstraints { make in
                make.left.equalTo(view).offset(edgeInset)
                make.centerY.equalTo(view.snp.centerY)
                make.centerX.equalTo(view.snp.centerX)
            }
            
            headerLbl.snp.makeConstraints { make in
                make.top.equalTo(mortgageView).offset(edgeInset+vInset)
                make.centerX.equalTo(view.snp.centerX)
            }
            
            totalAmountLbl.snp.makeConstraints { make in
                make.top.equalTo(headerLbl.snp.bottom).offset(50)
                make.left.equalTo(mortgageView).offset(hInset)
            }
            
            totalAmount.snp.makeConstraints { make in
                make.centerY.equalTo(totalAmountLbl.snp.centerY)
                make.left.equalTo(mortgageView.snp.centerX).offset(-hInset)
                make.width.equalTo(fieldWidth)
                make.height.equalTo(fieldHeight)
            }
            
            interestLbl.snp.makeConstraints { make in
                make.top.equalTo(totalAmount.snp.bottom).offset(vInset)
                make.left.equalTo(mortgageView).offset(hInset)
            }
            
            interest.snp.makeConstraints { make in
                make.centerY.equalTo(interestLbl.snp.centerY)
                make.left.equalTo(mortgageView.snp.centerX).offset(-hInset)
                make.width.equalTo(fieldWidth)
                make.height.equalTo(fieldHeight)
            }
            
            depositLbl.snp.makeConstraints { make in
                make.top.equalTo(interest.snp.bottom).offset(vInset)
                make.left.equalTo(mortgageView).offset(hInset)
            }
            
            deposit.snp.makeConstraints { make in
                make.centerY.equalTo(depositLbl.snp.centerY)
                make.left.equalTo(mortgageView.snp.centerX).offset(-hInset)
                make.width.equalTo(fieldWidth)
                make.height.equalTo(fieldHeight)
            }
            
            numberOfYearsLbl.snp.makeConstraints { make in
                make.top.equalTo(deposit.snp.bottom).offset(vInset)
                make.left.equalTo(mortgageView).offset(hInset)
            }
            
            numberOfYears.snp.makeConstraints { make in
                make.centerY.equalTo(numberOfYearsLbl.snp.centerY)
                make.left.equalTo(mortgageView.snp.centerX).offset(-hInset)
                make.width.equalTo(fieldWidth)
                make.height.equalTo(fieldHeight)
            }
            
            calculateBtn.snp.makeConstraints { make in
                make.top.equalTo(numberOfYears.snp.bottom).offset(vInset)
                make.centerX.equalTo(mortgageView)
                make.height.equalTo(fieldHeight)
                make.width.equalTo(200)
                make.bottom.equalTo(mortgageView).offset(-vInset)
            }
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

}
