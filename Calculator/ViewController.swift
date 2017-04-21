//
//  ViewController.swift
//  Calculator
//
//  Created by Bruce Burgess on 4/12/17.
//  Copyright © 2017 Red Raven Computing Studios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var userIsInTheMiddleOfTyping = false

    @IBAction func touchDigit(_ sender: UIButton) {
        
        
        let digit = sender.currentTitle!
        if canDigitBeAddToDisplayFromInput(digit: digit) {
            if userIsInTheMiddleOfTyping {
                let textCurrentlyInDisplay = display.text!
                display.text = textCurrentlyInDisplay + digit
            } else {
                display.text = digit
                userIsInTheMiddleOfTyping = true
            }
        }
        
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        
        if let description = brain.getDescription {
            descriptionLabel.text = description
        }
    }
    
    private func canDigitBeAddToDisplayFromInput(digit: String) -> Bool {
        if digit == "." {
            
            if ((display.text?.range(of: ".")) != nil) {
                return false
            }
            
            if !userIsInTheMiddleOfTyping {
                userIsInTheMiddleOfTyping = true
                return true
            }

        }
        return true
    }
    
    @IBAction func clearCalculator(_ sender: UIButton) {
        brain.clearOutBrain()
        display.text = "0"
        descriptionLabel.text = "0"
    }
    
    
    
}

