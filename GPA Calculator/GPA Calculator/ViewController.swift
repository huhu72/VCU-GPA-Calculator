//
//  ViewController.swift
//  GPA Calculator
//
//  Created by Spencer Kinsey-Korzym on 2/3/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var credits: UITextField!
    @IBOutlet weak var assignmentPoints: UITextField!
    @IBOutlet weak var assignmentMaxPoints: UITextField!
    @IBOutlet weak var assignmentWeight: UITextField!
    @IBOutlet weak var midtermPoints: UITextField!
    @IBOutlet weak var midtermMaxPoints: UITextField!
    @IBOutlet weak var midtermWeight: UITextField!
    @IBOutlet weak var finalPoints: UITextField!
    @IBOutlet weak var finalMaxPoints: UITextField!
    @IBOutlet weak var finalWeight: UITextField!
    @IBOutlet weak var addCourse: UIButton!
    @IBOutlet weak var removeCourse: UIButton!
    @IBOutlet weak var firstCourse: UILabel!
    @IBOutlet weak var secondCourse: UILabel!
    @IBOutlet weak var thirdCourse: UILabel!
    @IBOutlet weak var forthCourse: UILabel!
    @IBOutlet weak var firstCourseGrade: UIImageView!
    @IBOutlet weak var secondCourseGrade: UIImageView!
    @IBOutlet weak var thirdCourseGrade: UIImageView!
    @IBOutlet weak var forthCourseGrade: UIImageView!
    @IBOutlet weak var gpaCredits: UILabel!
    @IBOutlet weak var gpaLabel: UILabel!
    @IBOutlet weak var classID: UITextField!
    
    var courses: [Course] = []
    var chalkBoardCourses: [(class: UILabel, grade: UIImageView)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        courseName.delegate = self
        chalkBoardCourses = [
            (firstCourse, firstCourseGrade), (secondCourse, secondCourseGrade),
            (thirdCourse, thirdCourseGrade), (forthCourse, forthCourseGrade),
        ]
        removeCourse.isEnabled = false
    }
    
   
    
    func checkErrors() -> Bool {
        if courses.contains(where: { $0.name == courseName.text!.capitalized })
        {
            showAlert(for: "Repeat")
        } else if courses.count == 4 {
            showAlert(for: "Course")
        } else if (Double(assignmentWeight.text!)!
                   + Double(midtermWeight.text!)!
                   + Double(finalWeight.text!)!) != 100.00
        {
            showAlert(for: "Assesment", location: "Weight")
        } else if Double(assignmentPoints.text!)! > Double(
            assignmentMaxPoints.text!)! || Double(assignmentPoints.text!)! < 0
        {
            showAlert(for: "Assesment", location: "Assignment")
        } else if Double(midtermPoints.text!)! > Double(midtermMaxPoints.text!)!
                    || Double(midtermPoints.text!)! < 0
        {
            showAlert(for: "Assesment", location: "Midterm")
        } else if Double(finalPoints.text!)! > Double(finalMaxPoints.text!)!
                    || Double(finalPoints.text!)! < 0
        {
            showAlert(for: "Assesment", location: "Final")
        } else {
            return false
        }
        return true
    }
    
    func showAlert(for type: String, location: String? = nil) {
        var reason: String = ""
        var alertController: UIAlertController!
        let alertAction = UIAlertAction(
            title: "Dismiss", style: .cancel, handler: { (action) in })
        switch type {
        case "Assesment":
            if location! == "Weight" {
                alertController = UIAlertController(
                    title: "\(reason) ERROR",
                    message: "The sum of the weights must add up to 100 ",
                    preferredStyle: .alert)
                break
            }
            switch location! {
            case "Assignment": reason = location!
            case "Midterm": reason = location!
            case "Final": reason = location!
            default: print()
            }
            alertController = UIAlertController(
                title: "\(reason) ERROR",
                message: "Points must be between 0 to max points ",
                preferredStyle: .alert)
        case "Course":
            alertController = UIAlertController(
                title: "ERROR", message: "The max course allowed is 4",
                preferredStyle: .alert)
        case "Repeat":
            alertController = UIAlertController(
                title: "ERROR", message: "This class already exists",
                preferredStyle: .alert)
        default:
            alertController = UIAlertController(
                title: "ERROR",
                message: "You're trying to remove a class that does not exist",
                preferredStyle: .alert)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func addCourse(_ sender: Any) {
        if checkErrors() { return }
        let assignments = Assesment(
            points: Double(assignmentPoints.text!)!,
            maxPoints: Double(assignmentMaxPoints.text!)!,
            weight: Double(assignmentWeight.text!)!)
        let midterm = Assesment(
            points: Double(midtermPoints.text!)!,
            maxPoints: Double(midtermMaxPoints.text!)!,
            weight: Double(midtermWeight.text!)!)
        let final = Assesment(
            points: Double(finalPoints.text!)!,
            maxPoints: Double(finalMaxPoints.text!)!,
            weight: Double(finalWeight.text!)!)
        courses.append(
            Course(
                assesmentArray: [assignments, midterm, final],
                name: courseName.text!.capitalized,
                credits: Double(credits.text!)!))
        updateChalkBoard()
        removeCourse.isEnabled = true
    }
    
    @IBAction func removeCourse(_ sender: Any) {
        let courseID: Int = Int(classID.text!)!
        if courseID > courses.count {
            showAlert(for: "DNE")
            return
        }
        courses.remove(at: courseID - 1)
        for i in courses.count...3 {
            chalkBoardCourses[i].class.isHidden = true
            chalkBoardCourses[i].grade.isHidden = true
        }
        updateChalkBoard()
        if courses.isEmpty {
            gpaLabel.textColor = UIColor.white
            gpaCredits.isHidden = true
            removeCourse.isEnabled = false
        }
    }
    
    func updateChalkBoard() {
        for i in courses.indices {
            chalkBoardCourses[i].class.text =
            "\(i+1)) \(courses[i].name) | \(courses[i].credits)"
            chalkBoardCourses[i].class.isHidden = false
            switch courses[i].finalGrade {
            case 90...100:
                chalkBoardCourses[i].grade.image = UIImage(named: "A")
                courses[i].gradePoint = 4
            case 80...89.9:
                chalkBoardCourses[i].grade.image = UIImage(named: "B")
                courses[i].gradePoint = 3
            case 70...79.9:
                chalkBoardCourses[i].grade.image = UIImage(named: "C")
                courses[i].gradePoint = 2
            case 60...69.9:
                chalkBoardCourses[i].grade.image = UIImage(named: "D")
                courses[i].gradePoint = 1
            default:
                chalkBoardCourses[i].grade.image = UIImage(named: "F")
                courses[i].gradePoint = 0
            }
            chalkBoardCourses[i].grade.isHidden = false
        }
        updateGPA()
    }
    
    func updateGPA() {
        gpaCredits.text = String(getGPA())
        switch getGPA() {
        case 3.0...4.0:
            gpaLabel.textColor = UIColor.green
            gpaCredits.textColor = UIColor.green
        case 2.0...2.99:
            gpaCredits.textColor = UIColor.orange
            gpaLabel.textColor = UIColor.orange
        default:
            gpaLabel.textColor = UIColor.red
            gpaCredits.textColor = UIColor.red
        }
        gpaCredits.isHidden = false
    }
    
    func getGPA() -> Double {
        var gpa = 0.0
        var totalPoints = 0.0
        for course in courses { totalPoints += course.totalPoints }
        gpa = totalPoints / getTotalCreditHours()
        return (round(gpa * 100)) / 100.0
    }
    
    func getTotalCreditHours() -> Double {
        var totalCredits = 0.0
        for course in courses { totalCredits += course.credits }
        return totalCredits
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
struct Course {
    var assesmentArray: [Assesment] = []
    var name: String
    var credits: Double
    var gradePoint: Double!
    var finalGrade: Double { assesmentArray.reduce(0) { $0 + $1.grade } }
    var totalPoints: Double { gradePoint * credits }
}
struct Assesment {
    var points: Double!
    var maxPoints: Double!
    var weight: Double!
    var grade: Double { (points / maxPoints) * weight }
}

