//
//  ViewController.swift
//  SimpleCalculator
//
//  Created by Nidhishree on 23/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

///class which does all the basic operations using stack object
class OnBoardingVC: BaseVC {
    var nameStack = Stack()
    var emptyString: String = ""
    
    @IBOutlet weak var calculationLabel: UILabel!
    @IBOutlet weak var onBoardingCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension OnBoardingVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OperatorValue.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let onBoardingCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: OnBoardingCell.self), for: indexPath) as? OnBoardingCell else { return OnBoardingCell() }
        onBoardingCell.layer.cornerRadius = onBoardingCell.frame.width/2
        
        onBoardingCell.valueLabel.text = OperatorValue.allCases[indexPath.row].operatorValue
        onBoardingCell.valueLabel.tag = indexPath.row
        if (onBoardingCell.valueLabel.tag == IndexValues.divideOperator.rawValue) || (onBoardingCell.valueLabel.tag == IndexValues.multiplyOperator.rawValue) || (onBoardingCell.valueLabel.tag == IndexValues.subtractOperator.rawValue) || (onBoardingCell.valueLabel.tag == IndexValues.addOperator.rawValue) || (onBoardingCell.valueLabel.tag == IndexValues.equalToOperator.rawValue) {
            onBoardingCell.backgroundColor = UIColor.getyellowOrange()
            onBoardingCell.valueLabel.backgroundColor = UIColor.getyellowOrange()
        } else if (onBoardingCell.valueLabel.tag == IndexValues.cancelOperator.rawValue) || (onBoardingCell.valueLabel.tag == IndexValues.plusMinusOperator.rawValue) || (onBoardingCell.valueLabel.tag == IndexValues.percentageOperator.rawValue)  {
            onBoardingCell.valueLabel.backgroundColor = UIColor.getTinColor()
            onBoardingCell.valueLabel.textColor = UIColor.black
            onBoardingCell.backgroundColor = UIColor.getTinColor()
        }
        if indexPath.row == IndexValues.numberZero.rawValue {
            onBoardingCell.layer.cornerRadius = onBoardingCell.frame.height / 2
            onBoardingCell.valueLabel.textAlignment = .left
        }
        calculationLabel.text = "0"
        return onBoardingCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? OnBoardingCell
        let firstCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? OnBoardingCell
        let storeCheckValue = Values.checkValue(value: cell?.valueLabel.text ?? "")
        let storeValue = cell?.valueLabel.text ?? ""
        let topElement = nameStack.peek()
        if storeValue == "AC" {
            calculationLabel.text = "0"
            return
        }
        if storeCheckValue == Values.cancel {
            nameStack.popAllElements()
            calculationLabel.text = "0"
        } else if storeCheckValue == Values.number {
            //stack doesnt have a value
            if nameStack.count() == 0 {
                nameStack.push(cell?.valueLabel.text ?? "")
                calculationLabel.text = cell?.valueLabel.text
                firstCell?.valueLabel.text = "C"
                return
            }
            
            if Values.checkValue(value: topElement) == Values.number {
                //when user enters a two digit number
                if let storeNumber  = cell?.valueLabel.text {
                    let popedNumber = nameStack.pop()
                    let appendNumber = (popedNumber ?? "") + storeNumber
                    nameStack.push(appendNumber)
                    calculationLabel.text = appendNumber
                }
            }   //when the user wants to enter more than one digit for second number
            else if Values.checkValue(value: topElement) == Values.operators {
                var appendSecondNumber: String = ""
                if let storeSecondNumber = cell?.valueLabel.text {
                    appendSecondNumber =  appendSecondNumber + storeSecondNumber
                    nameStack.push(appendSecondNumber)
                    calculationLabel.text = appendSecondNumber
                }
                //when the number starts with a decimal point
            } else if Values.checkValue(value: topElement) == Values.decimalPoint {
                if let storeNumber = cell?.valueLabel.text {
                    let poppedNumber = nameStack.pop()
                    let appendNumber = (poppedNumber ?? "") + storeNumber
                    nameStack.push(appendNumber)
                    calculationLabel.text = appendNumber
                }
            }
            //checking for operators
        }  else if storeCheckValue == Values.operators {
            // the user presses on an operator first
            if nameStack.count() == 0 {
                calculationLabel.text = "0"
                
            } else if nameStack.count() == 1 {
                //                if nameStack.peek().contains(".") {
                //                    let poppedNumber = nameStack.pop()
                //                    nameStack.push(poppedNumber ?? "")
                let poppedElement = nameStack.pop() ?? ""
                if !(poppedElement.contains(".")){
                    let poppedNumber = poppedElement + ".0"
                    nameStack.push(poppedNumber)
                } else {
                    nameStack.push(poppedElement)
                }
                nameStack.push(OperatorValue.allCases[indexPath.row].operatorValue)
                //calculate result
            }
            else if Values.checkValue(value: topElement) == Values.number {
                calculationLabel.text =  calculateResult(stackValues: &nameStack)
                nameStack.push(OperatorValue.allCases[indexPath.row].operatorValue)
                // if the user enters second operator by mistake
            } else if Values.checkValue(value: topElement) == Values.operators {
                if let storeOperator = cell?.valueLabel.text {
                    nameStack.pop()
                    nameStack.push(storeOperator)
                }
            }
        } else if storeCheckValue == Values.equalTo {
            if nameStack.count() == 0 {
                calculationLabel.text = "0"
                return
            } else if Values.checkValue(value: topElement) == Values.operators {
                let storeBottomElement = nameStack.bottomElement()
                nameStack.push(storeBottomElement)
                calculationLabel.text = calculateResult(stackValues: &nameStack)
            }
            calculationLabel.text = calculateResult(stackValues: &nameStack)
        }
        else if storeCheckValue == Values.plusMinus {
            if nameStack.count() == 0 {
                calculationLabel.text = "0"
            }
            else if Values.checkValue(value: topElement) == Values.number {
                let number = Int(nameStack.pop() ?? "")
                if let number = number {
                    let integerNumberSignChange = 0 - number
                    let stringNumberSignChange = String(integerNumberSignChange)
                    nameStack.push(stringNumberSignChange)
                    calculationLabel.text = stringNumberSignChange
                }
            }
        } else if storeCheckValue == Values.decimalPoint {
            var appendNumber = cell?.valueLabel.text ?? ""
            //stack is empty , want to start with point
            if nameStack.count() == 0 {
                nameStack.push(cell?.valueLabel.text ?? "")
                calculationLabel.text = cell?.valueLabel.text
                //return
            } // checking for how many points are there in an element
            else if nameStack.peek().contains(".") {
                return //appending a decimal point to the second number
            } else if Values.checkValue(value: topElement) == Values.operators {
                nameStack.push(appendNumber)
                calculationLabel.text = appendNumber
                //storing as one expression in stack 2.3 +
            } else if storeCheckValue == Values.operators {
                let poppedNumber =  Int(nameStack.pop() ?? "")
                if var poppedNumber = poppedNumber {
                    poppedNumber = poppedNumber  + 0
                    nameStack.push(String(poppedNumber))
                }
            }
            else {
                let poppedNumber =  nameStack.pop()
                appendNumber = (poppedNumber ?? "") + appendNumber
                nameStack.push(appendNumber)
                calculationLabel.text = appendNumber
            }
        } else if storeCheckValue == Values.percentage {
            if nameStack.count() == 0 {
                calculationLabel.text = "0"
            } else if Values.checkValue(value: topElement) == Values.number {
                let poppedNumber = Double(nameStack.pop() ?? "")
                if var poppedNumber = poppedNumber {
                    poppedNumber = poppedNumber / 100
                    nameStack.push(String(poppedNumber))
                    calculationLabel.text = String(poppedNumber)
                }
            }
        }
        
        if nameStack.count() > 0 {
            firstCell?.valueLabel.text = "C"
        } else {
            firstCell?.valueLabel.text = "AC"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? OnBoardingCell
        let storeCheckValue = Values.checkValue(value: cell?.valueLabel.text ?? "")
        if storeCheckValue == Values.number {
            cell?.valueLabel.backgroundColor = UIColor.lightGray
            cell?.backgroundColor = UIColor.lightGray
        } else if storeCheckValue == Values.operators {
            cell?.valueLabel.backgroundColor = UIColor.getLightOrange()
            cell?.backgroundColor = UIColor.getLightOrange()
            cell?.valueLabel.textColor = UIColor.getyellowOrange()
        } else if storeCheckValue == Values.decimalPoint {
            cell?.valueLabel.backgroundColor =  UIColor.lightGray
            cell?.backgroundColor = UIColor.lightGray
        } else if storeCheckValue == Values.cancel {
            cell?.valueLabel.backgroundColor = UIColor.white
            cell?.backgroundColor = UIColor.white
        } else if storeCheckValue == Values.plusMinus {
            cell?.valueLabel.backgroundColor = UIColor.white
            cell?.backgroundColor = UIColor.white
        } else if storeCheckValue == Values.percentage {
            cell?.valueLabel.backgroundColor = UIColor.white
            cell?.backgroundColor = UIColor.white
        } else if storeCheckValue == Values.equalTo {
            cell?.valueLabel.backgroundColor = UIColor.getLightOrange()
            cell?.backgroundColor = UIColor.getLightOrange()
            cell?.valueLabel.textColor = UIColor.white
        } else if storeCheckValue == Values.allClear {
            cell?.valueLabel.backgroundColor = UIColor.white
            cell?.backgroundColor = UIColor.white
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? OnBoardingCell
        //let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? OnBoardingCell
        
        let storeCheckValue = Values.checkValue(value: cell?.valueLabel.text ?? "")
        if storeCheckValue == Values.operators {
            cell?.valueLabel.backgroundColor = UIColor.getyellowOrange()
            cell?.backgroundColor = UIColor.getyellowOrange()
            cell?.valueLabel.textColor = UIColor.white
        } else if storeCheckValue == Values.equalTo {
            cell?.valueLabel.backgroundColor = UIColor.getyellowOrange()
            cell?.backgroundColor = UIColor.getyellowOrange()
            cell?.valueLabel.textColor = UIColor.white
        } else if storeCheckValue == Values.cancel {
            cell?.valueLabel.backgroundColor = UIColor.getTinColor()
            cell?.backgroundColor = UIColor.getTinColor()
        } else if storeCheckValue == Values.plusMinus {
            cell?.valueLabel.backgroundColor = UIColor.getTinColor()
            cell?.backgroundColor = UIColor.getTinColor()
        } else if storeCheckValue == Values.percentage {
            cell?.valueLabel.backgroundColor = UIColor.getTinColor()
            cell?.backgroundColor = UIColor.getTinColor()
        } else if storeCheckValue == Values.allClear {
            cell?.valueLabel.backgroundColor = UIColor.getTinColor()
            cell?.backgroundColor = UIColor.getTinColor()
        }
        else {
            cell?.valueLabel.backgroundColor = UIColor.getTungstenColor()
            cell?.backgroundColor = UIColor.getTungstenColor()
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension OnBoardingVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == IndexValues.numberZero.rawValue {
            return CGSize(width: (onBoardingCollectionView.frame.width - 20)/2, height: (onBoardingCollectionView.frame.width - 90)/4 )
        } else {
            return CGSize(width: (onBoardingCollectionView.frame.width - 90)/4, height: (onBoardingCollectionView.frame.width - 90)/4)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

