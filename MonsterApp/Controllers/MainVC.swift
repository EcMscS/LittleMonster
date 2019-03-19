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

    //Container Views
    let mainView: MainContainerView = {
        let v = MainContainerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let bottomView: ContainerView = {
        let v = ContainerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let monsterView: ContainerView = {
        let v = ContainerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let panelView: ContainerView = {
        let v = ContainerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let itemContainerView: ContainerView = {
        let v = ContainerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //ImageViews of Assets
    let bgView: UIImageView = {
        let v = UIImageView.init(image: UIImage.init(named: "bg.png"))
        v.contentMode = .scaleToFill
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let ground: UIImageView = {
        let v = UIImageView.init(image: UIImage.init(named: "ground.png"))
        v.contentMode = .scaleToFill
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let woodPanel: UIImageView = {
        let v = UIImageView.init(image: UIImage.init(named: "livespanel.png"))
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var penaltyImg1: UIImageView = {
        let image = UIImageView.init(image: UIImage.init(named: "skull.png"))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    var penaltyImg2: UIImageView = {
        let image = UIImageView.init(image: UIImage.init(named: "skull.png"))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var penaltyImg3: UIImageView = {
        let image = UIImageView.init(image: UIImage.init(named: "skull.png"))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var foodImg: DragImg!
    var heartImg: DragImg!
    var golem: MonsterImg!
    
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
        setupMovableObjects()
        setupMusic()
        
        //Start Game
        startTimer()
        
    }
    
    //Fileprivate
    fileprivate func setupObservers() {
        //Add Observer for ViewController Notification Center
        NotificationCenter.default.addObserver(self, selector: #selector(itemDroppedOnCharacter(notif:)), name: .onTargetDropped, object: nil)
    }

    fileprivate func setupViews() {
        
        //Create Golem
        let golemWidth = view.frame.width + 50
        let golemHeight = golemWidth - 30
        golem = MonsterImg.init(frame: CGRect(x: 0, y: 0, width: golemWidth, height: golemHeight))
    
        //Create Heart and Food
        foodImg = DragImg.init(name: "food.png")
        heartImg = DragImg.init(name: "heart.png")
        
        //Change to aspect ratio of container
        foodImg.contentMode = .scaleAspectFit
        heartImg.contentMode = .scaleAspectFit
        
        //Add Background
        view.addSubview(mainView)
        view.addSubview(bottomView)
        view.addSubview(monsterView)
        view.addSubview(panelView)
        view.addSubview(itemContainerView)
        
        NSLayoutConstraint.activate([
            
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            panelView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 15),
            panelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            panelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            panelView.heightAnchor.constraint(equalToConstant: view.frame.height / 8),
            
            itemContainerView.topAnchor.constraint(equalTo: panelView.bottomAnchor, constant: 10),
            itemContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            itemContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            itemContainerView.heightAnchor.constraint(equalToConstant: view.frame.height / 5),
            //itemContainerView.bottomAnchor.constraint(equalTo: monsterView.topAnchor, constant: 0),
            
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -ground.frame.height),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            monsterView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: 40),
            monsterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            monsterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            
            ])
        
        mainView.addSubview(bgView)
        bottomView.addSubview(ground)
        monsterView.addSubview(golem)
        panelView.addSubview(woodPanel)
        
        NSLayoutConstraint.activate([
            
            woodPanel.topAnchor.constraint(equalTo: panelView.topAnchor),
            woodPanel.leadingAnchor.constraint(equalTo: panelView.leadingAnchor),
            woodPanel.bottomAnchor.constraint(equalTo: panelView.bottomAnchor),
            woodPanel.trailingAnchor.constraint(equalTo: panelView.trailingAnchor),
            
            golem.topAnchor.constraint(equalTo: monsterView.topAnchor),
            golem.leadingAnchor.constraint(equalTo: monsterView.leadingAnchor),
            golem.bottomAnchor.constraint(equalTo: monsterView.bottomAnchor),
            golem.trailingAnchor.constraint(equalTo: monsterView.trailingAnchor)
            
            ])
        
        //Initial setting of Penalty Items 1 - 3 set to DIM_ALPHA
        penaltyImg1.alpha = DIM_ALPHA
        penaltyImg2.alpha = DIM_ALPHA
        penaltyImg3.alpha = DIM_ALPHA
        
        //Create Stackview for 3 penalty images
        let penaltyStackView = UIStackView(arrangedSubviews: [
            penaltyImg1,
            penaltyImg2,
            penaltyImg3
            ])
        
        panelView.addSubview(penaltyStackView)
        
        penaltyStackView.distribution = .fillEqually
        penaltyStackView.axis = .horizontal
        penaltyStackView.spacing = 0
        
        penaltyStackView.translatesAutoresizingMaskIntoConstraints = false
        penaltyStackView.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 0).isActive = true
        penaltyStackView.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: 0).isActive = true
        penaltyStackView.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: 0).isActive = true
        penaltyStackView.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 0).isActive = true

        penaltyStackView.isLayoutMarginsRelativeArrangement = true
        penaltyStackView.layoutMargins = UIEdgeInsets(top: 20, left: 22, bottom: 20, right: 30)
        
        //Create Stackview for 2 draggable objects Food and Heart items
        let itemStackView = UIStackView(arrangedSubviews: [
            heartImg,
            foodImg
            ])
       
        itemContainerView.addSubview(itemStackView)
        
        itemStackView.distribution = .fillEqually
        itemStackView.axis = .horizontal
        itemStackView.spacing = 10
        
        itemStackView.translatesAutoresizingMaskIntoConstraints = false
        itemStackView.topAnchor.constraint(equalTo: itemContainerView.topAnchor).isActive = true
        itemStackView.trailingAnchor.constraint(equalTo: itemContainerView.trailingAnchor).isActive = true
        itemStackView.bottomAnchor.constraint(equalTo: itemContainerView.bottomAnchor).isActive = true
        itemStackView.leadingAnchor.constraint(equalTo: itemContainerView.leadingAnchor).isActive = true
        
        itemStackView.isLayoutMarginsRelativeArrangement = true
        itemStackView.layoutMargins = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        

    }
    
    fileprivate func setupMovableObjects() {
        
        foodImg.dropTarget = golem
        foodImg.isUserInteractionEnabled = true
        
        heartImg.dropTarget = golem
        heartImg.isUserInteractionEnabled = true
    }
    
    fileprivate func setupMusic() {
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
        let timerInterval: Double = 5.0
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
        golem.playDeathAnimation()
        sfxDeath.play()
    }
}
