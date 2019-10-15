//
//  OnboardingVM.swift
//  SimpleCalculator
//
//  Created by Nidhishree on 24/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation

//enum for showing data in collection View.
enum OperatorValue: String, CaseIterable {
    case cancelOperator
    case plusMinusOperator
    case percentageOperator
    case divideOperator
    case numberSeven
    case numberEight
    case numberNine
    case multiplyOperator
    case numberFour
    case numberFive
    case numberSix
    case subtractOperator
    case numberOne
    case numberTwo
    case numberThree
    case addOperator
    case numberZero
    case numberDecimal
    case equalToOperator
    
    var operatorValue: String {
        switch self {
        case .cancelOperator:
            return "AC"
        case .plusMinusOperator:
            return "+/-"
        case .percentageOperator:
            return "%"
        case .divideOperator:
            return "/"
        case .numberSeven:
            return "7"
        case .numberEight:
            return "8"
        case .numberNine:
            return "9"
        case .multiplyOperator:
            return "*"
        case .numberFour:
            return "4"
        case .numberFive:
            return "5"
        case .numberSix:
            return "6"
        case .subtractOperator:
            return "-"
        case .numberOne:
            return "1"
        case .numberTwo:
            return "2"
        case .numberThree:
            return "3"
        case .addOperator:
            return "+"
        case .numberZero:
            return "0"
        case .numberDecimal:
            return "."
        case .equalToOperator:
            return "="
        }
    }
}

struct Stack {
    /// to hold stack values
    private var items: [String] = []
    
    ///peek at the top most element of stack, just return the top most item
    func peek() -> String {
        guard let topElement = items.first else { return "The stack is empty"}
        return topElement
    } /// to pop the first element from stack
    mutating func pop() -> String? {
        return items.removeFirst()
    }
    mutating func push(_ element: String) {
        items.insert(element, at: 0)
    }
    mutating func popAllElements() {
        items.removeAll()
    } /// to pop the bottom element from a stack
    mutating func bottomElement() -> String {
        let bottomItem = items[items.count - 1]
        return bottomItem
    } /// number of elements present in the stack
    func  count() -> Int {
        return items.count
    }
}
///enum to check what kind of values are stored in the stack
enum Values: Int {
    case number
    case operators
    case cancel
    case equalTo
    case plusMinus
    case decimalPoint
    case percentage
    case allClear
    static func checkValue(value: String) -> Values {
        switch value {
        case "C":
            return cancel
        case "1"..."9":
            return number
        case "+","-","*","/":
            return operators
        case "=":
            return equalTo
        case "+/-":
            return plusMinus
        case ".":
            return decimalPoint
        case "%":
            return percentage
        case "AC":
            return allClear
        default:
            print("invalid operator")
        }
        return number
    }
}
///enum to get the index values of each operands and operators
enum IndexValues: Int {
    case cancelOperator
    case plusMinusOperator
    case percentageOperator
    case divideOperator
    case numberSeven
    case numberEight
    case numberNine
    case multiplyOperator
    case numberFour
    case numberFive
    case numberSix
    case subtractOperator
    case numberOne
    case numberTwo
    case numberThree
    case addOperator
    case numberZero
    case numberDecimal
    case equalToOperator
    
    var operatorValue: Int {
        switch  self {
        case .cancelOperator:
            return 0
        case .plusMinusOperator:
            return 1
        case .percentageOperator:
            return 2
        case .divideOperator:
            return 3
        case .numberSeven:
            return 4
        case .numberEight:
            return 5
        case .numberNine:
            return 6
        case .multiplyOperator:
            return 7
        case .numberFour:
            return 8
        case .numberFive:
            return 9
        case .numberSix:
            return 10
        case .subtractOperator:
            return 11
        case .numberOne:
            return 12
        case .numberTwo:
            return 13
        case .numberThree:
            return 14
        case .addOperator:
            return 15
        case .numberZero:
            return 16
        case .numberDecimal:
            return 17
        case .equalToOperator:
            return 18
        }
    }
}
