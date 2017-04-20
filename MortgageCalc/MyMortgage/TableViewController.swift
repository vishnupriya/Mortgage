//
//  TableViewController.swift
//  MyMortgage
//
//  Created by Priya on 24/01/2017.
//  Copyright © 2017 Dunlysis. All rights reserved.
//

import UIKit

class TableViewController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let mortgageAmount: Double!
    let deposit: Double!
    let interest: Double!
    let years: Double!
    
    var collectionView: UICollectionView!
    var didSetupConstraints = false
    
    var mortgageBalanceArray = [MortgageFields]()
    
    var yearArray = [String]()
    var monthlyMortgageAmount:Double!
    let layout: CustomCollectionViewLayout = CustomCollectionViewLayout()


    init(mortgageAmount: Double, deposit: Double, interest: Double, years:Double) {
        self.mortgageAmount = mortgageAmount
        self.deposit = deposit
        self.interest = interest
        self.years = years
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var interestRatePerMonth:Double {
        get {
            return self.interest/(100*12)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor().themeBackgroundColor
        
                collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
                collectionView.dataSource = self
                collectionView.delegate = self
                collectionView.register(TableViewCell.self, forCellWithReuseIdentifier: "Cell")
        
                collectionView.backgroundColor = UIColor.white
                self.view.addSubview(collectionView)
        
        view.setNeedsUpdateConstraints()
        
        calulateMortgageData()

    }

    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            collectionView.snp.makeConstraints { make in
                make.top.equalTo(view.snp.top)
                
                make.bottom.equalTo(view.snp.bottom)
                if UIDevice.current.userInterfaceIdiom == .pad {
                    make.width.equalTo(700)
                    make.center.equalToSuperview()
                } else {
                    make.left.equalTo(view.snp.left)
                    make.right.equalTo(view.snp.right)
                }
            }
            didSetupConstraints = true

        }
        super.updateViewConstraints()
    }
    
    override func viewWillLayoutSubviews () {
        super.viewWillLayoutSubviews()
        collectionView.contentSize = layout.collectionViewContentSize
        collectionView.layoutIfNeeded()
    }

    
    func calulateMortgageData() {
        let date = NSDate()
        let calendar = NSCalendar.current
        let componentYear = calendar.component(.year, from: date as Date)
        
        var balanceYear:Int = componentYear
        var mortgageBalance:Double = (self.mortgageAmount-self.deposit)
        var totalMonths = years*12
        var mathPowTotalMonths = Double(pow(Double(1+interestRatePerMonth),Double(totalMonths)))
        var h2 = mathPowTotalMonths-1
        var g2 = interestRatePerMonth*mathPowTotalMonths
        var mathPowMonths = Double(pow(Double(1+interestRatePerMonth),Double(12)))
        
        monthlyMortgageAmount = mortgageBalance*(g2/h2);
        
        mortgageBalanceArray.append(MortgageFields(year: balanceYear, prinicipalPayment:0, mortgageBalance:mortgageBalance, interestPayment:0, totalPayment:0))
        
        var mortgageAmountTemp = mortgageBalance
        mortgageBalance = 0

        for index in 0...Int(years-1) {
            if index > 0 {
                balanceYear = balanceYear+1
                totalMonths = totalMonths-12
                mathPowTotalMonths = Double(pow(Double(1+interestRatePerMonth),Double(totalMonths)))
                mathPowMonths = Double(pow(Double(1+interestRatePerMonth),Double(12)))
                h2 = mathPowTotalMonths-1
                g2 = interestRatePerMonth*mathPowTotalMonths
                mortgageAmountTemp = mortgageBalance
            }
            /*******************************************
             * Mortgage Yearly Payment after each year *
             *******************************************/
            let mortgageMonthlyPayment = mortgageAmountTemp*(g2/h2)
            let mortgageYearlyPayment = mortgageMonthlyPayment*12
            
            /************************************
             * Mortgage Balance after each year *
             ************************************/
            mortgageBalance = mortgageAmountTemp*((mathPowTotalMonths-mathPowMonths)/h2)
            
            /*******************************************
             * Mortgage Cumulative Principal Payment   *
             * after each year 						   *
             *******************************************/
            let mortgagePayment = (self.mortgageAmount-deposit) - mortgageBalance
            
            /*******************************************
             * Mortgage Cumulative Interest Payment   *
             * after each year 						   *
             *******************************************/
            let totalPayment = mortgageYearlyPayment*(Double(index)+1);
            let interestPayment = totalPayment - mortgagePayment

            //print("balanceYear : \(balanceYear) mortgagePayment: \(mortgagePayment) mortgageBalance: \(mortgageBalance) interestPayment: \(interestPayment) totalPayment : \(totalPayment)")
            mortgageBalanceArray.append(MortgageFields(year: balanceYear, prinicipalPayment:mortgagePayment, mortgageBalance:mortgageBalance, interestPayment:interestPayment, totalPayment:totalPayment))
        }
    }
    
        // MARK: - UICollectionViewDataSource protocol
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mortgageBalanceArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    
    //func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
      //      return CGSize(width: view.frame.width-20, height: 200);
        //}
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! TableViewCell
            let mortgageField = mortgageBalanceArray[(indexPath as NSIndexPath).section]
            if (indexPath as NSIndexPath).section == 0 {
                if (indexPath as NSIndexPath).row == 0 {
                    cell.render(text: "Year", atIndex:indexPath as NSIndexPath)
                } else if (indexPath as NSIndexPath).row == 1 {
                    cell.render(text: "Prinicipal \n   Paid", atIndex:indexPath as NSIndexPath)
                } else if (indexPath as NSIndexPath).row == 2 {
                    cell.render(text: "Mortgage \nBalance", atIndex:indexPath as NSIndexPath)
                } else if (indexPath as NSIndexPath).row == 3 {
                    cell.render(text: "Interest \nPayment", atIndex:indexPath as NSIndexPath)
                } else if (indexPath as NSIndexPath).row == 4 {
                    cell.render(text: "Total \nPayment", atIndex:indexPath as NSIndexPath)
                }
            } else {
                if (indexPath as NSIndexPath).row == 0 {
                    cell.render(text: String(mortgageField.year) , atIndex:indexPath as NSIndexPath)
                } else if (indexPath as NSIndexPath).row == 1 {
                    cell.render(text: String(format:"%.01f", mortgageField.prinicipalPayment) , atIndex:indexPath as NSIndexPath)
                } else if (indexPath as NSIndexPath).row == 2 {
                    cell.render(text: String(format:"%.01f", mortgageField.mortgageBalance), atIndex:indexPath as NSIndexPath)
                } else if (indexPath as NSIndexPath).row == 3 {
                    cell.render(text: String(format:"%.01f", mortgageField.interestPayment), atIndex:indexPath as NSIndexPath)
                } else if (indexPath as NSIndexPath).row == 4 {
                    cell.render(text: String(format:"%.01f", mortgageField.totalPayment), atIndex:indexPath as NSIndexPath)
                }
            }
            return cell
        }
    
        // MARK: - UICollectionViewDelegate protocol
        func collectionView(_ collectionView: UICollectionView,
                            didSelectItemAt indexPath: IndexPath) {
            print("You selected cell #\(indexPath.item)!")
        }
    

}

struct MortgageFields {
    let year:Int!
    let prinicipalPayment:Double!
    let mortgageBalance:Double!
    let interestPayment:Double!
    let totalPayment:Double!
    
    init(year:Int, prinicipalPayment:Double, mortgageBalance:Double, interestPayment:Double, totalPayment:Double) {
        self.year = year
        self.prinicipalPayment = prinicipalPayment
        self.mortgageBalance = mortgageBalance
        self.interestPayment = interestPayment
        self.totalPayment = totalPayment
    }
}
