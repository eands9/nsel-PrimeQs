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
    @IBOutlet weak var questionLbl: UILabel!
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
    
    var convertRoman = ""
    var randomNumA : Int = 0
    var randomNumB : Int = 0
    var firstNum: Int = 0
    var secondNum: Int = 0
    var numA: Double = 0
    var numB: Double = 0
    var questionTxt : String = ""
    var answerCorrect : Double = 0
    var answerUser : Double = 0
    var isShow: Bool = false
    
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
        randomNumA = Int.random(in: 10000 ..< 1000000)
        randomNumB = Int.random(in: 10 ..< 1000)
        firstNum = randomNumA
        secondNum = randomNumB
        numA = Double(firstNum)
        numB = Double(secondNum)
        questionLabel.text = "\(firstNum) / \(secondNum)"
        answerCorrect = numA / numB
    }
    
    @IBAction func showBtn(_ sender: Any) {
        answerTxt.text = String(round(answerCorrect))
        isShow = true
    }
    
    func checkAnswer(){
        answerUser = (answerTxt.text! as NSString).doubleValue
        
        if answerUser >= answerCorrect * 0.95 && answerUser <= answerCorrect * 1.05 && isShow == false {
            correctAnswers += 1
            numberAttempts += 1
            updateProgress()
            randomPositiveFeedback()
            askQuestion()
            answerTxt.text = ""
        }
        else if isShow == true {
            readMe(myText: "Next Question")
            askQuestion()
            isShow = false
            answerTxt.text = ""
            numberAttempts += 1
            updateProgress()
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
    
    func toRoman(number: Int) -> String {
        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

        var startingValue = number
        var romanValue = ""
        for (index, romanChar) in romanValues.enumerated() {
            var arabicValue = arabicValues[index]
            var div = startingValue / arabicValue
            if (div > 0)
            {
                for j in 0..<div
                {
                    //println("Should add \(romanChar) to string")
                    romanValue += romanChar
                }
                startingValue -= arabicValue * div
            }
        }
        return romanValue
    }
}

