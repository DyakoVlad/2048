//
//  GameControlsExtension.swift
//  2048 for VK
//
//  Created by Влад Дьяков on 19/05/2019.
//  Copyright © 2019 Vlad Dyakov. All rights reserved.
//

import UIKit

extension GameViewController {
    
    ///
    /**
        Creates game cell in random avaliable position
     */
    
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
            let coordinates = convertIndecesToCoordinates(i: point[0], j: point[1], width: width, distance: distance)
            let newCell = GameCell(frame: CGRect(x: coordinates[0], y: coordinates[1], width: width, height: width))
            gameField[point[0]][point[1]] = newCell
            self.view.addSubview(newCell)
            if zeroPoints.count == 1 {
                checkIfThereMoves()
            }
        }
    }
    
    ///
    /**
        Moves cells vertically
     */
    
    func moveVertical(direction: Int) {
        if isSwipable {
            var previousNumber = 0
            var previousIndex = 0
            var offset = 0
            var isValidMove = false
            var allMovesDone = false
            let range = [0, 1, 2, 3]
            
            for j in 0...3 {
                for i in (direction == -1 ? range : range.reversed()) {
                    if gameField[i][j] is Int  {
                        offset += 1
                    } else if previousNumber == (gameField[i][j] as! GameCell).value {
                        (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: previousIndex, j: j, width: width, distance: distance), newValue: previousNumber*2)
                        (gameField[previousIndex][j] as! GameCell).removeFromSuperview()
                        gameField[previousIndex][j] = gameField[i][j]
                        scoreCount += previousNumber*2
                        score.text = "\(scoreCount)"
                        if highScore < scoreCount {
                            bestScore.text = "\(scoreCount)"
                        }
                        if previousNumber*2 == 2048 {
                            gameOver(win: true)
                        }
                        gameField[i][j] = 0
                        previousIndex = 0
                        previousNumber = 0
                        offset += 1
                        isValidMove = true
                    } else {
                        previousIndex = i + offset*direction
                        
                        previousNumber = (gameField[i][j] as! GameCell).value
                        if offset > 0 {
                            isValidMove = true
                            (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: previousIndex, j: j, width: width, distance: distance), newValue: previousNumber)
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
            
            if isValidMove && allMovesDone && isSwipable {
                createRandomCell()
            }
        }
    }
    
    ///
    /**
        Moves cells horizontally
     */
    
    func moveHorizontal(direction: Int) {
        if isSwipable {
            var previousNumber = 0
            var previousIndex = 0
            var offset = 0
            var isValidMove = false
            var allMovesDone = false
            let range = [0, 1, 2, 3]
            
            for i in 0...3 {
                for j in (direction == -1 ? range : range.reversed()) {
                    if gameField[i][j] is Int  {
                        offset += 1
                    } else if previousNumber == (gameField[i][j] as! GameCell).value {
                        (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: i, j: previousIndex, width: width, distance: distance), newValue: previousNumber*2)
                        (gameField[i][previousIndex] as! GameCell).removeFromSuperview()
                        gameField[i][previousIndex] = gameField[i][j]
                        gameField[i][j] = 0
                        scoreCount += previousNumber*2
                        score.text = "\(scoreCount)"
                        if highScore < scoreCount {
                            bestScore.text = "\(scoreCount)"
                        }
                        if previousNumber*2 == 2048 {
                            gameOver(win: true)
                        }
                        previousIndex = 0
                        previousNumber = 0
                        offset += 1
                        isValidMove = true
                    } else {
                        previousIndex = j + offset*direction
                        
                        previousNumber = (gameField[i][j] as! GameCell).value
                        if offset > 0 {
                            isValidMove = true
                            (gameField[i][j] as! GameCell).moveCell(to: convertIndecesToCoordinates(i: i, j: previousIndex, width: width, distance: distance), newValue: previousNumber)
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
            
            if isValidMove && allMovesDone && isSwipable {
                createRandomCell()
            }
        }
    }
    
    @objc func moveUp() {
        moveVertical(direction: -1)
    }
    
    @objc func moveDown() {
        moveVertical(direction: 1)
    }
    
    @objc func moveLeft() {
        moveHorizontal(direction: -1)
    }
    
    @objc func moveRight() {
        moveHorizontal(direction: 1)
    }
    
    ///
    /**
        Deletes all the game cells and restarts the game
     */
    
    func restartGame() {
        gameField = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
        if scoreCount > highScore {
            UserDefaults.standard.set(scoreCount, forKey: "highScore")
            highScore = scoreCount
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
    
    ///
    /**
        Checks if there are avaliable moves, if not - game is over
     */
    
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
            gameOver(win: false)
        }
    }
    
    ///
    /**
        Opens game over view
     */
    
    func gameOver(win: Bool) {
        isSwipable = false
        var addPoint: CGFloat = 0
        if scoreCount > highScore {
            addPoint = 20
        }
        let backgroundShadow = AdditionalView(frame: self.view.frame)
        backgroundShadow.backgroundColor = UIColor.black
        backgroundShadow.layer.opacity = 0
        let lostView = AdditionalView(frame: CGRect(x: xForAdditionalViews, y: 180, width: self.view.frame.width - 2*xForAdditionalViews, height: 350 + addPoint))
        lostView.backgroundColor = UIColor.white
        lostView.layer.opacity = 0
        addShadow(view: lostView)
        let youLostLabel = UILabel(frame: CGRect(x: 0, y: 30, width: lostView.frame.width, height: 40))
        youLostLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        youLostLabel.textAlignment = .center
        youLostLabel.textColor = UIColor.black
        youLostLabel.text = win ? "Ты выиграл \u{1F60E}" : "Ты проиграл \u{1F614}"
        lostView.addSubview(youLostLabel)
        let resultScoreView = AdditionalView(frame: CGRect(x: 20, y: 110, width: lostView.frame.width - 40, height: 120))
        resultScoreView.backgroundColor = UIColor(red: 0, green: 0.328521, blue: 0.574885, alpha: 0.5)
        let yourScoreLabel = UILabel(frame: CGRect(x: 0, y: 20, width: resultScoreView.frame.width, height: 40))
        yourScoreLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        yourScoreLabel.textAlignment = .center
        yourScoreLabel.textColor = UIColor.white
        yourScoreLabel.text = "Твой счёт:"
        resultScoreView.addSubview(yourScoreLabel)
        let yourScore = UILabel(frame: CGRect(x: 0, y: 60, width: resultScoreView.frame.width, height: 40))
        yourScore.font = UIFont.systemFont(ofSize: 30, weight: .black)
        yourScore.textAlignment = .center
        yourScore.textColor = UIColor.white
        yourScore.text = "\(scoreCount)"
        resultScoreView.addSubview(yourScore)
        addShadow(view: resultScoreView)
        lostView.addSubview(resultScoreView)
        
        if addPoint != 0 {
            let newHighScore = UILabel(frame: CGRect(x: 0, y: 225, width: lostView.frame.width, height: 40))
            newHighScore.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            newHighScore.textAlignment = .center
            newHighScore.textColor = UIColor.black
            newHighScore.text = " Новый рекорд \u{1F44F}"
            lostView.addSubview(newHighScore)
        }
        
        let agreeButton = RestartButton(frame: CGRect(x: 20, y: 270 + addPoint, width: lostView.frame.width - 40, height: 50))
        agreeButton.setTitle("Начать заново", for: .normal)
        agreeButton.backgroundColor = UIColor(rgb: 0x4c5a65)
        agreeButton.setTitleColor(UIColor.white, for: .normal)
        agreeButton.tag = 0
        agreeButton.addTarget(self, action: #selector(areYouSureButtonPressed), for: .touchUpInside)
        addShadow(view: agreeButton)
        lostView.addSubview(agreeButton)
        self.view.addSubview(backgroundShadow)
        self.view.addSubview(lostView)
        UIView.animate(withDuration: 0.2, animations: {
            backgroundShadow.layer.opacity = 0.6
            lostView.layer.opacity = 1.0
        })
    }
}
