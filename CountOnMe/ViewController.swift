//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }
    
    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func effacer(_ sender: Any) {
        textView.text = ""
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        if expressionHaveResult {
            textView.text = ""
        }
        
        if(numberText != "AC"){
            textView.text.append(numberText)
        }
        
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if canAddOperator {
            let el = textView.text.split(separator: "=").map { "\($0)" }
            if(el.count >= 2){
                textView.text.removeAll()
                textView.text.append(el[1])
            }
            textView.text.append(" + ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if canAddOperator {
            let el = textView.text.split(separator: "=").map { "\($0)" }
            if(el.count >= 2){
                textView.text.removeAll()
                textView.text.append(el[1])
            }
            textView.text.append(" - ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        if canAddOperator {
            let el = textView.text.split(separator: "=").map { "\($0)" }
            if(el.count >= 2){
                textView.text.removeAll()
                textView.text.append(el[1])
            }
            textView.text.append(" / ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        if canAddOperator {
            let el = textView.text.split(separator: "=").map { "\($0)" }
            if(el.count >= 2){
                textView.text.removeAll()
                textView.text.append(el[1])
            }
            textView.text.append(" x ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard expressionIsCorrect else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Entrez une expression correcte !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        
        guard expressionHaveEnoughElement else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        var i=0
        
        while( i  < operationsToReduce.count){
            if(operationsToReduce.count <= i+2){
                break
            }
            let left = Double(operationsToReduce[i])!
            let operand = operationsToReduce[i+1]
            let right = Double(operationsToReduce[i+2])!
            
            var result: Double
            if operand=="x"{
                result = left * right
                operationsToReduce.remove(at:i+2)
                operationsToReduce.remove(at:i+1)
                operationsToReduce.remove(at:i)
                operationsToReduce.insert("\(result)", at: i)
                if(operationsToReduce.count <= 1){
                    break
                }
              
            }
            
            else if operand=="/"{
                result = left / right
                operationsToReduce.remove(at:i+2)
                operationsToReduce.remove(at:i+1)
                operationsToReduce.remove(at:i)
                operationsToReduce.insert("\(result)", at: i)
                if(operationsToReduce.count <= 1){
                    break
                }
            }
            
            else{
                i=i+2
            }
        
        }
        
    
        
        

        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
            
            let result: Double
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
                
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        textView.text.append(" = \(operationsToReduce.first!)")
    }

}

