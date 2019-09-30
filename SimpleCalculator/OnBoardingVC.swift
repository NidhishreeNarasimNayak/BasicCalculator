//
//  ViewController.swift
//  SimpleCalculator
//
//  Created by Nidhishree on 23/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class OnBoardingVC: UIViewController {
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
        let onBoardingCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: OnBoardingCell.self), for: indexPath) as? OnBoardingCell
        onBoardingCell?.layer.cornerRadius = 52
        onBoardingCell?.valueLabel.text = OperatorValue.allCases[indexPath.row].operatorValue
        onBoardingCell?.valueLabel.tag = indexPath.row
        if (onBoardingCell?.valueLabel.tag == 3) || (onBoardingCell?.valueLabel.tag == 7) || (onBoardingCell?.valueLabel.tag == 11) || (onBoardingCell?.valueLabel.tag == 15) || (onBoardingCell?.valueLabel.tag == 18) {
            onBoardingCell?.valueLabel.backgroundColor = UIColor.getyellowOrange()
        }
        return onBoardingCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? OnBoardingCell
        let storeCheckValue = Values.checkValue(value: cell?.valueLabel.text ?? "")
        
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
            calculationLabel.text = cell?.valueLabel.text
            let topElement = nameStack.peek()
            
            if Values.checkValue(value: topElement) == Values.number {
                let popedNumber = nameStack.pop()
                
                //when user enters a two digit number
                if let storeNumber  = cell?.valueLabel.text {
                    let appendNumber = popedNumber + storeNumber
                    nameStack.push(appendNumber)
                    calculationLabel.text = appendNumber
                    print(calculationLabel.text)
                }
            }
            else if Values.checkValue(value: topElement) == Values.operators {
                //   var secondStringStored: String = ""
                var appendSecondNumber: String = ""
                if let storeSecondNumber = cell?.valueLabel.text {
                    appendSecondNumber =  appendSecondNumber + storeSecondNumber
                    nameStack.push(appendSecondNumber)
                    calculationLabel.text = appendSecondNumber
                }
            }
            
        }  else if storeCheckValue == Values.operators {
            nameStack.push(OperatorValue.allCases[indexPath.row].operatorValue)
        } else if storeCheckValue == Values.equalTo {
            var expresssionStored: String = ""
            var convertedDoubleToString: String = ""
            for _ in 0..<nameStack.count() {
                expresssionStored = nameStack.pop() + expresssionStored
            }
            let expression: NSExpression = NSExpression(format: expresssionStored)
            let result: Double? = expression.expressionValue(with: nil, context: nil) as? Double
            if let result = result {
                convertedDoubleToString = String(result)
                nameStack.push(convertedDoubleToString)
            }
            calculationLabel.text = convertedDoubleToString
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension OnBoardingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:  view.frame.width/4, height:  view.frame.width/4)
    }
}
//rghrth
//changes
