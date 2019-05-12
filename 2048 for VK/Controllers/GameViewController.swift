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
    
    var gameField: [[Any]] = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.frame = CGRect(x: 0, y: 30, width: self.view.frame.width/2, height: 52)
        score.frame = CGRect(x: 0, y: 70, width: self.view.frame.width/2, height: 52)
        bestScoreLabel.frame = CGRect(x: self.view.frame.width/2, y: 30, width: self.view.frame.width/2, height: 52)
        bestScore.frame = CGRect(x: self.view.frame.width/2, y: 70, width: self.view.frame.width/2, height: 52)
        
        let width = Int(self.view.frame.width-56)/4
        
        setupField(cellWidth: width, distance: 8)
        setupSwipeControls()
        
        //updateField(gameField, cellWidth: width, distance: 8)
    }
    
    func createRandomCell() {
        let width = Int(self.view.frame.width-56)/4
        var zeroPoints: [[Int]] = []
        
        for i in 0...3 {
            for j in 0...3 {
                if gameField[i][j] is Int {
                    zeroPoints.append([i, j])
                }
            }
        }
    
        if !zeroPoints.isEmpty {
            let point = zeroPoints.randomElement()!
            let coordinates = convertIndecesToCoordinates(i: point[0], j: point[1], width: width, interval: 8)
            let newCell = GameCell(frame: CGRect(x: coordinates[0], y: coordinates[1], width: width, height: width))
            gameField[point[0]][point[1]] = newCell
            self.view.addSubview(newCell)
        } else {
//            restartGame()
        }
    }
    
    func setupField(cellWidth width: Int, distance: Int) {
        var y = 200
        var x = 2*distance
        
        for _ in 0...3 {
            for _ in 0...3 {
                let newView = UIView(frame: CGRect(x: x, y: y, width: width, height: width))
                newView.layer.cornerRadius = 12
                newView.backgroundColor = UIColor.clear
                self.view.addSubview(newView)
                x += width + 8
            }
            x = 16
            y += width + 8
        }
        
        createRandomCell()
        createRandomCell()
        
    }

    func setupSwipeControls() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(moveUp))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(upSwipe)

        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(moveDown))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(downSwipe)

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(moveLeft))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(leftSwipe)

        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(moveRight))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func moveUp() {
        let width = Int(self.view.frame.width-56)/4
        var previousNumber = 0
        var previousIndex = 0
        var offset = 0
        var isValidMove = false
        var allMovesDone = false

        for j in 0...3 {
            for i in 0...3 {
                if gameField[i][j] is Int  {
                    offset += 1
                } else if previousNumber == (gameField[i][j] as! GameCell).value {
                    (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: previousIndex, j: j, width: width, interval: 8), newValue: previousNumber*2)
                    (gameField[previousIndex][j] as! GameCell).removeFromSuperview()
                    gameField[previousIndex][j] = gameField[i][j]
                    
                    gameField[i][j] = 0
                    previousIndex = 0
                    previousNumber = 0
                    offset += 1
                    isValidMove = true
                } else {
                    previousIndex = i - offset
                    
                    previousNumber = (gameField[i][j] as! GameCell).value
                    if offset > 0 {
                        isValidMove = true
                        (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: previousIndex, j: j, width: width, interval: 8), newValue: previousNumber)
                        gameField[previousIndex][j] = gameField[i][j]
                        gameField[i][j] = 0
                    }
                }
                if i == 3 && j == 3 {
                    allMovesDone = true
                }
            }
            previousNumber = 0
            previousIndex = 0
            offset = 0
        }

        if isValidMove && allMovesDone {
            createRandomCell()
            //updateField(gameField, cellWidth: width, distance: 8)
        }
    }

    @objc func moveDown() {
        let width = Int(self.view.frame.width-56)/4
        var previousNumber = 0
        var previousIndex = 0
        var offset = 0
        var isValidMove = false
        
        for j in 0...3 {
            for i in (0...3).reversed() {
                if gameField[i][j] is Int  {
                    offset += 1
                } else if previousNumber == (gameField[i][j] as! GameCell).value {
                    (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: previousIndex, j: j, width: width, interval: 8), newValue: previousNumber*2)
                    (gameField[previousIndex][j] as! GameCell).removeFromSuperview()
                    gameField[previousIndex][j] = gameField[i][j]
                    gameField[i][j] = 0
                    previousIndex = 0
                    previousNumber = 0
                    offset += 1
                    isValidMove = true
                } else {
                    previousIndex = i + offset
                    
                    previousNumber = (gameField[i][j] as! GameCell).value
                    if offset > 0 {
                        isValidMove = true
                        (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: previousIndex, j: j, width: width, interval: 8), newValue: previousNumber)
                        gameField[previousIndex][j] = gameField[i][j]
                        gameField[i][j] = 0
                    }
                }
            }
            previousNumber = 0
            previousIndex = 0
            offset = 0
        }
        
        if isValidMove {
            createRandomCell()
            //updateField(gameField, cellWidth: width, distance: 8)
        }
    }

    @objc func moveLeft() {
        let width = Int(self.view.frame.width-56)/4
        var previousNumber = 0
        var previousIndex = 0
        var offset = 0
        var isValidMove = false
        
        for i in 0...3 {
            for j in 0...3 {
                if gameField[i][j] is Int  {
                    offset += 1
                } else if previousNumber == (gameField[i][j] as! GameCell).value {
                    (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: i, j: previousIndex, width: width, interval: 8), newValue: previousNumber*2)
                    (gameField[i][previousIndex] as! GameCell).removeFromSuperview()
                    gameField[i][previousIndex] = gameField[i][j]
                    gameField[i][j] = 0
                    previousIndex = 0
                    previousNumber = 0
                    offset += 1
                    isValidMove = true
                } else {
                    previousIndex = j - offset
                    
                    previousNumber = (gameField[i][j] as! GameCell).value
                    if offset > 0 {
                        isValidMove = true
                        (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: i, j: previousIndex, width: width, interval: 8), newValue: previousNumber)
                        gameField[i][previousIndex] = gameField[i][j]
                        gameField[i][j] = 0
                    }
                }
            }
            previousNumber = 0
            previousIndex = 0
            offset = 0
        }
        
        if isValidMove {
            createRandomCell()
            //updateField(gameField, cellWidth: width, distance: 8)
        }
    }

    @objc func moveRight() {
        let width = Int(self.view.frame.width-56)/4
        var previousNumber = 0
        var previousIndex = 0
        var offset = 0
        var isValidMove = false
        
        for i in 0...3 {
            for j in (0...3).reversed() {
                if gameField[i][j] is Int  {
                    offset += 1
                } else if previousNumber == (gameField[i][j] as! GameCell).value {
                    (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: i, j: previousIndex, width: width, interval: 8), newValue: previousNumber*2)
                    (gameField[i][previousIndex] as! GameCell).removeFromSuperview()
                    gameField[i][previousIndex] = gameField[i][j]
                    gameField[i][j] = 0
                    previousIndex = 0
                    previousNumber = 0
                    offset += 1
                    isValidMove = true
                } else {
                    previousIndex = j + offset
                    
                    previousNumber = (gameField[i][j] as! GameCell).value
                    if offset > 0 {
                        isValidMove = true
                        (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: i, j: previousIndex, width: width, interval: 8), newValue: previousNumber)
                        gameField[i][previousIndex] = gameField[i][j]
                        gameField[i][j] = 0
                    }
                }
            }
            previousNumber = 0
            previousIndex = 0
            offset = 0
        }
        
        if isValidMove {
            createRandomCell()
            //updateField(gameField, cellWidth: width, distance: 8)
        }

    }
//
//    func restartGame() {
//        gameField = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
//        gameField = createRandomCells(gameField)
//        gameField = createRandomCells(gameField)
//        let width = Int(self.view.frame.width-56)/4
//        updateField(gameField, cellWidth: width, distance: 8)
//    }
//
//    func youWon() {
//
//    }
//
//    func moveCell(from: [Int], to: [Int], firstValue: Int, finalValue: Int) {
//        let width = Int(self.view.frame.width-56)/4
//        let animation = CABasicAnimation(keyPath: "position")
//        animation.fromValue = from
//        animation.toValue = to
//        let newView = GameCell(frame: CGRect(x: 16 + from[0]*(width+8), y: 200 + from[1]*(width+8), width: width, height: width))
//        newView.layer.cornerRadius = 12
//        let numberLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: width))
//        numberLabel.font = UIFont.systemFont(ofSize: CGFloat(width/2 - 3), weight: .black)
//        numberLabel.textAlignment = .center
//        switch firstValue {
//        case 0:
//            newView.backgroundColor = UIColor.clear
//            numberLabel.text = ""
//        case 2:
//            newView.backgroundColor = UIColor.colour2
//            numberLabel.text = "2"
//        case 4:
//            newView.backgroundColor = UIColor.colour4
//            numberLabel.text = "4"
//        case 8:
//            newView.backgroundColor = UIColor.colour8
//            numberLabel.text = "8"
//        case 16:
//            newView.backgroundColor = UIColor.colour16
//            numberLabel.text = "16"
//        case 32:
//            newView.backgroundColor = UIColor.colour32
//            numberLabel.text = "32"
//        case 64:
//            newView.backgroundColor = UIColor.colour64
//            numberLabel.text = "64"
//        case 128:
//            newView.backgroundColor = UIColor.colour128
//            numberLabel.text = "128"
//        case 256:
//            newView.backgroundColor = UIColor.colour256
//            numberLabel.text = "256"
//        case 512:
//            newView.backgroundColor = UIColor.colour512
//            numberLabel.text = "512"
//        case 1024:
//            newView.backgroundColor = UIColor.colour1024
//            numberLabel.text = "1024"
//        case 2048:
//            newView.backgroundColor = UIColor.colour2048
//            numberLabel.text = "2048"
//            restartGame()
//        default:
//            fatalError()
//        }
//        newView.addSubview(numberLabel)
//        self.view.addSubview(newView)
//        newView.layer.add(animation, forKey: "move")
//        newView.layer.animation(forKey: "move")
//        newView.frame = CGRect(x: to[0]-width/2, y: to[1] - width/2, width: width, height: width)
//    }
//
    func convertIndecesToCoordinates(i: Int, j: Int, width: Int, interval: Int) -> [Int] {
        return [2*interval + j*(width+interval), 200 + i*(width+interval)]
    }
}

