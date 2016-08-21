//
//  DiplomaViewController.swift
//  Progress
//
//  Created by RAFAEL LI CHEN on 7/30/16.
//  Copyright © 2016 RAFAEL. All rights reserved.
//

import UIKit

class DiplomaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ClassListTableView.delegate = self
        ClassListTableView.dataSource = self
        ClassListTableView.allowsSelection = false
        
        do {
            var readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/ClassListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            ClassNameList = DataToArray_show(readData)
            readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/CodeListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            CodeList = DataToArray_show(readData)
            readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/YearListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            YearList = DataToArray_show(readData)
            readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/CreditsListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            CreditsList = DataToArray_show(readData)
            readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/GradeListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            GradeList = DataToArray_show(readData)
        } catch {
            let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.ClassListTableView.bounds.size.width, self.ClassListTableView.bounds.size.height))
            noDataLabel.text = "No Data Available"
            noDataLabel.textColor = UIColor(red: 228.0/255.0, green: 175.0/255.0, blue: 50.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.Center
            self.ClassListTableView.backgroundView = noDataLabel
            ClassListTableView.separatorStyle = UITableViewCellSeparatorStyle.None
            print("Error Read from DiplomaView")
        }
    }
    
    func DataToArray_show(inputData: String) -> [String] {
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
    
    @IBAction func refreshTableView(sender: AnyObject) {
        do {
            var readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/ClassListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            ClassNameList = DataToArray_show(readData)
            readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/CodeListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            CodeList = DataToArray_show(readData)
            readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/YearListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            YearList = DataToArray_show(readData)
            readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/CreditsListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            CreditsList = DataToArray_show(readData)
            readData = try NSString(contentsOfFile: NSHomeDirectory() + "/Documents/GradeListDiplomaData.txt", encoding: NSUTF8StringEncoding) as String
            GradeList = DataToArray_show(readData)
            self.ClassListTableView.backgroundView = nil
            ClassListTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        } catch {
            let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.ClassListTableView.bounds.size.width, self.ClassListTableView.bounds.size.height))
            noDataLabel.text = "No Data Available"
            noDataLabel.textColor = UIColor(red: 228.0/255.0, green: 175.0/255.0, blue: 50.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.Center
            self.ClassListTableView.backgroundView = noDataLabel
            ClassListTableView.separatorStyle = UITableViewCellSeparatorStyle.None
            print("Error Refresh from DiplomaView")
        }
        ClassListTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // These strings will be the data for the table view cells
    var ClassNameList = [String]()
    var CodeList = [String]()
    var YearList = [String]()
    var CreditsList = [String]()
    var GradeList = [String]()
    
    // These are the colors of the square views in our table view cells.
    // In a real project you might use UIImages.
    let colors = [UIColor.blueColor(), UIColor.yellowColor(), UIColor.magentaColor(), UIColor.redColor(), UIColor.brownColor()]
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var ClassListTableView: UITableView!
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ClassNameList.count
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ClassListTableViewCell = self.ClassListTableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! ClassListTableViewCell
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.URLByAppendingPathComponent("ClassListDiplomaData.txt").path!
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(filePath) {
            cell.ClassStatusImage.image = UIImage(named: "passed.png")
            cell.ClassNameLabel.text = self.ClassNameList[indexPath.row]
            cell.CodeLabel.text = self.CodeList[indexPath.row]
            cell.YearLabel.text = self.YearList[indexPath.row]
            cell.GradeLabel.text = self.GradeList[indexPath.row]
            cell.CreditsLabel.text = "(" + self.CreditsList[indexPath.row] + ")"
            self.ClassListTableView.rowHeight = 64
        }
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            ClassNameList.removeAtIndex(indexPath.row)
            CodeList.removeAtIndex(indexPath.row)
            YearList.removeAtIndex(indexPath.row)
            CreditsList.removeAtIndex(indexPath.row)
            GradeList.removeAtIndex(indexPath.row)
            
            ClassNameList = ClassNameList.reverse()
            CodeList = CodeList.reverse()
            YearList = YearList.reverse()
            CreditsList = CreditsList.reverse()
            GradeList = GradeList.reverse()
            
            let filePath_Class = NSHomeDirectory() + "/Documents/ClassListDiplomaData.txt"
            let filePath_Code = NSHomeDirectory() + "/Documents/CodeListDiplomaData.txt"
            let filePath_Year = NSHomeDirectory() + "/Documents/YearListDiplomaData.txt"
            let filePath_Credits = NSHomeDirectory() + "/Documents/CreditsListDiplomaData.txt"
            let filePath_Grade = NSHomeDirectory() + "/Documents/GradeListDiplomaData.txt"
            
            if(CodeList.count == 0) {
                // Create a FileManager instance
                let fileManager = NSFileManager.defaultManager()
                
                // Delete file
                do {
                    try fileManager.removeItemAtPath(filePath_Class)
                    try fileManager.removeItemAtPath(filePath_Code)
                    try fileManager.removeItemAtPath(filePath_Year)
                    try fileManager.removeItemAtPath(filePath_Grade)
                    try fileManager.removeItemAtPath(filePath_Credits)
                    print("DELETED")
                } catch let error as NSError {
                    print("Ooops! Something went wrong: \(error)")
                }
            } else {
                var writeClassName = ""
                for i in 0..<ClassNameList.count {
                    writeClassName += ClassNameList[i] + ","
                }
                var writeCode = ""
                for i in 0..<CodeList.count {
                    writeCode += CodeList[i] + ","
                }
                var writeYear = ""
                for i in 0..<YearList.count {
                    writeYear += YearList[i] + ","
                }
                var writeCredits = ""
                for i in 0..<CreditsList.count {
                    writeCredits += CreditsList[i] + ","
                }
                var writeGrades = ""
                for i in 0..<GradeList.count {
                    writeGrades += GradeList[i] + ","
                }
                do {
                    _ = try writeClassName.writeToFile(filePath_Class, atomically: true, encoding: NSUTF8StringEncoding)
                    _ = try writeCode.writeToFile(filePath_Code, atomically: true, encoding: NSUTF8StringEncoding)
                    _ = try writeYear.writeToFile(filePath_Year, atomically: true, encoding: NSUTF8StringEncoding)
                    _ = try writeCredits.writeToFile(filePath_Credits, atomically: true, encoding: NSUTF8StringEncoding)
                    _ = try writeGrades.writeToFile(filePath_Grade, atomically: true, encoding: NSUTF8StringEncoding)
                } catch {
                    print("Error Save from DiplomaView")
                }
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
}