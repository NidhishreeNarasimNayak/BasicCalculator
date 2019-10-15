//
//  BaseVC.swift
//  SimpleCalculator
//
//  Created by Nidhishree on 01/10/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation
import UIKit


class BaseVC: UIViewController {
    
}
/// extension which calculates the result of the expression
extension BaseVC {
    ///function which calculates the result of two operands
    func calculateResult(stackValues: inout Stack) -> String {
        var stringStored: String = ""
        for _ in 0..<stackValues.count() {
            stringStored = (stackValues.pop() ?? "") + stringStored
        }
        let expression: NSExpression = NSExpression(format: stringStored)
        guard let result = expression.expressionValue(with: nil, context: nil) as? Double else { return "nil"  }
            if result.truncatingRemainder(dividingBy: 1) == 0 {
                let convertResultToInt = Int(result)
                let convertResultToString = String(convertResultToInt)
                stackValues.push(convertResultToString)
                return convertResultToString
                /// to get result in Double if the  result doesnt end with ".0"
            } else {
                let convertResultToString = String(result)
                stackValues.push(convertResultToString)
                return convertResultToString
            }
    }
}
