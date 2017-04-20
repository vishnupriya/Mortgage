//
//  GraphViewController.swift
//  MyMortgage
//
//  Created by Priya on 16/12/2016.
//  Copyright © 2016 Dunlysis. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController, UIScrollViewDelegate, ChartViewDelegate {
    let mortgageAmount: Double!
    let deposit: Double!
    let interest: Double!
    let years: Double!
    
    var mortgageBalanceArray = [Double]()
    var yearArray = [String]()
    var monthlyMortgageAmount:Double!
    
    var mortgageInterestRates = [String]()
    var monthlyPaymentForDifferentRates = [Double]()

    var scrollView: UIScrollView!
    var contentView: UIView!
    var mortgageDetailsHeaderLbl: UILabel!
    var mortgageDetailsLbl: UILabel!
    var resultLabel: UILabel!
    var mortgageBalanceView: UIView!
    var mortgageBalanceLbl: UILabel!
    var lineChartView: LineChartView!
    
    var monthlyMortgageView: UIView!
    var monthlyMortgageLbl: UILabel!
    var barChartView: BarChartView!

    var didSetupConstraints = false
    
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
    
    var mathPowMonths:Double {
        get {
            return Double(pow(Double(1+interestRatePerMonth),Double(12)))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        setupView()
        customize()
        view.setNeedsUpdateConstraints()
        
        calulateMortgageBalance()
        render()

        //Mortgage remaining chart
        setChart(dataPoints: yearArray, values:mortgageBalanceArray)
        //END - Mortgage remaining chart
        
        calculateMonthlyPaymentForDifferentRates()
        setBarChart(dataPoints: mortgageInterestRates, values: monthlyPaymentForDifferentRates)
     }
    
    //override func viewWillAppear(_ animated: Bool) {
      //  super.viewWillAppear(animated)
        //let value = UIInterfaceOrientation.landscapeLeft.rawValue
        //UIDevice.current.setValue(value, forKey: "orientation")
    //}
    
    func setupView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        
        mortgageDetailsHeaderLbl = UILabel()
        contentView.addSubview(mortgageDetailsHeaderLbl)
        
        mortgageDetailsLbl = UILabel()
        contentView.addSubview(mortgageDetailsLbl)
        
        resultLabel = UILabel()
        contentView.addSubview(resultLabel)
        
        mortgageBalanceView = UIView()
        contentView.addSubview(mortgageBalanceView)
        
        mortgageBalanceLbl = UILabel()
        mortgageBalanceView.addSubview(mortgageBalanceLbl)
        
        lineChartView = LineChartView()
        lineChartView.delegate = self
        mortgageBalanceView.addSubview(lineChartView)
        
        monthlyMortgageView = UIView()
        contentView.addSubview(monthlyMortgageView)
       
        monthlyMortgageLbl = UILabel()
        monthlyMortgageView.addSubview(monthlyMortgageLbl)
 
        barChartView = BarChartView()
        monthlyMortgageView.addSubview(barChartView)

    }
    
    func render () {
        mortgageBalanceLbl.text = "Mortgage Amount Over Years"
        monthlyMortgageLbl.text = "Monthly Mortgage For Different Interest Rates"
        mortgageDetailsHeaderLbl.text = "Mortgage Details"
        mortgageDetailsLbl.text = ("Mortgage amount : \(String(Int(self.mortgageAmount-self.deposit))) \n Interest : \(String(Int(self.interest))) \n Years : \(String(Int(self.years)))")
        resultLabel.text = ("Monthly mortgage : \(String(Int(self.monthlyMortgageAmount)))")
    }
    
    func customize () {
        view.backgroundColor = UIColor().themeBackgroundColor
        mortgageBalanceView.layer.borderColor = UIColor().borderColor.cgColor
        mortgageBalanceView.layer.borderWidth = 5.0
        
        mortgageBalanceLbl.font = UIFont.boldFont()
        
        lineChartView.doubleTapToZoomEnabled = false
        //        lineChartView.highlightPerTapEnabled = false
        //        lineChartView.highlightPerDragEnabled = false
        //        lineChartView.leftAxis.drawAxisLineEnabled = false
        //        lineChartView.rightAxis.drawAxisLineEnabled = false
        //        lineChartView.legend.enabled = false
        
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.labelPosition = .bottom
        
        
        monthlyMortgageView.layer.borderColor = UIColor().borderColor.cgColor
        monthlyMortgageView.layer.borderWidth = 5.0
        monthlyMortgageLbl.font = UIFont.boldFont()
        
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.doubleTapToZoomEnabled = false
        
        mortgageDetailsHeaderLbl.font = UIFont.boldFont()
        mortgageDetailsLbl.font = UIFont.normalFont()
        mortgageDetailsLbl.numberOfLines = 0
        resultLabel.font = UIFont.boldFont()

    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var yValues : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< dataPoints.count {
        yValues.append(ChartDataEntry(x: Double(i + 1), y: values[i]))
        }
        
        let data = LineChartData()
        let ds = LineChartDataSet(values: yValues, label: "Years")
        
        data.addDataSet(ds)
        self.lineChartView.data = data
    }
    
    func setBarChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Mortgage amount")
        let chartData = BarChartData(dataSets: [chartDataSet])
        barChartView.data = chartData
        
        barChartView.chartDescription?.text = "Interest rate"
        
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        
        barChartView.xAxis.labelPosition = .bottom
        
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
        let ll = ChartLimitLine(limit: 10.0, label: "Target")
        barChartView.rightAxis.addLimitLine(ll)
        
    }

    override func updateViewConstraints() {
        let viewHeight = view.frame.height + 40

        if (!didSetupConstraints) {
            scrollView.snp.makeConstraints { make in
                make.top.equalTo(view.snp.top)
                make.left.equalTo(view.snp.left)
                make.right.equalTo(view.snp.right)
                make.bottom.equalTo(view.snp.bottom)
            }
            contentView.snp.makeConstraints { make in
                make.top.equalTo(scrollView.snp.top)
                make.left.equalTo(view.snp.left)
                make.right.equalTo(view.snp.right)
                make.bottom.equalTo(view.snp.bottom)
            }
            
            mortgageDetailsHeaderLbl.snp.makeConstraints({ make in
                make.top.equalTo(contentView.snp.top).offset(10)
                make.left.equalTo(contentView).offset(20)
                make.right.equalTo(contentView).offset(-20)
            })
            
            mortgageDetailsLbl.snp.makeConstraints({ make in
                make.top.equalTo(mortgageDetailsHeaderLbl.snp.bottom).offset(10)
                make.left.equalTo(contentView).offset(20)
                make.right.equalTo(contentView).offset(-20)
            })
            
            resultLabel.snp.makeConstraints { make in
                make.top.equalTo(mortgageDetailsLbl.snp.bottom).offset(10)
//                make.centerX.equalTo(contentView.snp.centerX)
                make.left.equalTo(contentView).offset(20)
                make.right.equalTo(contentView).offset(-20)
            }
            
            mortgageBalanceView.snp.makeConstraints { make in
                make.top.equalTo(resultLabel.snp.bottom).offset(20)
                make.left.equalTo(contentView).offset(10)
                make.right.equalTo(contentView).offset(-10)
                make.height.equalTo(viewHeight)
            }
            
            mortgageBalanceLbl.snp.makeConstraints { make in
                make.top.equalTo(mortgageBalanceView.snp.top).offset(20)
                make.centerX.equalTo(mortgageBalanceView.snp.centerX)

//                make.left.equalTo(mortgageBalanceView).offset(20)
//                make.right.equalTo(mortgageBalanceView).offset(-20)
            }
            
            
            lineChartView.snp.makeConstraints { make in
                make.top.equalTo(mortgageBalanceLbl.snp.bottom).offset(20)
                make.left.equalTo(mortgageBalanceView).offset(10)
                make.right.equalTo(mortgageBalanceView).offset(-10)
                make.bottom.equalTo(mortgageBalanceView.snp.bottom)
            }
            
            monthlyMortgageView.snp.makeConstraints { make in
                make.top.equalTo(mortgageBalanceView.snp.bottom).offset(20)
                make.left.equalTo(contentView).offset(10)
                make.right.equalTo(contentView).offset(-10)
                make.bottom.equalTo(scrollView.snp.bottom).offset(-100)
                make.height.equalTo(viewHeight)
            }
            
            monthlyMortgageLbl.snp.makeConstraints { make in
                make.top.equalTo(monthlyMortgageView.snp.top).offset(20)
                make.centerX.equalTo(monthlyMortgageView.snp.centerX)
                
                //                make.left.equalTo(mortgageBalanceView).offset(20)
                //                make.right.equalTo(mortgageBalanceView).offset(-20)
            }
            
            
            barChartView.snp.makeConstraints { make in
                make.top.equalTo(monthlyMortgageLbl.snp.bottom).offset(20)
                make.left.equalTo(monthlyMortgageView).offset(20)
                make.right.equalTo(monthlyMortgageView).offset(-20)
                make.bottom.equalTo(monthlyMortgageView.snp.bottom)
            }
            
        didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
        
    func calulateMortgageBalance() {
        let date = NSDate()
        let calendar = NSCalendar.current
        let componentYear = calendar.component(.year, from: date as Date)

        var balanceYear:Int = componentYear
        var mortgageBalance:Double = (self.mortgageAmount-self.deposit)
        var totalMonths = years*12
        var mathPowTotalMonths = Double(pow(Double(1+interestRatePerMonth),Double(totalMonths)))
        var h2 = mathPowTotalMonths-1
        let g2 = interestRatePerMonth*mathPowTotalMonths
        
        monthlyMortgageAmount = mortgageBalance*(g2/h2);
        
        //Mortgage Remaining chart
        mortgageBalanceArray.append(mortgageBalance)
        yearArray.append(String(balanceYear))
        //END - Mortgage Remaining chart
        
        for _ in 1...Int(years-1) {
            balanceYear = balanceYear+1
            totalMonths = totalMonths-12
            mathPowTotalMonths = Double(pow(Double(1+interestRatePerMonth),Double(totalMonths)))
            h2 = mathPowTotalMonths-1
            mortgageBalance = mortgageBalance*((mathPowTotalMonths-mathPowMonths)/h2)
            
            //Mortgage remaining chart
            mortgageBalanceArray.append(mortgageBalance)
            yearArray.append(String(balanceYear))
            //END - Mortgage remaining chart

        }
    }
    
    func calculateMonthlyPaymentForDifferentRates() {
        let interestsamplecount = 25;
        let interestrateincrement = 0.5;
        var initialinterestrate = 0.5;
        
        var interestPerMonth =  self.interestRatePerMonth
        let totalMonths = years*12;
        var mathPowTotalMonths = Double(pow(Double(1+interestPerMonth),Double(totalMonths)))
        var g2 = interestPerMonth*mathPowTotalMonths
        var h2 = mathPowTotalMonths-1
        let mortgageBalance:Double = (self.mortgageAmount-self.deposit)
        var mortgagemonthlypayment = mortgageBalance*(g2/h2);

        for _ in 1...Int(interestsamplecount-1){
            interestPerMonth = initialinterestrate/(100*12)

            mathPowTotalMonths = Double(pow(Double(1+interestPerMonth),Double(totalMonths)))
            g2 = interestPerMonth*mathPowTotalMonths
            h2 = mathPowTotalMonths-1
            mortgagemonthlypayment = mortgageBalance*(g2/h2);
            
            mortgageInterestRates.append(String(initialinterestrate))
            monthlyPaymentForDifferentRates.append(mortgagemonthlypayment)

            initialinterestrate = initialinterestrate + interestrateincrement;
        }

    }
}

