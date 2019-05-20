//
//  GameViewController.swift
//  2048 for VK
//
//  Created by Влад Дьяков on 08/05/2019.
//  Copyright © 2019 Vlad Dyakov. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    // MARK: - Properties
    /***************************************************************/

    @IBOutlet weak var bestScoreView: UIView!                                              // view with high score
    @IBOutlet weak var scoreView: UIView!                                                  // view with current score
    @IBOutlet weak var scoreLabel: UILabel!                                                // label "Счёт"
    @IBOutlet weak var score: UILabel!                                                     // label with current score number
    @IBOutlet weak var bestScoreLabel: UILabel!                                            // label "Лучший счёт"
    @IBOutlet weak var bestScore: UILabel!                                                 // label with best score number
    @IBOutlet weak var restartButton: RestartButton!                                       // button that restarts game
    @IBOutlet weak var menuButton: RestartButton!                                          // button with info about game
    @IBOutlet weak var volumeButton: RestartButton!                                        // button that switches sound on/off
    
    var gameField: [[Any]] = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]      // 4x4 array that contains gsme info
    var width: Int = 0                                                                     // width of the game cell
    var distance: Int = 8                                                                  // distance between cells
    var scoreCount: Int = 0                                                                // value that contains current score
    var yField = 270                                                                       // y position of the game field
    var xForAdditionalViews: CGFloat = 20                                                  // offset from left edge for popups
    var highScore = UserDefaults.standard.integer(forKey: "highScore")                     // high score
    var soundOn = UserDefaults.standard.bool(forKey: "soundOn")                            // is sound allowed
    var isSwipable = true                                                                  // is swipes allowed
    var player: AVAudioPlayer?                                                             // audioplayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupField(cellWidth: width, distance: distance)
        setupSwipeControls()
    }
    
    // MARK: - Setup UI
    /***************************************************************/
    
    ///
    /**
        Setup scoreView, bestScoreView, menuButton, volumeButton and restartButton responsive
    */
    
    func setupViews() {
        let viewWidth = self.view.frame.width
        let viewHeight = self.view.frame.height
        
        if viewHeight > 896 {
            distance = 32
            xForAdditionalViews = 200
        }
        width = (Int(viewWidth)-7*distance)/4
        
        score.text = "0"
        bestScore.text = String(highScore)
        
        menuButton.backgroundColor = UIColor(red: 0, green: 0.328521, blue: 0.574885, alpha: 0.5)
        menuButton.setTitleColor(UIColor.white, for: .normal)
        volumeButton.backgroundColor = UIColor(red: 0, green: 0.328521, blue: 0.574885, alpha: 0.5)
        volumeButton.setTitleColor(UIColor.white, for: .normal)
        
        scoreLabel.textAlignment        = .center
        score.textAlignment             = .center
        bestScoreLabel.textAlignment    = .center
        bestScore.textAlignment         = .center
        
        if viewHeight > 736.0 {
            scoreView.frame = CGRect(x: CGFloat(2*distance), y: 70, width: viewWidth/2 - CGFloat(4*distance), height: 100)
            bestScoreView.frame = CGRect(x: CGFloat(2*distance) + viewWidth/2, y: 70, width: viewWidth/2 - CGFloat(4*distance), height: 100)
            if viewHeight > 1112 {
                // for bigger iPads
                restartButton.frame = CGRect(x: 120, y: viewHeight - 150, width: viewWidth - 240, height: CGFloat(width/2 + 4))
            } else if viewHeight > 896 {
                // for smaller iPads
                restartButton.frame = CGRect(x: 75, y: viewHeight - 90, width: viewWidth - 150, height: CGFloat(width/2 + 4))
            } else {
                // for iPhones
                restartButton.frame = CGRect(x: 75, y: viewHeight - 80, width: viewWidth - 150, height: CGFloat(width/2 + 4))
            }
        } else {
            if viewHeight > 568.0 {
                yField = 230
            } else {
                // for iPhone 5S and iPhone SE
                yField = 210
                bestScoreLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            }
            scoreView.frame = CGRect(x: CGFloat(2*distance), y: 30, width: viewWidth/2 - CGFloat(4*distance), height: 100)
            bestScoreView.frame = CGRect(x: CGFloat(2*distance) + viewWidth/2, y: 30, width: viewWidth/2 - CGFloat(4*distance), height: 100)
            restartButton.frame = CGRect(x: 50, y: viewHeight - CGFloat(width/2 + 4) - 22, width: viewWidth - 100, height: CGFloat(width/2 + 4))
        }
        scoreLabel.frame = CGRect(x: 0, y: scoreLabel.frame.origin.y, width: viewWidth/2 - CGFloat(4*distance), height: 50)
        score.frame = CGRect(x: 0, y: score.frame.origin.y, width: viewWidth/2 - CGFloat(4*distance), height: 50)
        bestScoreLabel.frame = CGRect(x: 0, y: bestScoreLabel.frame.origin.y, width: viewWidth/2 - CGFloat(4*distance), height: 50)
        bestScore.frame = CGRect(x: 0, y: bestScore.frame.origin.y, width: viewWidth/2 - CGFloat(4*distance), height: 50)
        menuButton.frame = CGRect(x: CGFloat(2*distance), y: scoreView.frame.origin.y + scoreView.frame.height + 10, width: scoreView.frame.width, height: 50)
        volumeButton.frame = CGRect(x: CGFloat(2*distance) + viewWidth/2, y: scoreView.frame.origin.y + scoreView.frame.height + 10, width: scoreView.frame.width, height: 50)
        menuButton.layer.cornerRadius = 12
        menuButton.setTitle("Об игре", for: .normal)
        volumeButton.layer.cornerRadius = 12
        volumeButton.setTitle(soundOn ? "Звук: Вкл." : "Звук: Выкл.", for: .normal)
        addShadow(view: menuButton)
        addShadow(view: volumeButton)
        addShadow(view: scoreView)
        addShadow(view: bestScoreView)
        addShadow(view: restartButton)
    }
    
    ///
    /**
        Setup game field
     */
    
    func setupField(cellWidth width: Int, distance: Int) {
        var y = yField
        var x = 2*distance
        
        for _ in 0...3 {
            for _ in 0...3 {
                let newView = UIView(frame: CGRect(x: x, y: y, width: width, height: width))
                newView.layer.cornerRadius = 12
                newView.backgroundColor = UIColor.clear
                self.view.addSubview(newView)
                x += width + distance
            }
            x = 2*distance
            y += width + distance
        }
        
        createRandomCell()
        createRandomCell()
        
    }
    
    ///
    /**
        Setup swipes
     */

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
    
    // MARK: - Button tap handlers
    /***************************************************************/
    
    ///
    /**
        User pressed restartButton
     */
    
    @IBAction func restartButtonPressed(_ sender: RestartButton) {
        isSwipable = false
        if soundOn {
            playSound()
        }
        let backgroundShadow = AdditionalView(frame: self.view.frame)
        backgroundShadow.backgroundColor    = UIColor.black
        backgroundShadow.layer.opacity      = 0
        let areYourSureView = AdditionalView(frame: CGRect(x: xForAdditionalViews, y: 230, width: self.view.frame.width - 2*xForAdditionalViews, height: 250))
        areYourSureView.backgroundColor     = UIColor.white
        areYourSureView.layer.opacity       = 0
        addShadow(view: areYourSureView)
        let areYourSureLabel                = UILabel(frame: CGRect(x: 0, y: 30, width: areYourSureView.frame.width, height: 40))
        areYourSureLabel.font               = UIFont.systemFont(ofSize: 38, weight: .bold)
        areYourSureLabel.textAlignment      = .center
        areYourSureLabel.textColor          = UIColor.black
        areYourSureLabel.text               = "Ты уверен? \u{1F626}"
        areYourSureView.addSubview(areYourSureLabel)
        let agreeButton = RestartButton(frame: CGRect(x: 20, y: 110, width: areYourSureView.frame.width/2 - 30, height: 100))
        agreeButton.setTitle("ДА", for: .normal)
        agreeButton.backgroundColor = UIColor(rgb: 0x4c5a65)
        agreeButton.setTitleColor(UIColor.white, for: .normal)
        agreeButton.tag = 0
        agreeButton.addTarget(self, action: #selector(areYouSureButtonPressed), for: .touchUpInside)
        let disagreeButton = RestartButton(frame: CGRect(x: areYourSureView.frame.width/2 + 10, y: 110, width: areYourSureView.frame.width/2 - 30, height: 100))
        disagreeButton.setTitle("НЕТ", for: .normal)
        disagreeButton.backgroundColor = UIColor(rgb: 0x4c5a65)
        disagreeButton.setTitleColor(UIColor.white, for: .normal)
        disagreeButton.tag = 1
        disagreeButton.addTarget(self, action: #selector(areYouSureButtonPressed), for: .touchUpInside)
        addShadow(view: agreeButton)
        addShadow(view: disagreeButton)
        areYourSureView.addSubview(agreeButton)
        areYourSureView.addSubview(disagreeButton)
        self.view.addSubview(backgroundShadow)
        self.view.addSubview(areYourSureView)
        UIView.animate(withDuration: 0.2, animations: {
            backgroundShadow.layer.opacity = 0.6
            areYourSureView.layer.opacity = 1.0
        })
        
    }
    
    ///
    /**
        User pressed button to begin a new game
     */
    
    @objc func areYouSureButtonPressed(_ sender: RestartButton) {
        for views in self.view.subviews {
            if views is AdditionalView {
                views.removeFromSuperview()
            }
        }
        isSwipable = true
        if sender.tag == 0 {
            restartGame()
        }
        if soundOn {
            playSound()
        }
    }
    
    ///
    /**
        User pressed menuButton
     */
    
    @IBAction func menuButtonPressed(_ sender: RestartButton) {
        if soundOn {
            playSound()
        }
        isSwipable = false
        let backgroundShadow = AdditionalView(frame: self.view.frame)
        backgroundShadow.backgroundColor = UIColor.black
        backgroundShadow.layer.opacity = 0
        let aboutView = AdditionalView(frame: CGRect(x: xForAdditionalViews, y: 180, width: self.view.frame.width - 2*xForAdditionalViews, height: 350))
        aboutView.backgroundColor = UIColor.white
        aboutView.layer.opacity = 0
        addShadow(view: aboutView)
        let menuLabel           = UILabel(frame: CGRect(x: 0, y: 30, width: aboutView.frame.width, height: 40))
        menuLabel.font          = UIFont.systemFont(ofSize: 35, weight: .bold)
        menuLabel.textAlignment = .center
        menuLabel.textColor     = UIColor.black
        menuLabel.text          = "Об игре \u{1F3B2}"
        aboutView.addSubview(menuLabel)
        
        let howToWinButton = RestartButton(frame: CGRect(x: 20, y: 90, width: aboutView.frame.width - 40, height: 50))
        howToWinButton.setTitle("Стратегия", for: .normal)
        howToWinButton.backgroundColor = UIColor(red: 0, green: 0.328521, blue: 0.574885, alpha: 0.5)
        howToWinButton.setTitleColor(UIColor.white, for: .normal)
        howToWinButton.tag = 1
        howToWinButton.addTarget(self, action: #selector(openInfo), for: .touchUpInside)
        addShadow(view: howToWinButton)
        aboutView.addSubview(howToWinButton)
        
        let infoLabel           = UILabel(frame: CGRect(x: 0, y: 140, width: aboutView.frame.width, height: 120))
        infoLabel.font          = UIFont.systemFont(ofSize: 23, weight: .bold)
        infoLabel.textAlignment = .center
        infoLabel.textColor     = UIColor.black
        infoLabel.numberOfLines = 2
        infoLabel.text          = "Сделано для VK Team \nby Влад Дьяков with \u{1F499}"
        aboutView.addSubview(infoLabel)
        
        let agreeButton = RestartButton(frame: CGRect(x: 20, y: 270, width: aboutView.frame.width - 40, height: 50))
        agreeButton.setTitle("Закрыть", for: .normal)
        agreeButton.backgroundColor = UIColor(rgb: 0x4c5a65)
        agreeButton.setTitleColor(UIColor.white, for: .normal)
        agreeButton.tag = 1
        agreeButton.addTarget(self, action: #selector(areYouSureButtonPressed), for: .touchUpInside)
        addShadow(view: agreeButton)
        aboutView.addSubview(agreeButton)
        self.view.addSubview(backgroundShadow)
        self.view.addSubview(aboutView)
        UIView.animate(withDuration: 0.2, animations: {
            backgroundShadow.layer.opacity = 0.6
            aboutView.layer.opacity = 1.0
        })
    }
    
    ///
    /**
        User pressed volumeButton
     */
    
    @IBAction func volumeButtonPressed(_ sender: RestartButton) {
        soundOn = !soundOn
        volumeButton.setTitle(soundOn ? "Звук: Вкл." : "Звук: Выкл.", for: .normal)
        UserDefaults.standard.set(soundOn, forKey: "soundOn")
        if soundOn {
            playSound()
        }
    }
    
    // MARK: - Additional functions
    /***************************************************************/
    
    ///
    /**
        Add shadows to the UIView
     */
    
    func addShadow(view: UIView) {
        view.layer.shadowColor           = UIColor.black.cgColor
        view.layer.shadowOpacity         = 0.18
        view.layer.shadowOffset          = CGSize(width: 0, height: 9)
        view.layer.shadowRadius          = 10
        view.layer.shadowPath            = UIBezierPath(rect: view.bounds).cgPath
        view.layer.cornerRadius          = 12
    }

    ///
    /**
        Convert position in array to position on screen in pixels
     */
    
    func convertIndecesToCoordinates(i: Int, j: Int, width: Int, distance: Int) -> [Int] {
        return [2*distance + j*(width+distance), yField + i*(width+distance)]
    }
    
    @objc func openInfo() {
        if soundOn {
            playSound()
        }
        if let url = URL(string: "https://habr.com/ru/post/223045/") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
