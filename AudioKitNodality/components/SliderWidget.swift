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
    var value: NodeValue? { get }
    var maximumValue: Double {get set }
    func updateValue(value: NodeValue)
}

class SliderWidget: UIControl, NodalitySlider
{
    let slider = UISlider(frame: CGRectZero)
    let label = UILabel(frame: CGRectZero)
    
    let minButton = UIButton()
    let maxButton = UIButton()
    
    let maximumValueSegmentedControl = UISegmentedControl(items: ["1", "10", "100", "1000", "10000"])

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
            
            sendActionsForControlEvents(.ValueChanged)
        }
    }
    
    var maximumValue: Double = 1
    {
        didSet
        {
            maximumValueSegmentedControl.selectedSegmentIndex = Int(ceil(log10(maximumValue)))
            
            slider.maximumValue = Float(maximumValue)
            maxButton.setTitle(" \(maximumValue) ", forState: UIControlState.Normal)
  
            if let numberValue = value?.numberValue where numberValue > maximumValue
            {
                value = NodeValue.Number(maximumValue)
            }
            else
            {
                sendActionsForControlEvents(.ValueChanged)
            }
            
            setNeedsLayout()
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
        
        label.textColor = UIColor.whiteColor()
        
        minButton.setTitle("0", forState: UIControlState.Normal)
        minButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        minButton.layer.borderWidth = 1

        maxButton.setTitle(" \(maximumValue) ", forState: UIControlState.Normal)
        maxButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        maxButton.layer.borderWidth = 1
        
        addSubview(slider)
        addSubview(label)
        
        addSubview(minButton)
        addSubview(maxButton)
        
        maximumValueSegmentedControl.tintColor = UIColor.lightGrayColor()
        maximumValueSegmentedControl.selectedSegmentIndex = 0
        maximumValueSegmentedControl.addTarget(
            self,
            action: #selector(SliderWidget.maximumValueSegmentedControlChangeHandler),
            forControlEvents: .ValueChanged)
        addSubview(maximumValueSegmentedControl)
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeZero
        layer.shadowRadius = 2
        layer.shadowOpacity = 1
    }
    
    func maximumValueSegmentedControlChangeHandler()
    {
        maximumValue = pow(10, Double(maximumValueSegmentedControl.selectedSegmentIndex))
    }
    
    func minHandler()
    {
        slider.value = 0
        
        sliderChangeHandler()
    }
    
    func maxHandler()
    {
        slider.value = Float(maximumValue)
        
        sliderChangeHandler()
    }
    
    func sliderChangeHandler()
    {
        value = NodeValue.Number(Double(slider.value))
    }
    
    func updateLabel()
    {
        label.text = (NSString(format: "%.3f", value?.numberValue ?? 0) as String)
    }
    
    override func intrinsicContentSize() -> CGSize
    {
        return CGSize(width: 250, height: 20 + slider.intrinsicContentSize().height * 2)
    }
    
    override func layoutSubviews()
    {
        label.frame = CGRect(
            x: 0,
            y: 0,
            width: frame.width,
            height: frame.height / 2).insetBy(dx: 5, dy: 5)
        
        minButton.frame = CGRect(
            x: 4,
            y: frame.height - slider.intrinsicContentSize().height * 1.5 + 5,
            width: minButton.intrinsicContentSize().width,
            height: slider.intrinsicContentSize().height)

        maxButton.frame = CGRect(
            x: frame.width - 4 - maxButton.intrinsicContentSize().width,
            y: frame.height - slider.intrinsicContentSize().height * 1.5 + 5,
            width: maxButton.intrinsicContentSize().width,
            height: slider.intrinsicContentSize().height)
        
        slider.frame = CGRect(
            x: minButton.intrinsicContentSize().width + 4,
            y: (frame.height / 2),
            width: frame.width - minButton.intrinsicContentSize().width - maxButton.intrinsicContentSize().width - 6,
            height: slider.intrinsicContentSize().height).insetBy(dx: 10, dy: 0)
        
        maximumValueSegmentedControl.frame = CGRect(
            x: frame.width - maximumValueSegmentedControl.intrinsicContentSize().width - 4,
            y: 4,
            width: maximumValueSegmentedControl.intrinsicContentSize().width,
            height: maximumValueSegmentedControl.intrinsicContentSize().height)
    }
}


