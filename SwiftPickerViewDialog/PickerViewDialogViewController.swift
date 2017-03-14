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
    private let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private let cancelButton = UIButton()
    private let okButton = UIButton()
    private let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private var selectedValue: String = ""
    //properties exposed to developer/user
    var titleDialog: String = ""
    var pickerData: [String] = []
    var defaultValue: String = ""
    var componentName: DialogPickerViewEnum?
    var delegateDialogPickerView: DialogPickerViewDelegate?
    
    deinit {
        print("\(type(of: self)) was deallocated")
    }
    
    override func viewDidLoad() {
        print("\(type(of: self)) did load")
        super.viewDidLoad()
        
        showPickerViewDialogView()
    }
    
    func okButtonAction(_ sender: UIButton!) {
        print("Button tapped ok")
        
        self.delegateDialogPickerView?.onPickerValueChange(self.componentName!, value: self.selectedValue)
        self.dismiss(animated: false, completion: nil)
    }
    
    func cancelButtonAction(_ sender: UIButton!) {
        print("Button tapped cancel")
        
        //self.delegateDialogPickerView?.onPickerValueChange(self.componentName!, value: self.selectedValue)
        self.delegateDialogPickerView?.onPickerValueChange(self.componentName!, value: "")
        self.dismiss(animated: false, completion: nil)
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
    
    private func createDatePickerDialogView() {
        pickerViewDialogView = UIView()
        pickerViewDialogView.layer.borderWidth = 1
        pickerViewDialogView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        pickerViewDialogView.layer.cornerRadius = 8.0
        pickerViewDialogView.clipsToBounds = true
        pickerViewDialogView.backgroundColor = UIColor.white
        
        pickerViewDialogView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pickerViewDialogView)
        
        pickerViewDialogView.widthAnchor.constraint(equalToConstant: pickerViewDialogViewWidth).isActive = true
        pickerViewDialogView.heightAnchor.constraint(equalToConstant: pickerViewDialogViewHeight).isActive = true
        pickerViewDialogView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickerViewDialogView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func createTitleView() {
        titleView.backgroundColor = UIColor.white
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        self.pickerViewDialogView.addSubview(titleView)
        
        titleView.widthAnchor.constraint(equalToConstant: pickerViewDialogViewWidth).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        titleView.centerXAnchor.constraint(equalTo: self.pickerViewDialogView.centerXAnchor).isActive = true
        titleView.topAnchor.constraint(equalTo: self.pickerViewDialogView.topAnchor).isActive = true
    }
    
    private func createTitleLabel() {
        let title = titleDialog
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        titleLabel.text = title
        titleLabel.textColor = UIColor(red: 0.0, green: 122/255, blue: 1.0, alpha: 1)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleView.addSubview(titleLabel)
        
        titleLabel.widthAnchor.constraint(equalToConstant: pickerViewDialogViewWidth-10).isActive = true // 10 is for padding, 5 on each side since we have centerX
        titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }
    
    private func createPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let index = pickerData.index(of: self.defaultValue)
        if index != nil {
            pickerView.selectRow(index!, inComponent: 0, animated: false)
        } else {
            // in case when there is no default value provided we will set UIPickerView to first item pickerData
            pickerView.selectRow(0, inComponent: 0, animated: false)
            self.selectedValue = pickerData[pickerView.selectedRow(inComponent: 0)]
        }
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.pickerViewDialogView.addSubview(pickerView)
        
        pickerView.widthAnchor.constraint(equalToConstant: 270.0).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 216.0).isActive = true
        pickerView.centerXAnchor.constraint(equalTo: self.pickerViewDialogView.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: self.pickerViewDialogView.centerYAnchor).isActive = true
    }
    
    private func createCancelButton() {
        cancelButton.backgroundColor   = UIColor.white
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        cancelButton.setTitle("Cancel", for: UIControlState())
        cancelButton.setTitleColor(UIColor(red: 0.0, green: 122/255, blue: 1.0, alpha: 1), for: UIControlState())
        cancelButton.widthAnchor.constraint(equalToConstant: pickerViewDialogViewWidth / 2).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    }
    
    private func createOkButton() {
        okButton.backgroundColor   = UIColor.white
        okButton.setTitle("OK", for: UIControlState())
        okButton.addTarget(self, action: #selector(okButtonAction), for: .touchUpInside)
        okButton.setTitleColor(UIColor(red: 0.0, green: 122/255, blue: 1.0, alpha: 1), for: UIControlState())
        okButton.widthAnchor.constraint(equalToConstant: pickerViewDialogViewWidth / 2).isActive = true
        okButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    }
    
    private func createStackView() {
        stackView.backgroundColor = UIColor.white
        stackView.axis  = UILayoutConstraintAxis.horizontal
        stackView.distribution  = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing   = 0.0
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(okButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.pickerViewDialogView.addSubview(stackView)
        
        stackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.pickerViewDialogView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.pickerViewDialogView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.pickerViewDialogView.bottomAnchor).isActive = true
    }
    
    // UIPickerView Delegates and DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("You selected cell #\(pickerData[row])!")
        
        selectedValue = pickerData[row]
    }
    
}



