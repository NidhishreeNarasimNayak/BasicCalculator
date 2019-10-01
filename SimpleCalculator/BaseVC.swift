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
extension BaseVC {
    func calculateResult(stackValues: Stack) -> String {
        var stackValues = stackValues as Stack
        var stringStored: String = ""
        var convertedDoubleToString: String = ""
        for _ in 0..<stackValues.count() {
            stringStored = stackValues.pop() + stringStored
        }
        let expression: NSExpression = NSExpression(format: stringStored)
        guard let result = expression.expressionValue(with: nil, context: nil) as? Double else { return ""  }
        convertedDoubleToString = String(result)
        stackValues.push(convertedDoubleToString)
        return convertedDoubleToString
    }
}
