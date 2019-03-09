//
//  MonsterImg.swift
//  MyLittleMonster
//
//  Created by Jeffrey Lai on 5/17/16.
//  Copyright © 2016 Talisman Mobile. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg: UIImageView {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.playIdleAnimation()
    }
    
    func playIdleAnimation() {
        
        print("Playing Animation")
        
        //Default Image
        self.image = UIImage(named: "idle4.png")
        
        self.animationImages = nil
        
        //Create array of images for animation
        self.animationImages = createArrayOfImages(imageName: "idle", numberOfTimes: 4)
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
        
    }
    
    func playDeathAnimation() {
        //Default Image
        self.image = UIImage(named: "dead5.png")
        
        self.animationImages = nil
        
        //Create array of images for animation
        self.animationImages = createArrayOfImages(imageName: "dead", numberOfTimes: 5)
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
    
    func createArrayOfImages(imageName: String, numberOfTimes: Int) -> [UIImage] {
        

        
        var images = [UIImage]()
        
        for anImage in 1...numberOfTimes {
            
            if let nameOfImage = UIImage(named:"\(imageName)\(anImage).png") {
                images.append(nameOfImage)
            }
        }
        
        return images
    }
}
