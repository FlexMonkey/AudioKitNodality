//
//  DemoRenderers.swift
//  ShinpuruNodeUI
//
//  Created by Simon Gladman on 04/09/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>

import UIKit


class ItemRenderer: SNItemRenderer
{
    let label = UILabel()
    let line = CAShapeLayer()
    
    override func didMoveToSuperview()
    {
        addSubview(label)
        layer.addSublayer(line)

        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.Center
        
        line.strokeColor = UIColor.whiteColor().CGColor
        line.lineWidth = 1
        
        if superview != nil
        {
            reload()
        }
    }
    
    override var node: SNNode?
    {
        didSet
        {
            updateLabel()
        }
    }
    
    override func reload()
    {
        updateLabel()
    }
    
    func updateLabel()
    {
        if let value = node?.nodalityNode?.value, type = node?.nodalityNode?.type
        {
            switch value
            {
            case NodeValue.Number(let floatValue):
                label.text = "\(type) \n\(floatValue)"
                backgroundColor = UIColor.blueColor() // type.isOperator ? UIColor.blueColor() : UIColor.redColor()
                label.frame = bounds
                
            default:
                let _ = false
            
//            case NodeValue.Color(let colorValue):
//                // label.text = colorValue?.getHex()
//                backgroundColor = UIColor.purpleColor()
//                colorSwatch.alpha = 1
//                colorSwatch.backgroundColor = colorValue
//                imageView.hidden = true
//                
//                label.frame = CGRect(x: 0,
//                    y: bounds.height - label.intrinsicContentSize().height - 5,
//                    width: bounds.width,
//                    height: label.intrinsicContentSize().height)
                
//            case NodeValue.Image(let image):
//                imageView.image = image
//                imageView.hidden = false
//                backgroundColor = UIColor.blackColor()
            }
        }
        else
        {
            // TOODO - tidy this up
//            backgroundColor = node?.nodalityNode?.type == NodeType.Color || node?.nodalityNode?.type == NodeType.ColorAdjust
//                ? UIColor.purpleColor()
//                : UIColor.blueColor()
            
        }
    }
    
    override func layoutSubviews()
    {
        updateLabel()

        let linePath = UIBezierPath()
        linePath.moveToPoint(CGPoint(x: 0, y: 0))
        linePath.addLineToPoint(CGPoint(x: bounds.width, y: 0))
        
        line.path = linePath.CGPath
    }
    
    override func intrinsicContentSize() -> CGSize
    {
        return CGSize(width: SNWidgetWidth, height: 0)
    }
}
