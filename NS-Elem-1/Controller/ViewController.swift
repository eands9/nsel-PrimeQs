//
//  ViewController.swift
//  NS-Elem-1
//
//  Created by Eric Hernandez on 12/2/18.
//  Copyright © 2018 Eric Hernandez. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {

    @IBOutlet weak var answerTxt: UITextField!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var questionNumberLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    var randomPick: Int = 0
    var correctAnswers: Int = 0
    var numberAttempts: Int = 0
    var timer = Timer()
    var counter = 0.0

    var randomNumA : Int = 0
    var randomNumB : Int = 0
    var questionTxt : String = ""
    var answerCorrect = ""
    var answerUser = ""
    var isShow: Bool = false
    
    var randomNum = 0
    var randomDen = 0
    var numerator = 0.00
    var denominator = 0.00
    var answerPercent: String? = ""
    var answerDecimal: String? = ""
    var answerFraction: String = ""
    var fractionNum: String = ""
    var fractionDen: String = ""
    var randomDecimal = 0.00
    typealias Rational = (num : Int, den : Int)
    let unitLists = [".","/","%"]
    var fromUnit = ""
    var toUnit = ""
    
    let congratulateArray = ["Great Job", "Excellent", "Way to go", "Alright", "Right on", "Correct", "Well done", "Awesome","Give me a high five"]
    let retryArray = ["Try again","Oooops"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        askQuestion()
        
        timerLbl.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        
        self.answerTxt.becomeFirstResponder()
    }

    @IBAction func checkAnswerByUser(_ sender: Any) {
        checkAnswer()
    }
    
    func askQuestion(){
        randomNumA = Int.random(in: 0...2)
        randomNumB = Int.random(in: 0...2)
        while randomNumA == randomNumB{
            randomNumA = Int.random(in: 0...2)
            randomNumB = Int.random(in: 0...2)
        }
        fromUnit = unitLists[randomNumA]
        toUnit = unitLists[randomNumB]
        
        randomNum = Int.random(in: 1...8)
        randomDen = Int.random(in: 1...8)
        
        while randomNum >= randomDen {
            randomNum = Int.random(in: 1...8)
            randomDen = Int.random(in: 1...8)
        }
        if randomDen == 7{
            randomDen += 1
        }
        numerator = Double(randomNum)
        denominator = Double(randomDen)
        randomDecimal = numerator/denominator
        fractionNum = String(randomNum)
        fractionDen = String(randomDen)
        answerFraction = "\(fractionNum) / \(fractionDen)"
        answerTxt.text = toUnit

        answerTxt.text = "\(toUnit)"
        switch randomNumA{
        case 0: //question is decimal
            questionLabel.text = getDecimal(dec: randomDecimal)
            switch randomNumB{
            case 1: //answer is fraction
                answerCorrect = answerFraction
                answerTxt.text = "/ \(fractionDen)"
            case 2: //answer is percent
                answerCorrect = getPercent(fraction:randomDecimal)
            default:
                answerCorrect = "999"
            }
        case 1: //question is fraction
            questionLabel.text = answerFraction
            switch randomNumB{
            case 0: //answer is decimal
                answerCorrect = getDecimal(dec: randomDecimal)
            case 2: //answer is percent
                answerCorrect = getPercent(fraction:randomDecimal)
            default:
                answerCorrect = "999"
            }
        case 2: //question is percent
            questionLabel.text = getPercent(fraction:randomDecimal)
            switch randomNumB{
            case 0: //answer is decimal
                answerCorrect = getDecimal(dec: randomDecimal)
            case 1: //answer is fraction
                answerCorrect = answerFraction
                answerTxt.text = "/ \(fractionDen)"
            default:
                answerCorrect = "999"
            }
        default:
            answerCorrect = "999"
        }
    }
    
    @IBAction func showBtn(_ sender: Any) {
        answerTxt.text = String(answerCorrect)
        isShow = true
    }
    
    func checkAnswer(){
        answerUser = answerTxt.text!
        if answerUser == answerCorrect && isShow == false {
            correctAnswers += 1
            numberAttempts += 1
            updateProgress()
            randomPositiveFeedback()
            answerTxt.text = ""
            askQuestion()
            
        }
        else if isShow == true {
            readMe(myText: "Next Question")
            isShow = false
            answerTxt.text = ""
            numberAttempts += 1
            updateProgress()
            askQuestion()
        }
        else{
            randomTryAgain()
            answerTxt.text = ""
            numberAttempts += 1
            updateProgress()
        }
    }
    @objc func updateTimer(){
        counter += 0.1
        timerLbl.text = String(format:"%.1f",counter)
    }
    func readMe( myText: String) {
        let utterance = AVSpeechUtterance(string: myText )
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    func randomPositiveFeedback(){
        randomPick = Int(arc4random_uniform(9))
        readMe(myText: congratulateArray[randomPick])
    }
    func updateProgress(){
        progressLbl.text = "\(correctAnswers) / \(numberAttempts)"
    }
    func randomTryAgain(){
        randomPick = Int(arc4random_uniform(2))
        readMe(myText: retryArray[randomPick])
    }
    func getDecimal (dec: Double) -> String {
        let decFormatter = NumberFormatter()
        decFormatter.numberStyle = NumberFormatter.Style.decimal
        decFormatter.multiplier = 1
        decFormatter.minimumFractionDigits = 1
        decFormatter.maximumFractionDigits = 4
        answerDecimal = decFormatter.string(for: dec)
        return (answerDecimal)!
    }
    func getFraction(dec : Double, withPrecision eps : Double = 1.0E-6) -> Rational {
        var x = dec
        var a = floor(x)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)
        
        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = floor(x)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        return (h, k)
    }
    func getPercent (fraction: Double) -> String {
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = NumberFormatter.Style.percent
        percentFormatter.multiplier = 1
        percentFormatter.minimumFractionDigits = 1
        percentFormatter.maximumFractionDigits = 2
        answerPercent = percentFormatter.string(for: fraction*100)
        return (answerPercent)!
    }
}

