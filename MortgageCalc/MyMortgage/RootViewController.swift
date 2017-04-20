//
//  RootViewController.swift
//  MyMortgage
//
//  Created by Priya on 21/08/2016.
//  Copyright © 2016 Dunlysis. All rights reserved.
//

import UIKit
import SnapKit

class RootViewController: UIViewController {
    
    // MARK: Properties
    let viewModel:RootViewModel
    var contentView: ContentView!
    var mortgageView: UIView!
    var headerLbl: UILabel!
    
    var totalAmountLbl: UILabel!
    var interestLbl: UILabel!
    var depositLbl: UILabel!
    var numberOfYearsLbl: UILabel!
    
    var totalAmount: UITextField!
    var interest: UITextField!
    var deposit: UITextField!
    var numberOfYears: UITextField!

    var calculateBtn: UIButton!
    var mortgageVC:MortgageViewController!

    var animatableConstraints:Constraint? = nil

    
    var didSetupConstraints = false
    
    init() {
        viewModel = RootViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        render()
        style()
        
        view.setNeedsUpdateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            let value = UIInterfaceOrientation.portrait.rawValue
//            UIDevice.current.setValue(value, forKey: "orientation")
//        }
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController) {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
    }
    
    func canRotate() -> Void {}
    
//    func viewWillTransitionToSize(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        if UIDevice.current.orientation.isLandscape {
//            print("Landscape")
//        } else {
//            print("Portrait")
//        }
//    }
    
//    override var shouldAutorotate:Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.portrait
//    }
//    
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        return UIInterfaceOrientation.portrait
//    }
    
    func setupView() {
        contentView = ContentView()
        view.addSubview(contentView)
        
        mortgageView = UIView()
        contentView.addSubview(mortgageView)
        
        headerLbl = UILabel()
        mortgageView.addSubview(headerLbl)
        
        totalAmountLbl = UILabel()
        mortgageView.addSubview(totalAmountLbl)
        
        totalAmount = UITextField()
        mortgageView.addSubview(totalAmount)
        
        interestLbl = UILabel()
        mortgageView.addSubview(interestLbl)

        interest = UITextField()
        mortgageView.addSubview(interest)
        
        depositLbl = UILabel()
        mortgageView.addSubview(depositLbl)

        deposit = UITextField()
        mortgageView.addSubview(deposit)
        
        numberOfYearsLbl = UILabel()
        mortgageView.addSubview(numberOfYearsLbl)
        
        numberOfYears = UITextField()
        mortgageView.addSubview(numberOfYears)
        
        calculateBtn = UIButton(type: .custom)
        calculateBtn.addTarget(self, action: #selector(calculateMortgage), for: .touchUpInside)
        mortgageView.addSubview(calculateBtn)
        
    }
    
    func style() {
        view.backgroundColor = UIColor.white

        totalAmount.borderStyle = .roundedRect
        interest.borderStyle = .roundedRect
        deposit.borderStyle = .roundedRect
        numberOfYears.borderStyle = .roundedRect
        calculateBtn.backgroundColor = UIColor.gray
        
        headerLbl.font = UIFont.boldFont()
        totalAmountLbl.font = UIFont.normalFont()
        interestLbl.font = UIFont.normalFont()
        depositLbl.font = UIFont.normalFont()
        numberOfYearsLbl.font = UIFont.normalFont()

        calculateBtn.titleLabel!.font = UIFont.boldFont()
    }
    
    
    func render() {
        
        self.title = viewModel.title
        self.headerLbl.text = viewModel.headerText
        
        totalAmountLbl.text = viewModel.totalAmountText
        var placeholder = NSAttributedString(string: "250000", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        totalAmount.attributedPlaceholder = placeholder;
        
        interestLbl.text = viewModel.interestText
        placeholder = NSAttributedString(string: "5", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        interest.attributedPlaceholder = placeholder;
        
        depositLbl.text = viewModel.depositText
        placeholder = NSAttributedString(string: "50000", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        deposit.attributedPlaceholder = placeholder;
        
        numberOfYearsLbl.text = viewModel.numberOfYearsText
        placeholder = NSAttributedString(string: "25", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        numberOfYears.attributedPlaceholder = placeholder;
        
        calculateBtn.setTitle(viewModel.calculateText, for: .normal)
    }
    
    // MARK: Actions
    func calculateMortgage(sender: UIButton) {
        
        var totalValue:Double?  = Double(totalAmount.text!) ?? 250000
        var interestValue:Double? = Double(interest.text!) ?? 5
        var depositValue:Double? = Double(deposit.text!) ?? 50000
        var yearsValue:Double? = Double(numberOfYears.text!) ?? 25

        guard totalValue != nil  else {
            totalValue = 250000
            return
        }
        
        guard interestValue != nil  else {
            interestValue = 5
            return
        }
        
        guard depositValue != nil  else {
            depositValue = 10000
            return
        }
        
        guard yearsValue != nil  else {
            yearsValue = 25
            return
        }

        //graphVC = GraphViewController(mortgageAmount: totalValue!, deposit: depositValue!, interest: interestValue!, years: yearsValue!)
        mortgageVC = MortgageViewController(mortgageAmount: totalValue!, deposit: depositValue!, interest: interestValue!, years: yearsValue!)
         self.navigationController?.pushViewController(mortgageVC, animated: true)
    }
}

class ContentView:UIView {
    init () {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.backgroundColor = UIColor().themeBackgroundColor

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let whiteRect = rect.insetBy(dx: -10, dy: -10)
        context!.setFillColor(UIColor().themeBackgroundColor.cgColor)

        context!.fillEllipse(in: whiteRect)
        context?.setStrokeColor(UIColor().borderColor.cgColor)
        context?.setLineWidth(5.0)
        context!.addEllipse(in: whiteRect)
        context?.drawPath(using: .fillStroke)
    }
}


