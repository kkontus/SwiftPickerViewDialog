//
//  ViewController.swift
//  SwiftPickerViewDialog
//
//  Created by Kristijan Kontus on 26/08/2016.
//  Copyright © 2016 kkontus. All rights reserved.
//

import UIKit

enum DialogPickerViewEnum {
    case period
    case countries
    case sites
    case zones
}

protocol DialogPickerViewDelegate {
    func onPickerValueChange(_ component: DialogPickerViewEnum, value: String)
}

class ViewController: UIViewController, DialogPickerViewDelegate {
    var pickerViewDialogViewController: PickerViewDialogViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onButtonClick(_ sender: UIButton) {
        let pickerData = ["Croatia","Bulgaria","Ireland","Ukraine","Romania","Spain","Hungary","Poland"]
        pickerViewDialogViewController = PickerViewDialogViewController()
        pickerViewDialogViewController.titleDialog = "Countries"
        pickerViewDialogViewController.pickerData = pickerData
        pickerViewDialogViewController.defaultValue = pickerData[0]
        pickerViewDialogViewController.componentName = DialogPickerViewEnum.countries
        pickerViewDialogViewController.delegateDialogPickerView = self
        pickerViewDialogViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(pickerViewDialogViewController, animated: false, completion: nil)
    }
    
    func onPickerValueChange(_ component: DialogPickerViewEnum, value: String) {
        print("\(type(of: self)) onPickerValueChange")
        print(component)
        print(value)
    }
    
}

