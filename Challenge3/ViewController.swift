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
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .lightGray
        
        remainingTriesLabel = UILabel()
        remainingTriesLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingTriesLabel.textAlignment = .right
        remainingTriesLabel.text = "Remaining Tries: 7"
        view.addSubview(remainingTriesLabel)
        
        word = UILabel()
        word.translatesAutoresizingMaskIntoConstraints = false
        word.textAlignment = .center
        word.font = UIFont.systemFont(ofSize: 30)
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
                letterButton.layer.borderColor = UIColor.blue.cgColor
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
        
        loadLevel()
    }

    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        print(buttonTitle)
        // search the chosen word for a match with the button title
        
        sender.isHidden = true
    }

    func loadLevel() {
        var wordsArray = [String]()
        
        let file = "levels"
        DispatchQueue.global().async {
            if let filepath = Bundle.main.path(forResource: file, ofType: "txt") {
                do {
                    let contents = try String(contentsOfFile: filepath)
                    var words = contents.components(separatedBy: "|")
                    words.shuffle()
                    wordsArray = words
                } catch {
                    print("error with contents")
                }
            } else {
                print("no path")
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            let chosenWord = wordsArray[0].trimmingCharacters(in: .whitespacesAndNewlines)
            print(chosenWord)
            let hiddenString = String(chosenWord.map { _ in Character("?")})
            self?.word.text = hiddenString
        }
    }
}

