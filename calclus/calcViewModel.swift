//
//  calcViewModel.swift
//  calclus
//
//  Created by Vivek on 10/10/26.
//

import Foundation

// MARK: - ViewModel (MVVM Architecture)
@Observable
class CalculatorViewModel {
    private var model = CalculatorModel()
    
    var displayValue: String { model.displayValue }
    var historyString: String { model.historyString }
    
    func receiveInput(_ key: String) {
        switch key {
        case "0"..."9": appendNumber(key)
        case ".": appendDecimal()
        case "+", "-", "*", "/": setOperation(key)
        case "=": calculateResult()
        case "AC": clearAll()
        case "+/-": toggleSign()
        case "%": percentage()
        default: break
        }
    }
    
    private func appendNumber(_ digit: String) {
        if !model.isEnteringNumber {
            model.displayValue = digit
            model.isEnteringNumber = true
        } else {
            model.displayValue = model.displayValue == "0" ? digit : model.displayValue + digit
        }
    }
    
    private func appendDecimal() {
        if !model.isEnteringNumber {
            model.displayValue = "0."
            model.isEnteringNumber = true
        } else if !model.displayValue.contains(".") {
            model.displayValue += "."
        }
    }
    
    private func setOperation(_ op: String) {
        if let value = Double(model.displayValue) {
            model.firstOperand = value
        }
        model.pendingOperation = op
        model.isEnteringNumber = false
        
        let symbolMap = ["/": "÷", "*": "×", "-": "-", "+": "+"]
        model.historyString = "\(model.displayValue) \(symbolMap[op] ?? op)"
    }
    
    private func calculateResult() {
        guard let op = model.pendingOperation,
              let first = model.firstOperand,
              let second = Double(model.displayValue) else { return }
        
        var result: Double = 0
        switch op {
        case "+": result = first + second
        case "-": result = first - second
        case "*": result = first * second
        case "/": result = second != 0 ? first / second : 0
        default: return
        }
        
        let symbolMap = ["/": "÷", "*": "×", "-": "-", "+": "+"]
        model.historyString = "\(first.formatted()) \(symbolMap[op] ?? op) \(second.formatted()) ="
        model.displayValue = formatResult(result)
        model.firstOperand = nil
        model.pendingOperation = nil
        model.isEnteringNumber = false
    }
    
    private func formatResult(_ val: Double) -> String {
        if val.truncatingRemainder(dividingBy: 1) == 0 && abs(val) < 1e12 {
            return String(Int(val))
        }
        return String(val)
    }
    
    private func clearAll() {
        model = CalculatorModel()
    }
    
    private func toggleSign() {
        if let val = Double(model.displayValue), val != 0 {
            model.displayValue = model.displayValue.hasPrefix("-") ? String(model.displayValue.dropFirst()) : "-" + model.displayValue
        }
    }
    
    private func percentage() {
        if let val = Double(model.displayValue) {
            model.displayValue = formatResult(val / 100.0)
        }
    }
}
