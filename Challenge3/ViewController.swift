//
//  ViewController.swift
//  Challenge3
//
//  Created by Melody Davis on 8/6/22.
//

import UIKit

class ViewController: UIViewController {
    var remainingTriesLabel: UILabel!
    var word: UILabel!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    var wordsArray = [String]()
    var currentWord = ""
    var calledLetters = [String]()
    var levelIndex = 0
    var incorrectGuesses = 7 {
        didSet {
            remainingTriesLabel.text = "Remaining Tries: \(incorrectGuesses)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .lightGray
        
        remainingTriesLabel = UILabel()
        remainingTriesLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingTriesLabel.textAlignment = .right
        remainingTriesLabel.text = "Remaining Tries: 7"
        remainingTriesLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(remainingTriesLabel)
        
        word = UILabel()
        word.translatesAutoresizingMaskIntoConstraints = false
        word.textAlignment = .center
        word.font = UIFont.systemFont(ofSize: 60)
        view.addSubview(word)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            remainingTriesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            remainingTriesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            remainingTriesLabel.bottomAnchor.constraint(equalTo: remainingTriesLabel.topAnchor, constant: 30),
            
            word.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            word.topAnchor.constraint(equalTo: remainingTriesLabel.bottomAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 128),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: word.bottomAnchor, constant: 10),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -100)
        ])
        
        let width = 750/13
        let height = 80
        
        for row in 0..<2 {
            for column in 0..<13 {
                let index = row * 13 + column
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                letterButton.setTitle(alphabetArray[index], for: .normal)
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.darkGray.cgColor
                letterButton.backgroundColor = UIColor.white
                letterButton.setTitleColor(.darkGray, for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLevels()
        loadLevel()
    }

    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        let currentSolution = word.text
        var newSolution = ""
        
        calledLetters.append(buttonTitle)
        
        // replace question marks with correctly guessed letters
        for letter in currentWord {
            let strLetter = String(letter)
            
            if calledLetters.contains(strLetter) {
                newSolution += strLetter
            } else {
                newSolution += "?"
            }
        }
        
        // incorrect guesses take away points or ends the game
        if currentSolution == newSolution {
            incorrectGuesses -= 1
            
            if incorrectGuesses < 0 {
                let ac = UIAlertController(title: "Sorry, you're out of guesses", message: "The word was \(currentWord)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Try again", style: .default, handler: restartGame))
                present(ac, animated: true)
            }
        }
        
        word.text = newSolution

        // check if all question marks have been successfully replaced and move to the next level
        if !newSolution.contains("?") {
            let ac = UIAlertController(title: "Congratulations! You won!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Next level", style: .default, handler: levelUp))
            present(ac, animated: true)
        }
        
        sender.isHidden = true
    }
    
    func setLevels() {
        let file = "levels"
        DispatchQueue.global().async { [weak self] in
            if let filepath = Bundle.main.path(forResource: file, ofType: "txt") {
                do {
                    let contents = try String(contentsOfFile: filepath)
                    var words = contents.components(separatedBy: "|")
                    words.shuffle()
                    self?.wordsArray = words
                } catch {
                    print("error with file contents")
                }
            } else {
                print("no path")
            }
        }
    }

    func loadLevel() {
        DispatchQueue.main.async { [weak self] in
            self?.currentWord = self!.wordsArray[self!.levelIndex].trimmingCharacters(in: .whitespacesAndNewlines)
            let hiddenString = String(self!.currentWord.map { _ in Character("?")})
            self?.word.text = hiddenString
        }
    }
    
    func levelUp(action: UIAlertAction) {
        levelIndex += 1
        incorrectGuesses = 7
        
        // if the last level was completed, restart the game
        if levelIndex >= wordsArray.count {
            levelIndex = 0
            setLevels()
        }
        
        loadLevel()
            
        refreshBoard()
    }
    
    func restartGame(action: UIAlertAction) {
        incorrectGuesses = 7
        
        setLevels()
        loadLevel()
        
        refreshBoard()
    }
    
    func refreshBoard() {
        calledLetters = []
        
        for button in letterButtons {
            button.isHidden = false
        }
    }
}

