//
//  MainVC.swift
//  MonsterApp
//
//  Created by Jeffrey Lai on 2/11/19.
//  Copyright © 2019 Talisman Mobile. All rights reserved.
//

import UIKit
import AVFoundation

class MainContainerView: UIView {}
class ContainerView: UIView {}

class MainVC: UIViewController {

    let mainView: MainContainerView = {
        let v = MainContainerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let bottomView: ContainerView = {
        let v = ContainerView()
        v.backgroundColor = .blue
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let bgView: UIImageView = {
        let v = UIImageView.init(image: UIImage.init(named: "bg.png"))
        v.contentMode = .scaleToFill
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let groundView: UIImageView = {
        let v = UIImageView.init(image: UIImage.init(named: "ground.png"))
        v.contentMode = .scaleToFill
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    

    
    
    
    var foodImg: DragImg!
    var heartImg: DragImg!
    var monsterImg: MonsterImg!
    var penaltyImg1: UIImageView!
    var penaltyImg2: UIImageView!
    var penaltyImg3: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES: Int = 3
    
    var penalties = 0
    var timer: Timer!
    var currentItem: UInt32 = 0
    var monsterHappy: Bool = false
    
    //Sounds Effects
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupObservers()
        setupViews()
        
    }
    
    //Fileprivate
    fileprivate func setupObservers() {
        //Add Observer for ViewController Notification Center
        NotificationCenter.default.addObserver(self, selector: #selector(itemDroppedOnCharacter(notif:)), name: .onTargetDropped, object: nil)
    }

    fileprivate func setupViews() {
        
        //Add Background
        view.addSubview(mainView)
        view.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -groundView.frame.height),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor)

    
            ])
        
        mainView.addSubview(bgView)
        bottomView.addSubview(groundView)
        

        
    }
    
    @objc fileprivate func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        self.startTimer()
        
        //Reset values
        foodImg.alpha = DIM_ALPHA
        heartImg.alpha = DIM_ALPHA
        
        foodImg.isUserInteractionEnabled = false
        heartImg.isUserInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else if currentItem == 1 {
            sfxBite.play()
        }
    }
    
    fileprivate func startTimer() {
        if timer != nil  {
            timer.invalidate()
        }
        
        //Create Timer
        let timerInterval: Double = 3.0
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(changeGameState), userInfo: nil, repeats: true)
        
        
    }
    
    @objc fileprivate func changeGameState() {
        
        if !monsterHappy {
            sfxSkull.play()
            penalties += 1
            
            if penalties == 1 {
                penaltyImg1.alpha = OPAQUE
                penaltyImg2.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penaltyImg2.alpha = OPAQUE
                penaltyImg3.alpha = DIM_ALPHA
            } else if penalties >= 3 {
                penaltyImg3.alpha = OPAQUE
            } else {
                penaltyImg1.alpha = DIM_ALPHA
                penaltyImg2.alpha = DIM_ALPHA
                penaltyImg3.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                self.gameOver()
            }
        }
        
        let rand = arc4random_uniform(2) //0 or 1
        
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.isUserInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.isUserInteractionEnabled = true
        } else if rand == 1 {
            foodImg.alpha = OPAQUE
            foodImg.isUserInteractionEnabled = true
            
            heartImg.alpha = DIM_ALPHA
            heartImg.isUserInteractionEnabled = false
        }
        
        currentItem = rand
        monsterHappy = false
        
    }
    
    
    fileprivate func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
    }
}
