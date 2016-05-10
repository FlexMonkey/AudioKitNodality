//
//  FilterControlsComponent.swift
//  NodalityThree
//
//  Created by Simon Gladman on 14/10/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit

class FilterControlsComponent: UIControl
{
    var sliders = [UIControl]()
    
    override func didMoveToWindow()
    {
        backgroundColor = UIColor(white: 0.275, alpha: 1)
        layer.shadowColor = UIColor.blackColor().CGColor
        
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
    }
    
    var node: NodeVO?
    {
        didSet
        {
            updateUserInterfaceForNode()
        }
    }
    
    func updateUserInterfaceForNode()
    {
        for slider in sliders
        {
            slider.removeTarget(self, action: #selector(FilterControlsComponent.sliderChangeHandler(_:)), forControlEvents: UIControlEvents.ValueChanged)
            
            slider.removeFromSuperview()
        }
        
        sliders = [SliderWidget]()
        
        guard let node = node else
        {
            return
        }
        
        for (index, inputSlot) in node.type.inputSlots.enumerate() where true // SIMON SIMON SIMON
            // node.type.inputSlots[index].type.typeName == SNNodeNumberType.typeName || node.type.inputSlots[index].type.typeName == SNNodeColorType.typeName
        {
            let slider = SliderWidget()
            
            slider.index = index
            slider.title = inputSlot.label

            addSubview(slider)
            sliders.append(slider)
            
            if index < node.inputs?.count && node.inputs?[index] != nil
            {
                slider.enabled = false
                slider.alpha = 0.5
            }
            
            slider.updateValue(node.getInputValueAt(index))
            
            
            slider.addTarget(self, action: #selector(FilterControlsComponent.sliderChangeHandler(_:)), forControlEvents: UIControlEvents.ValueChanged)
        }
        
        setNeedsDisplay()
    }
    
    var currentSliderIndexValue: (Int, NodeValue)?
    
    func sliderChangeHandler(widget: AnyObject)
    {
        if let foo = widget as? NodalitySlider
        {
            currentSliderIndexValue = (foo.index, foo.value!)
            
            sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
    }
    
    override func layoutSubviews()
    {
        var height: CGFloat = 2.5
        let bottom = frame.origin.y + frame.height
        
        for slider in sliders
        {
            slider.frame = CGRect(x: 0, y: height, width: frame.width, height: slider.intrinsicContentSize().height).insetBy(dx: 5, dy: 2.5)
            
            height += slider.intrinsicContentSize().height
        }
        
        frame = CGRect(x: frame.origin.x, y: bottom - height - 2.5, width: frame.width, height: height + 2.5)
    }
}
