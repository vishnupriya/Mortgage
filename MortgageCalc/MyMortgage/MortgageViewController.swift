//
//  MortgageViewController.swift
//  MyMortgage
//
//  Created by Priya on 25/01/2017.
//  Copyright © 2017 Dunlysis. All rights reserved.
//

import UIKit

class MortgageViewController: UIViewController {

    let mortgageAmount: Double!
    let deposit: Double!
    let interest: Double!
    let years: Double!
    
    var graphBtn: UIButton!
    var tableBtn: UIButton!
    var contentView: UIView!
    
    var didSetupConstraints = false

    private lazy var graphVC: GraphViewController = {
        var viewController = GraphViewController(mortgageAmount: self.mortgageAmount, deposit: self.deposit, interest: self.interest, years: self.years)
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var tableVC: TableViewController = {
        var viewController = TableViewController(mortgageAmount: self.mortgageAmount, deposit: self.deposit, interest: self.interest, years: self.years)
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        
        setupView()
        customize()
        view.setNeedsUpdateConstraints()
    }
    
    func setupView() {
        graphBtn = UIButton(type: .custom)
        graphBtn.setTitle("Graph", for: .normal)
        graphBtn.isSelected = false
        graphBtn.addTarget(self, action: #selector(selectedGraph), for: .touchUpInside)
        view.addSubview(graphBtn)
        
        tableBtn = UIButton(type: .custom)
        tableBtn.setTitle("Table", for: .normal)
        tableBtn.isSelected = true
        tableBtn.addTarget(self, action: #selector(selectedTable), for: .touchUpInside)
        view.addSubview(tableBtn)
        
        contentView = UIView()
        view.addSubview(contentView)
        
        updateView()
    }

    func customize () {
        view.backgroundColor = UIColor().themeBackgroundColor
        
        graphBtn.setTitleColor(UIColor.black, for: .normal)
        graphBtn.titleLabel?.font = UIFont.smallFont()
        graphBtn.layer.borderColor = UIColor().primaryTextColor.cgColor
        graphBtn.layer.borderWidth = 0.5
        graphBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        
        tableBtn.setTitleColor(UIColor.black, for: .normal)
        tableBtn.titleLabel?.font = UIFont.smallFont()
        tableBtn.layer.borderColor = UIColor().primaryTextColor.cgColor
        tableBtn.layer.borderWidth = 0.5
        tableBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        tableBtn.backgroundColor = UIColor().borderColor
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            graphBtn.snp.makeConstraints { make in
                make.top.equalTo(view.snp.top).offset(20)
                make.right.equalTo(view.snp.right).offset(-20)
                //make.height.width.equalTo(30)
            }
            
            tableBtn.snp.makeConstraints { make in
                make.top.equalTo(view.snp.top).offset(20)
                make.right.equalTo(graphBtn.snp.left).offset(-2)
                //make.height.width.equalTo(30)
            }
            
            contentView.snp.makeConstraints { make in
                make.top.equalTo(view.snp.top).offset(80)
                make.left.equalTo(view.snp.left)
                make.right.equalTo(view.snp.right)
                make.bottom.equalTo(view.snp.bottom)
            }

            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func selectedTable() {
        tableBtn.isSelected = true
        tableBtn.backgroundColor = UIColor().borderColor
        graphBtn.backgroundColor = UIColor().primaryBackgroundColor
        graphBtn.isSelected = false
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            let value = UIInterfaceOrientation.portrait.rawValue
//            UIDevice.current.setValue(value, forKey: "orientation")
//        }
        updateView()
    }

    func selectedGraph() {
        tableBtn.isSelected = false
        graphBtn.isSelected = true
        graphBtn.backgroundColor = UIColor().borderColor
        tableBtn.backgroundColor = UIColor().primaryBackgroundColor
        
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            let value = UIInterfaceOrientation.landscapeLeft.rawValue
//            UIDevice.current.setValue(value, forKey: "orientation")
//        }
        updateView()
    }
    
    private func updateView() {
        if tableBtn.isSelected == true {
            remove(asChildViewController: graphVC)
            add(asChildViewController: tableVC)
        } else {
            remove(asChildViewController: tableVC)
            add(asChildViewController: graphVC)
        }
    }
    
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        contentView.addSubview(viewController.view)
        
        // Configure Child View
        
        viewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
}
