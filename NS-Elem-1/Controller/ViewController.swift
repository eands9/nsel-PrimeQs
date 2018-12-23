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

    var questionTxt : String = ""
    var answerCorrect = ""
    var answerUser = ""
    var isShow: Bool = false
    
    var randomIndex = 0
    var randomIndexA = 0
    var randomNumA = 0
    var randomNumB = 0
    var randomMultiplier = 0
    var firstNum = 0.00
    var secondNum = 0.00
    var thirdNum = 0
    var fourthNum = 0
    
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
        randomIndexA = Int.random(in: 0...1)
        switch randomIndexA{
        case 0:
            randomMultiplier = (Int.random(in: 2...7))*2
            randomNumA = Int.random(in: 5...15)
            randomNumB = Int.random(in: 10...20)
            while randomNumA == randomNumB{
                randomNumA = Int.random(in: 5...15)
                randomNumB = Int.random(in: 10...20)
            }
            firstNum = Double(randomNumA) / 2
            secondNum = firstNum * Double(randomMultiplier)
            thirdNum = randomNumB
            fourthNum = thirdNum * randomMultiplier
        case 1:
            randomMultiplier = (Int.random(in: 2...7))
            randomNumA = Int.random(in: 5...15)
            randomNumB = Int.random(in: 10...20)
            while randomNumA == randomNumB{
                randomNumA = Int.random(in: 5...15)
                randomNumB = Int.random(in: 10...20)
            }
            firstNum = Double(randomNumA)
            secondNum = Double(randomNumB)
            thirdNum = randomNumA * randomMultiplier
            fourthNum = randomNumB * randomMultiplier
        default:
            firstNum = 9.99
            secondNum = 9.99
            thirdNum = 99
            fourthNum = 99
        }
        
        randomIndex = Int.random(in: 0...3)
        switch randomIndex{
        case 0:
            questionLabel.text = "  ____ is to \(secondNum) as \(thirdNum) is to \(fourthNum)."
            answerCorrect = String(firstNum)
        case 1:
            questionLabel.text = "\(firstNum) is to ____ as \(thirdNum) is to \(fourthNum)."
            answerCorrect = String(secondNum)
        case 2:
            questionLabel.text = "\(firstNum) is to \(secondNum) as ____ is to \(fourthNum)."
            answerCorrect = String(thirdNum)
        case 3:
            questionLabel.text = "\(firstNum) is to \(secondNum) as \(thirdNum) is to ____."
            answerCorrect = String(fourthNum)
        default:
            questionLabel.text = "999"
            answerCorrect = "999"
        }

    }
    
    @IBAction func showBtn(_ sender: Any) {
        answerTxt.text = answerCorrect
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
}

