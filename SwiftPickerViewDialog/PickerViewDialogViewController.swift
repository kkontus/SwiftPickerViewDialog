//
//  PickerViewDialogViewController.swift
//  SwiftPickerViewDialog
//
//  Created by Kristijan Kontus on 26/08/2016.
//  Copyright © 2016 kkontus. All rights reserved.
//

import UIKit

class PickerViewDialogViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private let pickerViewDialogViewWidth: CGFloat = 300.0
    private let pickerViewDialogViewHeight: CGFloat = 250.0
    private var pickerViewDialogView: UIView!
    private let titleView = UIView()
    private let titleLabel = UILabel(frame: CGRectMake(0, 0, 0, 0))
    private let pickerView = UIPickerView(frame: CGRectMake(0, 0, 0, 0))
    private let cancelButton = UIButton()
    private let okButton = UIButton()
    private let stackView = UIStackView(frame: CGRectMake(0, 0, 0, 0))
    private var selectedValue: String = ""
    //properties exposed to developer/user
    var titleDialog: String = ""
    var pickerData: [String] = []
    var defaultValue: String = ""
    var componentName: DialogPickerViewEnum?
    var delegateDialogPickerView: DialogPickerViewDelegate?
    
    deinit {
        print("\(self.dynamicType) was deallocated")
    }
    
    override func viewDidLoad() {
        print("\(self.dynamicType) did load")
        super.viewDidLoad()
        
        showPickerViewDialogView()
    }
    
    func okButtonAction(sender: UIButton!) {
        print("Button tapped ok")
        
        self.delegateDialogPickerView?.onPickerValueChange(self.componentName!, value: self.selectedValue)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func cancelButtonAction(sender: UIButton!) {
        print("Button tapped cancel")
        
        //self.delegateDialogPickerView?.onPickerValueChange(self.componentName!, value: self.selectedValue)
        self.delegateDialogPickerView?.onPickerValueChange(self.componentName!, value: "")
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func showPickerViewDialogView() {
        createDatePickerDialogView()
        createTitleView()
        createTitleLabel()
        createPickerView()
        createCancelButton()
        createOkButton()
        createStackView()
        self.view.layoutIfNeeded()
    }
    
    func createDatePickerDialogView() {
        pickerViewDialogView = UIView()
        pickerViewDialogView.layer.borderWidth = 1
        pickerViewDialogView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
        pickerViewDialogView.layer.cornerRadius = 8.0
        pickerViewDialogView.clipsToBounds = true
        pickerViewDialogView.backgroundColor = UIColor.whiteColor()
        
        pickerViewDialogView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pickerViewDialogView)
        
        pickerViewDialogView.widthAnchor.constraintEqualToConstant(pickerViewDialogViewWidth).active = true
        pickerViewDialogView.heightAnchor.constraintEqualToConstant(pickerViewDialogViewHeight).active = true
        pickerViewDialogView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        pickerViewDialogView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
    }
    
    func createTitleView() {
        titleView.backgroundColor = UIColor.whiteColor()
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        self.pickerViewDialogView.addSubview(titleView)
        
        titleView.widthAnchor.constraintEqualToConstant(pickerViewDialogViewWidth).active = true
        titleView.heightAnchor.constraintEqualToConstant(30.0).active = true
        titleView.centerXAnchor.constraintEqualToAnchor(self.pickerViewDialogView.centerXAnchor).active = true
        titleView.topAnchor.constraintEqualToAnchor(self.pickerViewDialogView.topAnchor).active = true
    }
    
    func createTitleLabel() {
        let title = titleDialog
        titleLabel.font = UIFont.boldSystemFontOfSize(14.0)
        titleLabel.text = title
        titleLabel.textColor = UIColor(red: 0.0, green: 122/255, blue: 1.0, alpha: 1)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleView.addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraintEqualToAnchor(titleView.centerXAnchor).active = true
        titleLabel.centerYAnchor.constraintEqualToAnchor(titleView.centerYAnchor).active = true
    }
    
    func createPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let index = pickerData.indexOf(self.defaultValue)
        if index != nil {
            pickerView.selectRow(index!, inComponent: 0, animated: false)
        } else {
            // in case when there is no default value provided we will set UIPickerView to first item pickerData
            pickerView.selectRow(0, inComponent: 0, animated: false)
            self.selectedValue = pickerData[pickerView.selectedRowInComponent(0)]
        }
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.pickerViewDialogView.addSubview(pickerView)
        
        pickerView.widthAnchor.constraintEqualToConstant(270.0).active = true
        pickerView.heightAnchor.constraintEqualToConstant(216.0).active = true
        pickerView.centerXAnchor.constraintEqualToAnchor(self.pickerViewDialogView.centerXAnchor).active = true
        pickerView.centerYAnchor.constraintEqualToAnchor(self.pickerViewDialogView.centerYAnchor).active = true
    }
    
    func createCancelButton() {
        cancelButton.backgroundColor   = UIColor.whiteColor()
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), forControlEvents: .TouchUpInside)
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.setTitleColor(UIColor(red: 0.0, green: 122/255, blue: 1.0, alpha: 1), forState: UIControlState.Normal)
        cancelButton.widthAnchor.constraintEqualToConstant(pickerViewDialogViewWidth / 2).active = true
        cancelButton.heightAnchor.constraintEqualToConstant(30.0).active = true
    }
    
    func createOkButton() {
        okButton.backgroundColor   = UIColor.whiteColor()
        okButton.setTitle("OK", forState: UIControlState.Normal)
        okButton.addTarget(self, action: #selector(okButtonAction), forControlEvents: .TouchUpInside)
        okButton.setTitleColor(UIColor(red: 0.0, green: 122/255, blue: 1.0, alpha: 1), forState: UIControlState.Normal)
        okButton.widthAnchor.constraintEqualToConstant(pickerViewDialogViewWidth / 2).active = true
        okButton.heightAnchor.constraintEqualToConstant(30.0).active = true
    }
    
    func createStackView() {
        stackView.backgroundColor = UIColor.whiteColor()
        stackView.axis  = UILayoutConstraintAxis.Horizontal
        stackView.distribution  = UIStackViewDistribution.EqualSpacing
        stackView.alignment = UIStackViewAlignment.Center
        stackView.spacing   = 0.0
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(okButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.pickerViewDialogView.addSubview(stackView)
        
        stackView.heightAnchor.constraintEqualToConstant(30).active = true
        stackView.leadingAnchor.constraintEqualToAnchor(self.pickerViewDialogView.leadingAnchor).active = true
        stackView.trailingAnchor.constraintEqualToAnchor(self.pickerViewDialogView.trailingAnchor).active = true
        stackView.bottomAnchor.constraintEqualToAnchor(self.pickerViewDialogView.bottomAnchor).active = true
    }
    
    // UIPickerView Delegates and DataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("You selected cell #\(pickerData[row])!")
        
        selectedValue = pickerData[row]
    }
    
}



