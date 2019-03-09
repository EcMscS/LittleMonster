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
    //var notification: NSNotification!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init? (coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        originalPosition = self.center
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.superview)
            self.center = CGPoint(x: position.x, y: position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let target = dropTarget {
            
            let position = touch.location(in: self.superview)
            
            if target.frame.contains(position) {
                NotificationCenter.default.post(name: .onTargetDropped, object: nil)
            }
            
        }
        
        self.center = originalPosition
    }
    
}

extension Notification.Name {
    static let onTargetDropped = Notification.Name("on-target-dropped")
}
