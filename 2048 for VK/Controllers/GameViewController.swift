//
//  GameViewController.swift
//  2048 for VK
//
//  Created by Влад Дьяков on 08/05/2019.
//  Copyright © 2019 Vlad Dyakov. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var bestScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.frame = CGRect(x: 0, y: 30, width: self.view.frame.width/2, height: 52)
        score.frame = CGRect(x: 0, y: 70, width: self.view.frame.width/2, height: 52)
        bestScoreLabel.frame = CGRect(x: self.view.frame.width/2, y: 30, width: self.view.frame.width/2, height: 52)
        bestScore.frame = CGRect(x: self.view.frame.width/2, y: 70, width: self.view.frame.width/2, height: 52)
        
        let width = Int(self.view.frame.width-56)/4
        var gameField: [[Int]] = [[0, 2, 0, 8], [0, 4, 4, 4], [8, 8, 2, 0], [4, 2, 8, 0]]
        
        updateField(gameField, cellWidth: width, distance: 8)
    }
    
    func createRandomCells(_ gameField: [[Int]]) -> [[Int]] {
        
        var bool = false
        
        while !bool {
            let x = Int.random(in: 0...3)
            let y = Int.random(in: 0...3)
            bool = gameField[y][x] == 0
        }
        
        return gameField
    }
    
    func updateField(_ gameField: [[Int]], cellWidth width: Int, distance: Int) {
        var y = 200
        var x = 2*distance
        
        for i in 0...3 {
            for j in 0...3 {
                let newView = UIView(frame: CGRect(x: x, y: y, width: width, height: width))
                newView.layer.cornerRadius = 12
                let numberLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: width))
                numberLabel.font = UIFont.systemFont(ofSize: CGFloat(width/2 - 3), weight: .black)
                numberLabel.textAlignment = .center
                switch gameField[i][j] {
                case 0:
                     newView.backgroundColor = UIColor.clear
                     numberLabel.text = ""
                case 2:
                    newView.backgroundColor = UIColor.colour2
                    numberLabel.text = "2"
                case 4:
                    newView.backgroundColor = UIColor.colour4
                    numberLabel.text = "4"
                case 8:
                    newView.backgroundColor = UIColor.colour8
                    numberLabel.text = "8"
                default:
                    fatalError()
                }
                newView.addSubview(numberLabel)
                self.view.addSubview(newView)
                x += width + 8
            }
            x = 16
            y += width + 8
        }
    }


}

