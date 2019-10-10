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
        //onBoardingCell.valueLabel.layer.cornerRadius = view.frame.width/2
        onBoardingCell.valueLabel.text = OperatorValue.allCases[indexPath.row].operatorValue
        onBoardingCell.valueLabel.tag = indexPath.row
        if (onBoardingCell.valueLabel.tag == 3) || (onBoardingCell.valueLabel.tag == 7) || (onBoardingCell.valueLabel.tag == 11) || (onBoardingCell.valueLabel.tag == 15) || (onBoardingCell.valueLabel.tag == 18) {
            onBoardingCell.valueLabel.backgroundColor = UIColor.getyellowOrange()
        } else if (onBoardingCell.valueLabel.tag == 0) || (onBoardingCell.valueLabel.tag == 1) || (onBoardingCell.valueLabel.tag == 2)  {
            onBoardingCell.valueLabel.backgroundColor = UIColor.getTinColor()
            onBoardingCell.valueLabel.textColor = UIColor.black
        }
        if indexPath.row == 16 {
            onBoardingCell.layer.cornerRadius = onBoardingCell.frame.height / 2
            onBoardingCell.valueLabel.textAlignment = .natural
        }
        return onBoardingCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? OnBoardingCell
        
        let storeCheckValue = Values.checkValue(value: cell?.valueLabel.text ?? "")
        let topElement = nameStack.peek()
        
        if storeCheckValue == Values.cancel {
            nameStack.popAllElements()
            calculationLabel.text = "0"
        } else if storeCheckValue == Values.number {
            //stack doesnt have a value
            if nameStack.count() == 0 {
                nameStack.push(cell?.valueLabel.text ?? "")
                calculationLabel.text = cell?.valueLabel.text
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
                    // pushToStack(storeNumber, nameStack)
                    let poppedNumber = nameStack.pop()
                    let appendNumber = (poppedNumber ?? "") + storeNumber
                    nameStack.push(appendNumber)
                    calculationLabel.text = appendNumber
                }
            } //checking for operators
        }  else if storeCheckValue == Values.operators {
            if nameStack.count() == 1 {
                //                    if Values.checkValue(value: topElement) == Values.decimalPoint || Values.number {
                if nameStack.peek().contains(".") {
                    let poppedNumber = nameStack.pop()
                    nameStack.push(poppedNumber ?? "")
                }
                nameStack.push(OperatorValue.allCases[indexPath.row].operatorValue)
                //calculate result
            } else if Values.checkValue(value: topElement) == Values.number {
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
            //let poppedNumber =  nameStack.pop()
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
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? OnBoardingCell
        let storeCheckValue = Values.checkValue(value: cell?.valueLabel.text ?? "")
        if storeCheckValue == Values.number {
            cell?.valueLabel.backgroundColor = UIColor.lightGray
        } else if storeCheckValue == Values.operators {
            cell?.valueLabel.backgroundColor = UIColor.getLightOrange()
        } else if storeCheckValue == Values.decimalPoint {
            cell?.valueLabel.backgroundColor =  UIColor.lightGray
        } else if storeCheckValue == Values.cancel {
            cell?.valueLabel.backgroundColor = UIColor.white
        } else if storeCheckValue == Values.plusMinus {
            cell?.valueLabel.backgroundColor = UIColor.white
        } else if storeCheckValue == Values.percentage {
            cell?.valueLabel.backgroundColor = UIColor.white
        } else if storeCheckValue == Values.equalTo {
            cell?.valueLabel.backgroundColor = UIColor.getLightOrange()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? OnBoardingCell
        let storeCheckValue = Values.checkValue(value: cell?.valueLabel.text ?? "")
        if storeCheckValue == Values.operators {
            cell?.valueLabel.backgroundColor = UIColor.getyellowOrange()
        } else if storeCheckValue == Values.equalTo {
            cell?.valueLabel.backgroundColor = UIColor.getyellowOrange()
        } else if storeCheckValue == Values.cancel {
            cell?.valueLabel.backgroundColor = UIColor.getTinColor()
        } else if storeCheckValue == Values.plusMinus {
            cell?.valueLabel.backgroundColor = UIColor.getTinColor()
        } else if storeCheckValue == Values.percentage {
            cell?.valueLabel.backgroundColor = UIColor.getTinColor()
        } else if storeCheckValue == Values.equalTo {
            cell?.valueLabel.backgroundColor = UIColor.getyellowOrange()
        }
        else {
            cell?.valueLabel.backgroundColor = UIColor.getTungstunColor()
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension OnBoardingVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 16 {
           return CGSize(width: (onBoardingCollectionView.frame.width - 20)/2, height: (onBoardingCollectionView.frame.width - 90)/5 )
        } else {
            return CGSize(width: (onBoardingCollectionView.frame.width - 90)/4, height: (onBoardingCollectionView.frame.width - 90)/4)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

