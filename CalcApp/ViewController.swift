//
//  ViewController.swift
//  CalcApp
//
//  Created by Krisha Jivani on 7/2/21.
//

import UIKit
import CalcArithmetic //objc framework that contains core calculator arithmetic logic

class ViewController: UIViewController {
    
    //COMPLEX TEST CASES FOR REFERENCE:
    //cos(sin(30))*55+0.3
    //(20+4)*6+(8*3)*2+((1+2)+4)
    //2(6(3))
    //-(-(-3))

    @IBOutlet weak var expressionLabel: UILabel! //displays complete inputted expression once the "=" button is clicked
    
    @IBOutlet weak var displayLabel: UILabel! //displays current input as well as final result once the "=" button is clicked
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func sinButton(_ sender: UIButton) {
        onButtonPress(btnText: "sin(")
    }
    
    @IBAction func cosButton(_ sender: UIButton) {
        onButtonPress(btnText: "cos(")
    }
    
    @IBAction func tanButton(_ sender: UIButton) {
        onButtonPress(btnText: "tan(")
    }
    
    @IBAction func openParenButton(_ sender: UIButton) { //opening parenthesis
        onButtonPress(btnText: "(")
    }
    
    @IBAction func closeParenButton(_ sender: UIButton) { //closing parenthesis
        onButtonPress(btnText: ")")
    }
    
    @IBAction func zeroButton(_ sender: UIButton) {
        onButtonPress(btnText: "0")
    }
    
    @IBAction func oneButton(_ sender: UIButton) {
        onButtonPress(btnText: "1")
    }
    
    @IBAction func twoButton(_ sender: UIButton) {
        onButtonPress(btnText: "2")
    }
    
    @IBAction func threeButton(_ sender: UIButton) {
        onButtonPress(btnText: "3")
    }
    
    @IBAction func fourButton(_ sender: UIButton) {
        onButtonPress(btnText: "4")
    }
    
    @IBAction func fiveButton(_ sender: UIButton) {
        onButtonPress(btnText: "5")
    }
    
    @IBAction func sixButton(_ sender: UIButton) {
        onButtonPress(btnText: "6")
    }
    
    @IBAction func sevenButton(_ sender: UIButton) {
        onButtonPress(btnText: "7")
    }
    
    @IBAction func eightButton(_ sender: UIButton) {
        onButtonPress(btnText: "8")
    }
    
    @IBAction func nineButton(_ sender: UIButton) {
        onButtonPress(btnText: "9")
    }
    
    @IBAction func divideButton(_ sender: UIButton) {
        onButtonPress(btnText: "/")
    }
    
    @IBAction func multButton(_ sender: UIButton) {
        onButtonPress(btnText: "*")
    }
    
    @IBAction func subButton(_ sender: UIButton) {
        onButtonPress(btnText: "-")
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        onButtonPress(btnText: "+")
    }
    
    @IBAction func decPointButton(_ sender: UIButton) {
        onButtonPress(btnText: ".")
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        displayLabel.text = "0"
        expressionLabel.text = ""
    }
    
    var equalJustClicked = false
    
    @IBAction func equalButton(_ sender: UIButton) {
        let message = checkValidInput()
        if message == "NO ERROR" {
            let substr = CoreLogic(expression: displayLabel.text!).evaluate()
            expressionLabel.text = displayLabel.text
            if substr.count > 10 {
                displayLabel.text = String(substr.prefix(10))
            }
            else {
                displayLabel.text = String(substr)
            }
            
        }
        else {
            expressionLabel.text = message
            displayLabel.text = ""
        }
        
        equalJustClicked = true
    
    }
    
    private func onButtonPress(btnText : String) {
        if (equalJustClicked) {
            equalJustClicked = false
            displayLabel.text = ""
            expressionLabel.text = ""
        }
        if displayLabel.text == "0" {
            if btnText == ")" || btnText == "+" || btnText == "*" || btnText == "/" {
                return
            }
            displayLabel.text = btnText
        }
        else {
            displayLabel.text! += btnText
        }
    }
    
    
    private func checkValidInput() -> String { //checks if the inputted expression is valid
        let testing = InvalidExpressionHandling(expression: displayLabel.text!)
        //more tests can be added to checkArray!
        let checkArray = [testing.equalParen(), testing.divideByZero()]
        
        for checkMethod in checkArray {
            if checkMethod != "NO ERROR" {
                return checkMethod
            }
        }
        
        return "NO ERROR"
    }


}

@IBDesignable extension UIButton { //in order to customize button borders, adds border controls to Interface Builder

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
}
