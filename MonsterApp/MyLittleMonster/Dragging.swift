//
//  Dragging.swift
//  MyLittleMonster
//
//  Created by Jeffrey Lai on 5/16/16.
//  Copyright © 2016 Talisman Mobile. All rights reserved.
//

import Foundation
import UIKit

class DragImg: UIImageView {
    
    var originalPosition: CGPoint!
    var dropTarget: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init? (coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        originalPosition = self.center
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let positiion = touch.location(in: self.superview)
            self.center = CGPointMake(positiion.x, positiion.y)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first, let target = dropTarget {
            
            let position = touch.location(in: self.superview)
            
            if target.frame.contains(position) {


                NotificationCenter.defaultCenter().postNotification(NSNotification(name:"onTargetDropped", object:nil))
            }
            
        }
        
        self.center = originalPosition
    }
    
}
