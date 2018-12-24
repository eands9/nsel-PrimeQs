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
    
    var numA = 0
    var numB = 0
    var numC = 0
    var diffCat = 0
    
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
        diffCat = Int.random(in: 0...3)
        switch diffCat{
        case 0:
            numA = Int.random(in: 12...100)
            numB = numA - 10
            getSumOfPrimeNumBetween(startNum: numB, stopNum: numA)
            questionLabel.text = "The sum of all prime numbers between \(numB) and \(numA)"
            answerCorrect = String(numC)
            numC = 0
        case 1:
            numA = (Int.random(in: 1...10))*10
            questionLabel.text = "The largest prime number less than \(numA) is"
            findLargestNumber()
            answerCorrect = String(numA)
            numA = 0
        case 2:
            numA = Int.random(in: 100...200)
            while isPrime(num: numA){
                numA = Int.random(in: 100...500)
            }
            questionLabel.text = "What is the smallest prime factor of \(numA)"
            let numD = (primeFactors(n: numA))
            let numE = numD.min()
            answerCorrect = String(numE!)
        case 3:
            numA = Int.random(in: 100...200)
            while isPrime(num: numA){
                numA = Int.random(in: 100...500)
            }
            questionLabel.text = "What is the largest prime factor of \(numA)"
            let numD = (primeFactors(n: numA))
            let numE = numD.max()
            answerCorrect = String(numE!)
        default:
            questionLabel.text="999"
            answerCorrect="999"
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
    func isPrime(num: Int) -> Bool {
        if num < 2 {
            return false
        }
        for i in 2..<num {
            if num % i == 0 {
                return false
            }
        }
        return true
    }
    func getSumOfPrimeNumBetween(startNum: Int, stopNum: Int){
        for i in (startNum+1)...(stopNum-1){
            if isPrime(num: i) == true{
                numC += i //is the sum of all prime number
            }
        }
    }
    func findLargestNumber(){
        while isPrime(num: numA) == false{
            numA -= 1
        }
    }
    func primeFactors(n: Int) -> Array<Int> {
        var n = n
        var factors = [Int]()
        for divisor in 2 ..< n {
            while n % divisor == 0 {
                factors.append(divisor)
                n /= divisor
            }
        }
        return factors
    }
}

