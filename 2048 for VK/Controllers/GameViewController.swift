//
//  GameViewController.swift
//  2048 for VK
//
//  Created by Влад Дьяков on 08/05/2019.
//  Copyright © 2019 Vlad Dyakov. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var bestScoreView: UIView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var bestScore: UILabel!
    @IBOutlet weak var restartButton: RestartButton!
    
    var gameField: [[Any]] = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
    var width: Int = 0
    var distance: Int = 8
    var scoreCount: Int = 0
    let highScore = UserDefaults.standard.integer(forKey: "highScore")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewWidth = self.view.frame.width
        let viewHeight = self.view.frame.height
        
        score.text = "0"
        bestScore.text = String(highScore)
        
        width = Int(viewWidth-56)/4
        
        scoreView.frame = CGRect(x: CGFloat(2*distance), y: 70, width: viewWidth/2 - CGFloat(4*distance), height: 100)
        addShadow(view: scoreView)
        bestScoreView.frame = CGRect(x: CGFloat(2*distance) + viewWidth/2, y: 70, width: viewWidth/2 - CGFloat(4*distance), height: 100)
        addShadow(view: bestScoreView)
        restartButton.frame = CGRect(x: 75, y: viewHeight - 80, width: viewWidth - 150, height: CGFloat(width/2 + 4))
        addShadow(view: restartButton)
        
        setupField(cellWidth: width, distance: distance)
        setupSwipeControls()
    }
    
    func createRandomCell() {
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
            let coordinates = convertIndecesToCoordinates(i: point[0], j: point[1], width: width, distance: 8)
            let newCell = GameCell(frame: CGRect(x: coordinates[0], y: coordinates[1], width: width, height: width))
            gameField[point[0]][point[1]] = newCell
            self.view.addSubview(newCell)
            if zeroPoints.count == 1 {
                checkIfThereMoves()
            }
        }
    }
    
    func setupField(cellWidth width: Int, distance: Int) {
        var y = 250
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
                    (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: previousIndex, j: j, width: width, distance: 8), newValue: previousNumber*2)
                    (gameField[previousIndex][j] as! GameCell).removeFromSuperview()
                    gameField[previousIndex][j] = gameField[i][j]
                    scoreCount += previousNumber*2
                    score.text = "\(scoreCount)"
                    if previousNumber*2 == 2048 {
                        youWon()
                    }
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
                        (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: previousIndex, j: j, width: width, distance: 8), newValue: previousNumber)
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
        }
    }

    @objc func moveDown() {
        var previousNumber = 0
        var previousIndex = 0
        var offset = 0
        var isValidMove = false
        var allMovesDone = false
        
        for j in 0...3 {
            for i in (0...3).reversed() {
                if gameField[i][j] is Int  {
                    offset += 1
                } else if previousNumber == (gameField[i][j] as! GameCell).value {
                    (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: previousIndex, j: j, width: width, distance: 8), newValue: previousNumber*2)
                    (gameField[previousIndex][j] as! GameCell).removeFromSuperview()
                    gameField[previousIndex][j] = gameField[i][j]
                    gameField[i][j] = 0
                    scoreCount += previousNumber*2
                    score.text = "\(scoreCount)"
                    if previousNumber*2 == 2048 {
                        youWon()
                    }
                    previousIndex = 0
                    previousNumber = 0
                    offset += 1
                    isValidMove = true
                } else {
                    previousIndex = i + offset
                    
                    previousNumber = (gameField[i][j] as! GameCell).value
                    if offset > 0 {
                        isValidMove = true
                        (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: previousIndex, j: j, width: width, distance: 8), newValue: previousNumber)
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
        }
    }

    @objc func moveLeft() {
        var previousNumber = 0
        var previousIndex = 0
        var offset = 0
        var isValidMove = false
        var allMovesDone = false
        
        for i in 0...3 {
            for j in 0...3 {
                if gameField[i][j] is Int  {
                    offset += 1
                } else if previousNumber == (gameField[i][j] as! GameCell).value {
                    (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: i, j: previousIndex, width: width, distance: 8), newValue: previousNumber*2)
                    (gameField[i][previousIndex] as! GameCell).removeFromSuperview()
                    gameField[i][previousIndex] = gameField[i][j]
                    gameField[i][j] = 0
                    scoreCount += previousNumber*2
                    score.text = "\(scoreCount)"
                    if previousNumber*2 == 2048 {
                        youWon()
                    }
                    previousIndex = 0
                    previousNumber = 0
                    offset += 1
                    isValidMove = true
                } else {
                    previousIndex = j - offset
                    
                    previousNumber = (gameField[i][j] as! GameCell).value
                    if offset > 0 {
                        isValidMove = true
                        (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: i, j: previousIndex, width: width, distance: 8), newValue: previousNumber)
                        gameField[i][previousIndex] = gameField[i][j]
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
        }
    }

    @objc func moveRight() {
        var previousNumber = 0
        var previousIndex = 0
        var offset = 0
        var isValidMove = false
        var allMovesDone = false
        
        for i in 0...3 {
            for j in (0...3).reversed() {
                if gameField[i][j] is Int  {
                    offset += 1
                } else if previousNumber == (gameField[i][j] as! GameCell).value {
                    (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: i, j: previousIndex, width: width, distance: 8), newValue: previousNumber*2)
                    (gameField[i][previousIndex] as! GameCell).removeFromSuperview()
                    gameField[i][previousIndex] = gameField[i][j]
                    gameField[i][j] = 0
                    scoreCount += previousNumber*2
                    score.text = "\(scoreCount)"
                    if previousNumber*2 == 2048 {
                        youWon()
                    }
                    previousIndex = 0
                    previousNumber = 0
                    offset += 1
                    isValidMove = true
                } else {
                    previousIndex = j + offset
                    
                    previousNumber = (gameField[i][j] as! GameCell).value
                    if offset > 0 {
                        isValidMove = true
                        (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: i, j: previousIndex, width: width, distance: 8), newValue: previousNumber)
                        gameField[i][previousIndex] = gameField[i][j]
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
        }
    }

    func restartGame() {
        gameField = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
        if scoreCount > highScore {
            UserDefaults.standard.set(scoreCount, forKey: "highScore")
            bestScore.text = String(scoreCount)
        }
        scoreCount = 0
        score.text = "0"
        for views in self.view.subviews {
            if views is GameCell {
                views.removeFromSuperview()
            }
        }
        setupField(cellWidth: width, distance: distance)
    }
    
    @IBAction func restartButtonPressed(_ sender: RestartButton) {
        restartGame()
    }
    
    
    func checkIfThereMoves() {
        var lost = true
        for i in 0...3 {
            for j in 0...3 {
                if i < 3 && j < 3 && ((gameField[i][j] as! GameCell).value == (gameField[i][j+1] as! GameCell).value || (gameField[i][j] as! GameCell).value == (gameField[i+1][j] as! GameCell).value) {
                    lost = false
                    break
                } else if i == 3 && j < 3 && (gameField[i][j] as! GameCell).value == (gameField[i][j+1] as! GameCell).value {
                    lost = false
                    break
                } else if i < 3 && j == 3 && (gameField[i][j] as! GameCell).value == (gameField[i+1][j] as! GameCell).value {
                    lost = false
                    break
                }
            }
        }
        if lost {
            youLost()
        }
    }

    func youWon() {
        restartGame()
    }
    
    func youLost() {
        restartGame()
    }

    func convertIndecesToCoordinates(i: Int, j: Int, width: Int, distance: Int) -> [Int] {
        return [2*distance + j*(width+distance), 250 + i*(width+distance)]
    }
    
    func addShadow(view: UIView) {
        view.layer.shadowColor           = UIColor(rgb: 0xd6d6d8).cgColor
        view.layer.shadowOpacity         = 0.95
        view.layer.shadowOffset          = CGSize(width: 0, height: 5)
        view.layer.shadowRadius          = 9
        view.layer.shadowPath            = UIBezierPath(rect: view.bounds).cgPath
        view.layer.cornerRadius          = 12
    }
}

