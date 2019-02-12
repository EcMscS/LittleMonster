//
//  ViewController.swift
//  MyLittleMonster
//
//  Created by Jeffrey Lai on 5/5/16.
//  Copyright © 2016 Talisman Mobile. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var FoodImg: DragImg!
    @IBOutlet weak var HeartImg: DragImg!
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var penaltyImg1: UIImageView!
    @IBOutlet weak var penaltyImg2: UIImageView!
    @IBOutlet weak var penaltyImg3: UIImageView!
    
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
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "cave-music", ofType: "mp3")!) as URL)
            
            try sfxBite = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "bite", ofType: "wav")!) as URL)
            
            try sfxHeart = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "heart", ofType: "wav")!) as URL)
            
            try sfxDeath = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "death", ofType: "wav")!) as URL)
            
            try sfxSkull = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "skull", ofType: "wav")!) as URL)
            
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxSkull.prepareToPlay()
            sfxDeath.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        FoodImg.dropTarget = monsterImg
        HeartImg.dropTarget = monsterImg
        
        //Add Observer for ViewController Notification Center
        NotificationCenter.defaultCenter.addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(_:)), name: "onTargetDropped", object: nil)
        
        self.penaltyImg1.alpha = DIM_ALPHA
        self.penaltyImg2.alpha = DIM_ALPHA
        self.penaltyImg3.alpha = DIM_ALPHA
        
        self.startTimer()
    }

    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        self.startTimer()
        
        //Reset values
        FoodImg.alpha = DIM_ALPHA
        HeartImg.alpha = DIM_ALPHA
        
        FoodImg.isUserInteractionEnabled = false
        HeartImg.isUserInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else if currentItem == 1 {
            sfxBite.play()
        }
    }

    func startTimer() {
        if timer != nil  {
            timer.invalidate()
        }
        
        //Create Timer
        let timerInterval: Double = 3.0
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
        
        
    }

    func changeGameState() {
        
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
            FoodImg.alpha = DIM_ALPHA
            FoodImg.isUserInteractionEnabled = false
            
            HeartImg.alpha = OPAQUE
            HeartImg.isUserInteractionEnabled = true
        } else if rand == 1 {
            FoodImg.alpha = OPAQUE
            FoodImg.isUserInteractionEnabled = true
            
            HeartImg.alpha = DIM_ALPHA
            HeartImg.isUserInteractionEnabled = false
        }
        
        currentItem = rand
        monsterHappy = false
        
    }
    
    
    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
    }
}

