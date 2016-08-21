//
//  EditDiplomaViewController.swift
//  Progress
//
//  Created by RAFAEL LI CHEN on 7/30/16.
//  Copyright © 2016 RAFAEL. All rights reserved.
//

import UIKit
import CoreData

class EditDiplomaViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ClassNameTextField.delegate = self
        CodeTextField.delegate = self
        YearTextField.delegate = self
        CreditsTextField.delegate = self
        
        YearTextField.keyboardType = UIKeyboardType.NumberPad
        CreditsTextField.keyboardType = UIKeyboardType.NumberPad
        
        self.hideKeyboardWhenTappedAround()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditDiplomaViewController.keyboardWillShowOrHide(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditDiplomaViewController.keyboardWillShowOrHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        do {
            var readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/ClassListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            ClassNameList_Edit = DataToArray(readData)
            readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/CodeListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            CodeList_Edit = DataToArray(readData)
            readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/YearListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            YearList_Edit = DataToArray(readData)
            readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/CreditsListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            CreditsList_Edit = DataToArray(readData)
            readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/GradeListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            GradeList_Edit = DataToArray(readData)
        } catch {
            print("Error Read from EditDiplomaView")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DataToArray(inputData: String) -> [String] {
        var output = [String]()
        var temp = ""
        for char in inputData.characters {
            if(char == ",") {
                output.append(temp)
                temp = ""
            } else {
                temp += String(char)
            }
        }
        return output
    }
    
    func numToGrade(inputNum: Int) -> String {
        var returnLetter = ""
        if(inputNum == 0) {returnLetter = "A+"}
        if(inputNum == 1) {returnLetter = "A"}
        if(inputNum == 2) {returnLetter = "A-"}
        if(inputNum == 3) {returnLetter = "B+"}
        if(inputNum == 4) {returnLetter = "B"}
        if(inputNum == 5) {returnLetter = "B-"}
        if(inputNum == 6) {returnLetter = "C+"}
        if(inputNum == 7) {returnLetter = "C"}
        if(inputNum == 8) {returnLetter = "C-"}
        if(inputNum == 9) {returnLetter = "D"}
        if(inputNum == 10) {returnLetter = "F"}
        return returnLetter
    }
    
    // These strings will be the data for the table view cells
    var ClassNameList_Edit = [String]()
    var CodeList_Edit = [String]()
    var YearList_Edit = [String]()
    var CreditsList_Edit = [String]()
    var GradeList_Edit = [String]()

    @IBAction func AddClass() {
        var YearBool = true
        var CreditsBool = true
        
        var alertController = UIAlertController(title: "Progress", message:"Invalid Year", preferredStyle: UIAlertControllerStyle.Alert)
        if(YearTextField.text! == "" || Int(YearTextField.text!)>9999 || Int(YearTextField.text!)<1000) {
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            YearBool = false
        }
        if(CreditsTextField.text! == "" && YearBool) {
            alertController = UIAlertController(title: "Progress", message:"Invalid Credits", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            CreditsBool = false
        }
        
        if(YearBool == true && CreditsBool == true) {
            ClassNameList_Edit.append(ClassNameTextField.text!)
            CodeList_Edit.append(CodeTextField.text!)
            YearList_Edit.append(YearTextField.text!)
            CreditsList_Edit.append(CreditsTextField.text!)
            GradeList_Edit.append(numToGrade(GradeSelectedRow))
            
            let filePath_Class = NSHomeDirectory() + "/Documents/ClassListDiplomaData.txt"
            let filePath_Code = NSHomeDirectory() + "/Documents/CodeListDiplomaData.txt"
            let filePath_Year = NSHomeDirectory() + "/Documents/YearListDiplomaData.txt"
            let filePath_Credits = NSHomeDirectory() + "/Documents/CreditsListDiplomaData.txt"
            let filePath_Grade = NSHomeDirectory() + "/Documents/GradeListDiplomaData.txt"
            
            var writeClassName = ""
            for i in 0..<ClassNameList_Edit.count {
                writeClassName += ClassNameList_Edit[i] + ","
            }
            var writeCode = ""
            for i in 0..<CodeList_Edit.count {
                writeCode += CodeList_Edit[i] + ","
            }
            var writeYear = ""
            for i in 0..<YearList_Edit.count {
                writeYear += YearList_Edit[i] + ","
            }
            var writeCredits = ""
            for i in 0..<CreditsList_Edit.count {
                writeCredits += CreditsList_Edit[i] + ","
            }
            var writeGrades = ""
            for i in 0..<GradeList_Edit.count {
                writeGrades += GradeList_Edit[i] + ","
            }
            do {
                _ = try writeClassName.writeToFile(filePath_Class, atomically: true, encoding: NSUTF8StringEncoding)
                _ = try writeCode.writeToFile(filePath_Code, atomically: true, encoding: NSUTF8StringEncoding)
                _ = try writeYear.writeToFile(filePath_Year, atomically: true, encoding: NSUTF8StringEncoding)
                _ = try writeCredits.writeToFile(filePath_Credits, atomically: true, encoding: NSUTF8StringEncoding)
                _ = try writeGrades.writeToFile(filePath_Grade, atomically: true, encoding: NSUTF8StringEncoding)
            } catch {
                print("Error Save from EditDiplomaView")
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        /*
        var readString: String
        let filePath_read = NSHomeDirectory() + "/Documents/ClassListDiplomaData.txt"
        
        do {
            readString = try NSString(contentsOfFile: filePath_read, encoding: NSUTF8StringEncoding) as String
            print(readString)
            print(DataToArray(readString))
            ClassNameList_Edit = DataToArray(readString)
        } catch let error as NSError {
            print(error.description)
        }
        */
    }
    
    @IBAction func EditDiploma_Cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var ClassNameTextField: UITextField!
    @IBOutlet weak var CodeTextField: UITextField!
    @IBOutlet weak var YearTextField: UITextField!
    @IBOutlet weak var CreditsTextField: UITextField!
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var EditDiplomaScrollView: UIScrollView!
    
    func keyboardWillShowOrHide(notification: NSNotification) {
        
        // Pull a bunch of info out of the notification
        if let scrollView = EditDiplomaScrollView, userInfo = notification.userInfo, endValue = userInfo[UIKeyboardFrameEndUserInfoKey], durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] {
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

    var EditDiplomaLetter = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D", "F"]
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return EditDiplomaLetter.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return EditDiplomaLetter[row]
    }
    var GradeSelectedRow = 0
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       GradeSelectedRow = row
    }
}
