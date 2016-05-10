//
//  DemoClasses.swift
//  ShinpuruNodeUI
//
//  Created by Simon Gladman on 01/09/2015.
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
import AudioKit

class NodeVO: SNNode
{
    unowned let model:NodalityModel

    var type: NodeType = NodeType.Numeric
    {
        didSet
        {
            inputs = nil
        
            name = type.rawValue
            
            recalculate()
        }
    }
    
    var value: NodeValue?

    required init(name: String, position: CGPoint, model: NodalityModel)
    {
        self.model = model
        
        super.init(name: type.rawValue, position: position)
    }
    
    init(name: String, position: CGPoint, value: NodeValue, model: NodalityModel)
    {
        self.model = model
        
        super.init(name: type.rawValue, position: position)
        
        self.value = value
    }
    
    init(name: String, position: CGPoint, type: NodeType = NodeType.Numeric, inputs: [SNNode?]?, model: NodalityModel)
    {
        self.model = model
        
        super.init(name: type.rawValue, position: position)
        
        self.type = type
        self.inputs = inputs
    }

    required init(name: String, position: CGPoint)
    {
        fatalError("init(name:position:) has not been implemented")
    }
    
    override var numInputSlots: Int
    {
        set
        {
            // ignore - we compute this from the type
        }
        get
        {
            return type.numInputSlots
        }
    }
    
    var outputType: NodeValue
    {
        switch type
        {
        case .Numeric:
            return SNNodeNumberType

        default:
            return SNNodeNodeType
        }
    }
    
    func recalculate()
    {
        switch type
        {
        case .Numeric:
            value = NodeValue.Number(value?.numberValue ?? Double(0))
        
        case .Output:
            if let input = getInputValueAt(0).audioKitNode
            {
                AudioKit.stop()
                AudioKit.output = input
                AudioKit.start(); print("OUTPUT!!!!")
            }
            
        case .WhiteNoise:
            let whiteNoise = AKWhiteNoise()
            whiteNoise.amplitude = 1
            whiteNoise.start()
            
            value = NodeValue.Node(whiteNoise)
            
        case .Oscillator:
            let oscillator = AKOscillator()
            oscillator.start()
            
            value = NodeValue.Node(oscillator)
            
        case .DryWetMixer:
            if let input0 = getInputValueAt(0).audioKitNode,
                input1 = getInputValueAt(1).audioKitNode
            {
                value = NodeValue.Node(AKDryWetMixer(input0, input1, balance: 0.5))
            }
            
        case .StringResonator:
            if let input = getInputValueAt(0).audioKitNode
            {
                value = NodeValue.Node(AKStringResonator(input))
            }
        }
        
        if let inputs = inputs
        {
            if inputs.count >= type.numInputSlots && type.numInputSlots > 0
            {
                self.inputs = Array(inputs[0 ... type.numInputSlots - 1])
            }
            
            for (idx, input) in self.inputs!.enumerate() where input?.nodalityNode != nil
            {
                if !NodalityModel.nodesAreRelationshipCandidates(input!.nodalityNode!, targetNode: self, targetIndex: idx)
                {
                    self.inputs?[idx] = nil
                }
            }
        }
        
        self.model.updateDescendantNodes(self)
    }

    // A dictionary of values by index not generated from an input
    var freeValues = [Int: NodeValue]()
    {
        didSet
        {
            recalculate()
        }
    }
    
    func getInputValueAt(index: Int) -> NodeValue
    {
        let returnValue:NodeValue
        
        if let freeValue = freeValues[index] where
            (inputs == nil || index >= inputs?.count || inputs?[index] == nil || inputs?[index]?.nodalityNode == nil)
        {
            returnValue = freeValue
        }
        else if inputs == nil || index >= inputs?.count || inputs?[index] == nil || inputs?[index]?.nodalityNode == nil
        {
            returnValue = NodeValue.Number(0)
        }
        else if let value = inputs?[index]?.nodalityNode?.value
        {
            returnValue = value
        }
        else
        {
            returnValue = NodeValue.Number(0)
        }
        
        return returnValue
    }
    
    deinit
    {
        print("** NodeVO deinit")
    }
}

extension SNNode
{
    var nodalityNode: NodeVO?
    {
        return self as? NodeVO
    }
}



struct NodeInputSlot
{
    let label: String
    let type: NodeValue
}



let SNWidgetWidth: CGFloat = 200




