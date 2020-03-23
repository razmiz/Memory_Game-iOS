//
//  ViewController.swift
//  MemoryGame
//
//  Created by Raz on 19/03/2020.
//  Copyright © 2020 Raz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highestScoreLabel: UILabel!
    
    
    var emojiArray: [String] = ["🐶", "🐸", "🐣", "🐱", "🐠", "🦞", "🐝", "🐳", "🦄", "🐓"]
    var tagsArray: [Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
    var cardsTuple: (card1Tag: Int, card1Emoji: String, card2Tag: Int , card2Emoji: String) = (0, " ", 0, " ")
    var taps: Int = 0
    var currentScore: Int = 0
    var highestScore: Int = 0
    let preferences = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shuffleCards()
        configureButton()
        setScore()
        sethighestScore()
    }
    
    @IBAction func cardButtonTapped(_ sender: UIButton) {
        let emoji = emojiArray[sender.tag % 10]
        if sender.title(for: .normal) != emoji {
            sender.setTitle(emoji, for: .normal)
            
            switch taps {
            case 0:
                cardsTuple.card1Tag = sender.tag
                cardsTuple.card1Emoji = emoji
                taps += 1
            case 1:
                cardsTuple.card2Tag = sender.tag
                cardsTuple.card2Emoji = emoji
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    if !self.checkCardsEmoji() {
                        self.clearCards()
                    } else {
                        let index1 = self.cardsTuple.card1Tag
                        let index2 = self.cardsTuple.card2Tag
                        
                        self.tagsArray[index1] = -1
                        self.tagsArray[index2] = -1
                        let lastTag = self.tagsArray.sorted().last
                        if lastTag! > -1{
                            self.showToast(message: "YAY 😊!!!")
                        }
                        self.currentScore += 5
                        self.setScore()
                    }
                    self.cardsTuple = (0, " ", 0, " ")
                    self.checkEndOfGame()
                }
                taps = 0
            default:
                taps = 0
                cardsTuple = (0, " ", 0, " ")
            }
        }
    }
    
    func checkCardsEmoji() -> Bool{
        return cardsTuple.card1Emoji == cardsTuple.card2Emoji && cardsTuple.card2Emoji != " " && cardsTuple.card1Emoji != " "
    }
    
    func clearCards(){
        for button in cardButtons{
            if tagsArray.contains(button.tag){
                button.setTitle(" ", for: .normal)
            }
        }
        currentScore -= 1
        setScore()
    }
    
    func shuffleCards(){
        let newArray = emojiArray.shuffled()
        emojiArray = newArray
    }
    
    func configureButton(){
        var number = 0
        let shuffledArray = tagsArray.shuffled()
    
        for button in cardButtons{
            button.layer.cornerRadius = 10
            button.titleLabel?.font = UIFont.systemFont(ofSize: 50)
//            button.backgroundColor = UIColor.white
            button.tag = shuffledArray[number]
            number += 1
        }
    }
    
    func checkEndOfGame(){
        if currentScore > highestScore{
            sethighestScore()
        }
        if tagsArray.sorted().last == -1{
            showToast(message: "Congratulations")
            newGameButton.isHidden = false
            saveScore(scoreToSave: highestScore)
//            for card in cardButtons{
//                card.backgroundColor = UIColor.green
//            }
        }
        
    }
    
    
    @IBAction func newGameAction(_ sender: UIButton) {
        newGameButton.isHidden = true
        tagsArray = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
        clearCards()
        currentScore = 0
        viewDidLoad()
    }
    
    
    func setScore(){
        if currentScore < 0 {
            currentScore = 0
        }
        scoreLabel.text = "Score: \(currentScore) "
        
    }
    
    func sethighestScore(){
        highestScore = savedScore
        if currentScore > highestScore{
            highestScore = currentScore
        }
        highestScoreLabel.text = "Highest Score: \(highestScore)"
    }
    
    
    func saveScore(scoreToSave: Int){
        preferences.set(scoreToSave, forKey: UserDefaultCodingKeys.currentScore.rawValue)
        preferences.synchronize()
    }
    
    var savedScore: Int {
       return preferences.integer(forKey: UserDefaultCodingKeys.currentScore.rawValue)
    }
    
}



extension ViewController{
    enum UserDefaultCodingKeys: String {
        case currentScore
    }
}



extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.01, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }

