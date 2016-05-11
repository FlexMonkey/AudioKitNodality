//
//  SliderWidget.swift
//  SceneKitExperiment
//
//  Created by Simon Gladman on 04/11/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

protocol NodalitySlider
{
    var index: Int {get set}
    var title: String {get set}
    var value: NodeValue? { get }
    func updateValue(value: NodeValue)
}

class SliderWidget: UIControl, NodalitySlider
{
    let slider = UISlider(frame: CGRectZero)
    let label = UILabel(frame: CGRectZero)
    
    let minButton = UIButton()
    let maxButton = UIButton()
    
    var index: Int = -1
    
    var title: String = ""
    {
        didSet
        {
            updateLabel()
        }
    }
    
    func updateValue(value: NodeValue)
    {
        self.value = value
    }
    
    var value: NodeValue?
    {
        didSet
        {
            slider.value = Float(value?.numberValue ?? 0)
            updateLabel()
        }
    }
    
    override func didMoveToSuperview()
    {
        slider.addTarget(self, action: #selector(SliderWidget.sliderChangeHandler), forControlEvents: .ValueChanged)
        minButton.addTarget(self, action: #selector(SliderWidget.minHandler), forControlEvents: .TouchDown)
        maxButton.addTarget(self, action: #selector(SliderWidget.maxHandler), forControlEvents: .TouchDown)
        
        slider.minimumValue = 0
        slider.maximumValue = 1
        
        layer.backgroundColor = UIColor.darkGrayColor().CGColor
        
        label.textColor = UIColor.lightGrayColor()
        
        minButton.setTitle("0", forState: UIControlState.Normal)
        minButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        minButton.layer.borderWidth = 1

        maxButton.setTitle("1", forState: UIControlState.Normal)
        maxButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        maxButton.layer.borderWidth = 1
        
        addSubview(slider)
        addSubview(label)
        
        addSubview(minButton)
        addSubview(maxButton)
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeZero
        layer.shadowRadius = 2
        layer.shadowOpacity = 1
    }
    
    func minHandler()
    {
        slider.value = 0
        
        sliderChangeHandler()
    }
    
    func maxHandler()
    {
        slider.value = 1
        
        sliderChangeHandler()
    }
    
    func sliderChangeHandler()
    {
        value = NodeValue.Number(Double(slider.value))
        
        sendActionsForControlEvents(.ValueChanged)
    }
    
    func updateLabel()
    {
        label.text = title + ": " + (NSString(format: "%.3f", value?.numberValue ?? 0) as String)
    }
    
    override func intrinsicContentSize() -> CGSize
    {
        return CGSize(width: 250, height: 20 + slider.intrinsicContentSize().height * 2)
    }
    
    override func layoutSubviews()
    {
        label.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height / 2).insetBy(dx: 5, dy: 5)
        
        minButton.frame = CGRect(x: 4,
            y: frame.height - slider.intrinsicContentSize().height * 1.5 + 5,
            width: minButton.intrinsicContentSize().width,
            height: slider.intrinsicContentSize().height)

        maxButton.frame = CGRect(x: frame.width - 4 - maxButton.intrinsicContentSize().width,
            y: frame.height - slider.intrinsicContentSize().height * 1.5 + 5,
            width: maxButton.intrinsicContentSize().width,
            height: slider.intrinsicContentSize().height)
        
        slider.frame = CGRect(x: minButton.intrinsicContentSize().width + 4,
            y: (frame.height / 2),
            width: frame.width - minButton.intrinsicContentSize().width - maxButton.intrinsicContentSize().width - 6,
            height: slider.intrinsicContentSize().height).insetBy(dx: 10, dy: 0)
    }
}


