//
//  ViewController.swift
//  Challenge3
//
//  Created by Melody Davis on 8/6/22.
//

import UIKit

class ViewController: UIViewController {
    var remainingTriesLabel: UILabel!
    var word: UITextField!
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
        
        word = UITextField()
        word.translatesAutoresizingMaskIntoConstraints = false
        word.textAlignment = .center
        word.placeholder = "Word appears here"
        word.font = UIFont.systemFont(ofSize: 30)
        word.isUserInteractionEnabled = false
        view.addSubview(word)
        
        NSLayoutConstraint.activate([
            remainingTriesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            remainingTriesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            word.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            word.topAnchor.constraint(equalTo: remainingTriesLabel.bottomAnchor, constant: 10)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

