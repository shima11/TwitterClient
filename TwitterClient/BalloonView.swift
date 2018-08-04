//
//  BalloonView.swift
//
//
//  Created by shima jinsei on 2015/12/31.
//  Copyright © 2015年 Jinsei Shima. All rights reserved.
//

import UIKit

class BalloonView: UIView {
    
    let triangleSideLength: CGFloat = 20
    let triangleHeight: CGFloat = 17.3
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
        contextBalloonPath(context!, rect: rect)
    }
    
    
    func contextBalloonPath(context: CGContextRef, rect: CGRect) {
        //三角形
        let triangleRightCorner = (x: triangleHeight + CGFloat(1), y: CGFloat(4) )
        let triangleBottomCorner = (x: triangleHeight + CGFloat(1), y:triangleSideLength  + CGFloat(4))
        let triangleLeftCorner = (x: CGFloat(0), y: triangleSideLength/2 + CGFloat(4))
        
        // 塗りつぶし
        CGContextMoveToPoint(context, triangleLeftCorner.x, triangleLeftCorner.y)
        CGContextAddLineToPoint(context, triangleBottomCorner.x, triangleBottomCorner.y)
        CGContextAddLineToPoint(context, triangleRightCorner.x, triangleRightCorner.y)
        CGContextFillPath(context)
        
        //四角い部分
        let view:UIView = UIView()
        view.frame = CGRectMake(triangleHeight, 0, self.frame.width - triangleHeight, rect.size.height)
        view.layer.cornerRadius = 8.0
        view.backgroundColor = UIColor.redColor()
        
        self.addSubview(view)
        
    }

}
