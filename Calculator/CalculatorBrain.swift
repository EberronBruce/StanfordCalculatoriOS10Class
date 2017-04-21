//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Bruce Burgess on 4/13/17.
//  Copyright © 2017 Red Raven Computing Studios. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    private var resultIsPending: Bool = false
    private var description: String?
    private var currentOperand: String?
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "sin" : Operation.unaryOperation(sin),
        "tan" : Operation.unaryOperation(tan),
        "ln" : Operation.unaryOperation(log),
        "±" : Operation.unaryOperation( { -$0 }),
        "×" : Operation.binaryOperation({$0 * $1}),
        "÷" : Operation.binaryOperation({$0 / $1}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "−" : Operation.binaryOperation({$0 - $1}),
        "=" : Operation.equals,
    ]
    
    mutating func performOperation(_ symbol: String) {

        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                setDescriptionBaseOnConstant(symbol)
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    setDescriptionBaseOnUnaryOperation(symbol)
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function) :
                if accumulator != nil {
                    setDescriptionBasedOnBinaryOperation(symbol)
                    resultIsPending = true
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals :
                setDescriptionBaseOnEquals()
                performPendingBinaryOperation()
            }
        }
        
        
    }
    
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil && resultIsPending {
            accumulator = pendingBinaryOperation?.perform(with: accumulator!)
            resultIsPending = false
        }
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        if !resultIsPending {
            description = String(operand)
        } else {
            currentOperand = String(operand)
        }
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    
    private mutating func setDescriptionBaseOnEquals() {
        if(description != nil) && resultIsPending {
            description! += (" " + currentOperand!)
            currentOperand = "";
        }

    }
    
    private mutating func setDescriptionBaseOnConstant(_ symbol: String) {
        if !resultIsPending {
            description = symbol
        } else {
            currentOperand = symbol
        }

    }
    
    private mutating func setDescriptionBaseOnUnaryOperation(_ symbol: String) {
        if (description != nil) {
            if !resultIsPending {
                description! = ("\(symbol)(\(description!))")
                currentOperand = ""
            } else if (currentOperand != nil){
                description! += ("\(symbol)(\(currentOperand!))")
                currentOperand = ""
            }
        }

    }
    
    private mutating func setDescriptionBasedOnBinaryOperation(_ symbol: String) {
        if(description != nil) {
            if let operand = currentOperand {
                description! += (operand + " " + symbol)
            } else {
                description! = (description! + " " + symbol)
            }
        } else {
            if let operand = currentOperand {
                description = (operand + " " + symbol)
            }
            
        }

    }
    
    
    var getDescription: String? {
        get {
            
            if resultIsPending {
                if (description != nil) {
                    return description! + " ..."
                }
            } else {
                if (description != nil) {
                    return description! + " ="
                }
            }
            
            return nil
        }
    }
    
    mutating func clearOutBrain() {
        accumulator = nil
        resultIsPending = false
        description = nil
        currentOperand = nil
        pendingBinaryOperation = nil
    }
    
}





























