//
//  DataPicker.swift
//  SwiggyTest
//
//  Created by Ganesh Patro on 8/3/18.
//  Copyright © 2018 Ganesh Patro. All rights reserved.
//


import UIKit


class DataPicker<T>: NSObject, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    typealias SelctedDataCallback = (_ selectedData: T) -> Void
    typealias RowTitleCallback = (_ selectedData: T) -> String
    
    fileprivate var pickerView: UIPickerView?
    fileprivate var arrData: [T]?
    fileprivate var selectedDataCallback: SelctedDataCallback?
    fileprivate var rowTitleCallback: RowTitleCallback?
    fileprivate var textField: UITextField?
    fileprivate var toolbar: UIToolbar?
    
    init(withTitle title:String,
                  withArray data: [T],
                  withSelectedDataCallback selectedCallback: @escaping SelctedDataCallback,
                  withRowTitleCallback rowTitleCallback: @escaping RowTitleCallback,
                  withTextField textField: UITextField) {
        super.init()
        self.arrData = data
        self.selectedDataCallback = selectedCallback
        self.rowTitleCallback = rowTitleCallback
        
        pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.dataSource = self
        self.textField = textField
        self.textField?.inputView = pickerView
        self.textField?.delegate = self
        setUpToolBar(textField, withTitle: title)
    }
    
    fileprivate func setUpToolBar(_ textField: UITextField,withTitle title: String) {
        toolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        let doneBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(onClickOfDone))
        let cancelBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(onClickOfCancel))
        
        let flexibleSpace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let text = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: nil)
        text.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17.0),
            NSAttributedStringKey.foregroundColor : UIColor.black], for: UIControlState.normal)
        
        toolbar?.setItems([cancelBarButtonItem,flexibleSpace,text, flexibleSpace, doneBarButtonItem], animated: true)
        
        textField.inputAccessoryView = toolbar
    }

    //MARKL:- UIPickerView delegate & datasource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (arrData?.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rowTitleCallback!(arrData![row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }

    //MARK:- Actions
    @objc fileprivate func onClickOfDone() {
        self.textField?.resignFirstResponder()
        self.selectedDataCallback!(arrData![(pickerView?.selectedRow(inComponent: 0))!])
    }
    
    @objc fileprivate func onClickOfCancel() {
        self.textField?.resignFirstResponder()
    }
    
    //MARK:- UITextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
    }
}
