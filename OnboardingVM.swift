//
//  OnboardingVM.swift
//  SimpleCalculator
//
//  Created by Nidhishree on 24/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation

//enum for storing and showing data in collection View
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
            return "C"
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
    private  var items: [String] = []  // to hold stack values
    
    //peek at the top most element of stack, just return the top most item
    func peek() -> String {
        guard let topElement = items.first else { return "The stack is empty"}
        return topElement
    }
    mutating func pop() -> String {
        return items.removeFirst()
    }
    mutating func push(_ element: String) {
        items.insert(element, at: 0)
    }
    mutating func popAllElements() {
        items.removeAll()
    }
    func  count() -> Int {
        return items.count
    }
}

enum Values: Int {
    case number
    case operators
    case cancel
    case equalTo
    static func checkValue(value: String) -> Values {
        switch value {
        case "C":
            return cancel
        case "1"..."9",".":
            return number
        case "+","-","*","/":
            return operators
        case "=":
            return equalTo
        default:
            print("invalid operator")
        }
        return number
    }
}
