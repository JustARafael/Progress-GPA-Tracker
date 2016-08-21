//
//  InfoViewController.swift
//  Progress
//
//  Created by RAFAEL LI CHEN on 7/31/16.
//  Copyright © 2016 RAFAEL. All rights reserved.
//

import UIKit
import Charts

class InfoViewController: UIViewController {
    
    @IBOutlet weak var IDNumber_TextField_Disabled: UITextField!
    @IBOutlet weak var DateofBirth_TextField_Disabled: UITextField!
    @IBOutlet weak var AreaofStudy_TextField_Disabled: UITextField!
    @IBOutlet weak var CumulativeGPA_TextField_Disabled: UITextField!
    @IBOutlet weak var LastNameLabel: UILabel!
    @IBOutlet weak var FirstNameLabel: UILabel!
    
    func DataToArray_display(inputData: String) -> [String] {
        var output = [String]()
        var temp = ""
        for char in inputData.characters {
            if(char == ",") {
                output.insert(temp, atIndex: 0)
                temp = ""
            } else {
                temp += String(char)
            }
        }
        return output
    }

    var GradeListfromDiploma = [String]()
    var CreditsListfromDiploma = [String]()
    var YearListfromDiploma = [String]()
    var currentCredits = 0
    
    func getCurrentCredits(allCredits: [String]) -> Float {
        var temp_credits: Float = 0.0
        for element in allCredits {
            temp_credits += Float(element)!
        }
        return temp_credits
    }
    
    @IBOutlet weak var CreditsBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        PersonImageView.image = UIImage(named: "male.png")!
        
        do {
            var readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/YearListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            YearListfromDiploma = DataToArray_display(readData)
            readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/CreditsListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            CreditsListfromDiploma = DataToArray_display(readData)
            readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/GradeListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            GradeListfromDiploma = DataToArray_display(readData)
            if(Int(String(PlistManager.sharedInstance.getValueForKey("TotalCreditstoGraduateKey")!))! != 0) {CreditsBar.setProgress(getCurrentCredits(CreditsListfromDiploma) / Float((Int(String(PlistManager.sharedInstance.getValueForKey("TotalCreditstoGraduateKey")!))!)), animated: true)}
        } catch {
            print("Error Read from InfoView")
            CreditsBar.setProgress(0, animated: true)
        }
        
        LetterGradeBarChartView.noDataText = "No Data Avaliable"
        GPAOverTimeLineChartView.noDataText = "No Data Avaliable"
        
        executeIfFileExist()
        
        major_temp_list = EditInfoViewController().EditInfoMajors
        
        IDNumber_TextField_Disabled.text = String(PlistManager.sharedInstance.getValueForKey("IDNumberKey")!)
        AreaofStudy_TextField_Disabled.text = major_temp_list[Int(PlistManager.sharedInstance.getValueForKey("MajorSelectedRowKey")! as! NSNumber)]
        
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "MMM - dd - yyyy"
        DateofBirth_TextField_Disabled.text = dateformatter.stringFromDate((PlistManager.sharedInstance.getValueForKey("DateofBirthKey"))! as! NSDate)
        
        if(String(DateofBirth_TextField_Disabled.text!).rangeOfString("- 2100")) != nil{
            // DateofBirth_TextField_Disabled.placeholder = "Not Set"
            DateofBirth_TextField_Disabled.text = ""
        }
        
        // String((PlistManager.sharedInstance.getValueForKey("DateofBirthKey"))! as! NSDate)
        if(String((PlistManager.sharedInstance.getValueForKey("FirstNameKey"))!) == "") {FirstNameLabel.text = "First Name"}
        else {FirstNameLabel.text = String((PlistManager.sharedInstance.getValueForKey("FirstNameKey"))!)}
        if(String((PlistManager.sharedInstance.getValueForKey("LastNameKey"))!) == "") {LastNameLabel.text = "Last Name"}
        else {LastNameLabel.text = String((PlistManager.sharedInstance.getValueForKey("LastNameKey"))!)}
    }
    
    var major_temp_list = [String]()
    
    func executeIfFileExist() {
        // Check if data files exist
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.URLByAppendingPathComponent("ClassListDiplomaData.txt").path!
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(filePath) {
            LetterGradeFrequency = countGrade(GradeListfromDiploma)
            YearListX = yearRange(YearListfromDiploma)
            GPAeachYear = GPAcalculate(GradeListfromDiploma, inputCredits: CreditsListfromDiploma, inputYear: YearListfromDiploma)
            setChart_Bar(LetterGradeList, values: LetterGradeFrequency)
            setChart_Line(YearListX, values: GPAeachYear)
        } else {
            LetterGradeBarChartView.clear()
            GPAOverTimeLineChartView.clear()
            LetterGradeBarChartView.noDataText = "No Data Avaliable"
            GPAOverTimeLineChartView.noDataText = "No Data Avaliable"
        }
    }
    
    @IBAction func refreshData() {
        do {
            var readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/YearListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            YearListfromDiploma = DataToArray_display(readData)
            readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/CreditsListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            CreditsListfromDiploma = DataToArray_display(readData)
            readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/GradeListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            GradeListfromDiploma = DataToArray_display(readData)
            if(Int(String(PlistManager.sharedInstance.getValueForKey("TotalCreditstoGraduateKey")!))! != 0) {CreditsBar.setProgress(getCurrentCredits(CreditsListfromDiploma) / Float((Int(String(PlistManager.sharedInstance.getValueForKey("TotalCreditstoGraduateKey")!))!)), animated: true)}
        } catch {
            CreditsBar.setProgress(0, animated: true)
            print("Error Refresh from InfoView")
        }
        
        IDNumber_TextField_Disabled.text = String(PlistManager.sharedInstance.getValueForKey("IDNumberKey")!)
        AreaofStudy_TextField_Disabled.text = major_temp_list[Int(PlistManager.sharedInstance.getValueForKey("MajorSelectedRowKey")! as! NSNumber)]
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "MMM - dd - yyyy"
        DateofBirth_TextField_Disabled.text = dateformatter.stringFromDate((PlistManager.sharedInstance.getValueForKey("DateofBirthKey"))! as! NSDate)
        
        if(String(DateofBirth_TextField_Disabled.text!).rangeOfString("- 2100")) != nil{
            // DateofBirth_TextField_Disabled.placeholder = "Not Set"
            DateofBirth_TextField_Disabled.text = ""
        }
        if(String((PlistManager.sharedInstance.getValueForKey("FirstNameKey"))!) == "") {FirstNameLabel.text = "First Name"}
        else {FirstNameLabel.text = String((PlistManager.sharedInstance.getValueForKey("FirstNameKey"))!)}
        if(String((PlistManager.sharedInstance.getValueForKey("LastNameKey"))!) == "") {LastNameLabel.text = "Last Name"}
        else {LastNameLabel.text = String((PlistManager.sharedInstance.getValueForKey("LastNameKey"))!)}
        executeIfFileExist()
    }
    
    var GPAeachYear = [Double]()
    func GPAcalculate(inputGrade: Array<String>, inputCredits: Array<String>, inputYear: Array<String>) -> Array<Double> {
        var temp_credits = [Double](count: YearListX.count, repeatedValue: 0.0)
        var temp_grade = [Double](count: YearListX.count, repeatedValue: 0.0)
        var temp = [Double](count: YearListX.count, repeatedValue: 0.0)
        
        for i in 0..<YearListX.count {
            for j in 0..<inputYear.count {
                if(inputYear[j] == YearListX[i]) {
                    temp_credits[i] += Double(inputCredits[j])!
                    temp_grade[i] += (Double(inputCredits[j])! * letterToPoint(inputGrade[j]))
                }
            }
        }
        for i in 0..<temp.count {
            if(temp_grade[i] == 0 && temp_credits[i] == 0) {temp[i] = 0.0}
            else {temp[i] = round(temp_grade[i]/temp_credits[i]*1000.0)/1000.0}
        }
        return temp
    }
    func OverallGPA(inputGrade: Array<String>, inputCredits: Array<String>) -> Double {
        var temp_credits = [Double](count: inputGrade.count, repeatedValue: 0.0)
        var temp_grade = [Double](count: inputGrade.count, repeatedValue: 0.0)
        for i in 0..<inputGrade.count {
            temp_credits[i] += Double(inputCredits[i])!
            temp_grade[i] += (Double(inputCredits[i])! * letterToPoint(inputGrade[i]))
        }
        var TotalCredits = 0.0
        for i in 0..<temp_credits.count {TotalCredits += temp_credits[i]}
        var TotalGrade = 0.0
        for i in 0..<temp_grade.count {TotalGrade += temp_grade[i]}
        return TotalGrade/TotalCredits
    }

    func letterToPoint(input: String) -> Double {
        var temp = 0.0
        if(input == "A+" || input == "A") {temp = 4.0}
        if(input == "A-") {temp = 3.7}
        if(input == "B+") {temp = 3.3}
        if(input == "B") {temp = 3.0}
        if(input == "B-") {temp = 2.7}
        if(input == "C+") {temp = 2.3}
        if(input == "C") {temp = 2.0}
        if(input == "C-") {temp = 1.7}
        if(input == "D") {temp = 1}
        if(input == "F") {temp = 0.0}
        return temp
    }
    
    func countGrade(inputArray: Array<String>) -> Array<Double> {
        var temp = [Double](count: 11,repeatedValue: 0.0)
        for i in 0..<inputArray.count {
            if(inputArray[i] == "A+") {temp[0] += 1}
            if(inputArray[i] == "A") {temp[1] += 1}
            if(inputArray[i] == "A-") {temp[2] += 1}
            if(inputArray[i] == "B+") {temp[3] += 1}
            if(inputArray[i] == "B") {temp[4] += 1}
            if(inputArray[i] == "B-") {temp[5] += 1}
            if(inputArray[i] == "C+") {temp[6] += 1}
            if(inputArray[i] == "C") {temp[7] += 1}
            if(inputArray[i] == "C-") {temp[8] += 1}
            if(inputArray[i] == "C-") {temp[9] += 1}
            if(inputArray[i] == "F") {temp[10] += 1}
        }
        return temp
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var PersonImageView: UIImageView!
    
    @IBOutlet weak var LetterGradeBarChartView: BarChartView!
    
    @IBOutlet weak var GPAOverTimeLineChartView: LineChartView!
    
    var YearListX = [String]()
    func yearRange(inputArray: Array<String>) -> Array<String> {
        var minimum: Int = Int(inputArray[0])!
        var maximum: Int = Int(inputArray[0])!
        for i in 1..<inputArray.count {
            if(Int(inputArray[i])<minimum) {minimum = Int(inputArray[i])!}
            if(Int(inputArray[i])>maximum) {maximum = Int(inputArray[i])!}
        }
        var temp = [String]()
        while(minimum<maximum+1) {
            temp.append(String(minimum))
            minimum+=1
        }
        return temp
    }
    
    var LetterGradeFrequency = [Double]()
    var LetterGradeList = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D", "F"]
    
    func setChart_Bar(dataPoints: [String], values: [Double]) {
        LetterGradeBarChartView.noDataText = "No Data Avaliable"
        LetterGradeBarChartView.descriptionText = ""
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Letter Grade")
        chartDataSet.colors = [UIColor(red: 0/255, green: 110/255, blue: 253/255, alpha: 1)]
        let chartData = BarChartData(xVals: LetterGradeList, dataSet: chartDataSet)
        LetterGradeBarChartView.data = chartData
        LetterGradeBarChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    func setChart_Line(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        if(values.count != 0) {
            let temp_double = OverallGPA(GradeListfromDiploma, inputCredits: CreditsListfromDiploma)
            let temp_round = round(temp_double*1000.0)/1000.0
            let ll = ChartLimitLine(limit: temp_double, label: String(temp_round))
            GPAOverTimeLineChartView.rightAxis.removeAllLimitLines()
            GPAOverTimeLineChartView.rightAxis.addLimitLine(ll)
        }
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "GPA")
        lineChartDataSet.colors = [UIColor(red: 0/255, green: 110/255, blue: 253/255, alpha: 1)]
        lineChartDataSet.circleColors = [UIColor(red: 0/255, green: 110/255, blue: 253/255, alpha: 1)]
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        
        GPAOverTimeLineChartView.data = lineChartData
        GPAOverTimeLineChartView.noDataText = "No Data Avaliable"
        GPAOverTimeLineChartView.descriptionText = ""
        GPAOverTimeLineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
}