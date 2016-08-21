//
//  ViewController.swift
//  College
//
//  Created by RAFAEL LI CHEN on 7/29/16.
//  Copyright © 2016 RAFAEL. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class EditInfoViewController: UIViewController, UITextFieldDelegate {
    
    let FirstNameKey = "FirstNameKey"
    let LastNameKey = "LastNameKey"
    let IDNumberKey = "IDNumberKey"
    let DateofBirthKey = "DateofBirthKey"
    let AreaofStudyKey = "AreaofStudyKey"
    let TotalCreditstoGraduateKey = "TotalCreditstoGraduateKey"
    let GenderKey = "GenderKey"
    let MajorSelectedRowKey = "MajorSelectedRowKey"
    let DOB_StringKey = "DOB_StringKey"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        FirstNameTextField.delegate = self
        LastNameTextField.delegate = self
        IDNumberTextField.delegate = self
        TotalCreditsTextField.delegate = self
        
        TotalCreditsTextField.keyboardType = UIKeyboardType.NumberPad
        
        self.hideKeyboardWhenTappedAround()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditInfoViewController.keyboardWillShowOrHide(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditInfoViewController.keyboardWillShowOrHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        FirstNameTextField.text = String(PlistManager.sharedInstance.getValueForKey(FirstNameKey)!)
        LastNameTextField.text = String(PlistManager.sharedInstance.getValueForKey(LastNameKey)!)
        if(String(PlistManager.sharedInstance.getValueForKey(TotalCreditstoGraduateKey)!) == "0") {TotalCreditsTextField.placeholder = "Not Set"}
        else {TotalCreditsTextField.text = String(PlistManager.sharedInstance.getValueForKey(TotalCreditstoGraduateKey)!)}
        IDNumberTextField.text = String(PlistManager.sharedInstance.getValueForKey(IDNumberKey)!)
        SelectedGenderShow.selectedSegmentIndex = Int(PlistManager.sharedInstance.getValueForKey(GenderKey)! as! NSNumber)
        
        let dateformatter_editinfo = NSDateFormatter()
        dateformatter_editinfo.dateFormat = "MMM-dd-yyyy"
        if(dateformatter_editinfo.stringFromDate((PlistManager.sharedInstance.getValueForKey("DateofBirthKey"))! as! NSDate) != "Aug-04-2100") {
            DateofBirthPicker.setDate((PlistManager.sharedInstance.getValueForKey(DateofBirthKey))! as! NSDate,animated: true)
        } else {
            DateofBirthPicker.setDate(NSDate(), animated: true)
        }
        // DateofBirthPicker.setDate((PlistManager.sharedInstance.getValueForKey(DateofBirthKey))! as! NSDate,animated: true)
        AreaofStudyPicker.selectRow(Int(PlistManager.sharedInstance.getValueForKey(MajorSelectedRowKey)! as! NSNumber), inComponent: 0, animated: true)
        majorSelectedRow = Int(PlistManager.sharedInstance.getValueForKey(MajorSelectedRowKey)! as! NSNumber)
        tempData_Gender = Int(PlistManager.sharedInstance.getValueForKey(GenderKey)! as! NSNumber)
        tempData_DOB = PlistManager.sharedInstance.getValueForKey(DateofBirthKey)! as! NSDate
    }
    
    @IBOutlet weak var AreaofStudyPicker: UIPickerView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var areaOfStudyPicker: UIPickerView!
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var IDNumberTextField: UITextField!
    @IBOutlet weak var TotalCreditsTextField: UITextField!
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var EditInfoScrollView: UIScrollView!
    
    func keyboardWillShowOrHide(notification: NSNotification) {
        
        // Pull a bunch of info out of the notification
        if let scrollView = EditInfoScrollView, userInfo = notification.userInfo, endValue = userInfo[UIKeyboardFrameEndUserInfoKey], durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] {
            
            // Transform the keyboard's frame into our view's coordinate system
            let endRect = view.convertRect(endValue.CGRectValue, fromView: view.window)
            
            // Find out how much the keyboard overlaps the scroll view
            // We can do this because our scroll view's frame is already in our view's coordinate system
            let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
            
            // Set the scroll view's content inset to avoid the keyboard
            // Don't forget the scroll indicator too!
            scrollView.contentInset.bottom = keyboardOverlap
            scrollView.scrollIndicatorInsets.bottom = keyboardOverlap
            
            let duration = durationValue.doubleValue
            UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: {self.view.layoutIfNeeded()}, completion: nil)
        }
    }
    
    var EditInfoMajors = ["", "Art", "Biomedical Engineering", "Computer Engineering", "Computer Science", "Music", "Psychology", "Other"]
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EditInfoMajors.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return EditInfoMajors[row]
        
    }
    var majorSelectedRow = 0
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        majorSelectedRow = row
    }

    var tempData_Gender = 0
    @IBAction func SelectedGender(sender: UISegmentedControl) {
        // not set
        if sender.selectedSegmentIndex == 0 {tempData_Gender = 0}
        // male
        if sender.selectedSegmentIndex == 1 {tempData_Gender = 1}
        // female
        if sender.selectedSegmentIndex == 2 {tempData_Gender = 2}
        // other
        if sender.selectedSegmentIndex == 3 {tempData_Gender = 3}
        
    }
    @IBOutlet weak var SelectedGenderShow: UISegmentedControl!

    @IBAction func EdiInfo_Cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var DateofBirthPicker: UIDatePicker!
    var tempData_DOB: NSDate = NSDate()
    @IBAction func DateofBirthSelected(sender: UIDatePicker) {
        // tempData_DOB = NSCalendar.currentCalendar().dateByAddingUnit([.Day], value: -1, toDate: DateofBirthPicker.date,options: [])!
        tempData_DOB = DateofBirthPicker.date
    }
    
    @NSManaged var areaOfStudy_data: String
    @IBAction func EditInfo_Save() {
        PlistManager.sharedInstance.saveValue(FirstNameTextField.text!, forKey: FirstNameKey)
        PlistManager.sharedInstance.saveValue(LastNameTextField.text!, forKey: LastNameKey)
        PlistManager.sharedInstance.saveValue(IDNumberTextField.text!, forKey: IDNumberKey)
        PlistManager.sharedInstance.saveValue(TotalCreditsTextField.text!, forKey: TotalCreditstoGraduateKey)
        PlistManager.sharedInstance.saveValue(tempData_Gender, forKey: GenderKey)
        PlistManager.sharedInstance.saveValue(tempData_DOB, forKey: DateofBirthKey)
        PlistManager.sharedInstance.saveValue(majorSelectedRow, forKey: MajorSelectedRowKey)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}