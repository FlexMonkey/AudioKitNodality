//
//  NodeVO.swift
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
    
    override func deletable() -> Bool
    {
        return type != .Output
    }
    
    /// For numeric nodes, the slider maximumValue 
    var maximumValue: Double = 1
    
    // NodeVO(name: NodeType.WhiteNoise.rawValue, position: CGPoint(x: 10, y: 10), type: NodeType.WhiteNoise, inputs: [], model: model)
    
    required init(type: NodeType, model: NodalityModel)
    {
        self.model = model
        super.init(name: type.rawValue, position: CGPointZero)
        
        self.type = type
        self.inputs = []
    }

//    required init(name: String, position: CGPoint, model: NodalityModel)
//    {
//        self.model = model
//        
//        super.init(name: type.rawValue, position: position)
//    }
//    
//    init(name: String, position: CGPoint, value: NodeValue, model: NodalityModel)
//    {
//        self.model = model
//        
//        super.init(name: type.rawValue, position: position)
//        
//        self.value = value
//    }
//    
//    init(name: String, position: CGPoint, type: NodeType = NodeType.Numeric, inputs: [SNNode?]?, model: NodalityModel)
//    {
//        self.model = model
//        
//        super.init(name: type.rawValue, position: position)
//        
//        self.type = type
//        self.inputs = inputs
//    }

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
    
    var outputTypeName: String
    {
        switch type
        {
        case .Numeric:
            return SNNumberTypeName
            
        default:
            return SNNodeTypeName
        }
    }
    
    var audioKitNodeInputs = [Int: AKNode]()
    
    func recalculate()
    {
        switch type
        {
        case .Numeric:
            value = NodeValue.Number(value?.numberValue)
        
        case .Output:
            if let input = getInputValueAt(0).audioKitNode where AudioKit.output != getInputValueAt(0).audioKitNode
            {
                AudioKit.stop()
                
                AudioKit.output = input; print("AudioKit.output =", input)

                AudioKit.start()
            }
            
        case .WhiteNoise:
            let whiteNoise = value?.audioKitNode as? AKWhiteNoise ?? AKWhiteNoise()
            
            whiteNoise.amplitude = getInputValueAt(0).numberValue
            
            if whiteNoise.isStopped
            {
                whiteNoise.start()
            }
            
            value = NodeValue.Node(whiteNoise)
            
        case .Oscillator:
            let oscillator = value?.audioKitNode as? AKOscillator ?? AKOscillator()
            
             oscillator.amplitude = getInputValueAt(0).numberValue
             oscillator.frequency = getInputValueAt(1).numberValue
    
            if oscillator.isStopped
            {
                oscillator.start()
            }
            
            value = NodeValue.Node(oscillator)
            
        case .DryWetMixer:
            if let input0 = getInputValueAt(0).audioKitNode,
                input1 = getInputValueAt(1).audioKitNode
            {
                let balance = getInputValueAt(2).numberValue
                
                if audioKitNodeInputs[0] != input0 || audioKitNodeInputs[1] != input1
                {
                    AudioKit.stop()
                    
                    value = NodeValue.Node(AKDryWetMixer(input0, input1, balance: balance))
                    
                    audioKitNodeInputs[0] = input0
                    audioKitNodeInputs[1] = input1
                }
                
                (value?.audioKitNode as? AKDryWetMixer)?.balance = balance
            }
            else
            {
                value = NodeValue.Node(nil)
            }
            
        case .StringResonator:
            if let input = getInputValueAt(0).audioKitNode
            {
                if audioKitNodeInputs[0] != input
                {
                    AudioKit.stop()
                    
                    value = NodeValue.Node(AKStringResonator(input))
                    
                    audioKitNodeInputs[0] = input
                }
                
                (value?.audioKitNode as? AKStringResonator)?.start()
                (value?.audioKitNode as? AKStringResonator)?.fundamentalFrequency = getInputValueAt(1).numberValue
                (value?.audioKitNode as? AKStringResonator)?.feedback = getInputValueAt(2).numberValue
            }
            else
            {
                value = NodeValue.Node(nil)
            }

        case .MoogLadder:
            if let input = getInputValueAt(0).audioKitNode
            {
                if audioKitNodeInputs[0] != input
                {
                    AudioKit.stop()
                    
                    value = NodeValue.Node(AKMoogLadder(input))
                    
                    audioKitNodeInputs[0] = input
                }
                
                // (value?.audioKitNode as? AKMoogLadder)?.start()
                (value?.audioKitNode as? AKMoogLadder)?.cutoffFrequency = getInputValueAt(1).numberValue
                (value?.audioKitNode as? AKMoogLadder)?.resonance = getInputValueAt(2).numberValue
            }
            else
            {
                value = NodeValue.Node(nil)
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
    
    func getInputValueAt(index: Int) -> NodeValue
    {
        let returnValue: NodeValue
 
        if inputs == nil || index >= inputs?.count || inputs?[index] == nil || inputs?[index]?.nodalityNode == nil
        {
            returnValue = NodeValue.Number(type.inputSlots[index].defaultValue)
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
    let defaultValue: Double
    
    init (label: String, type: NodeValue, defaultValue: Double)
    {
        self.label = label
        self.type = type
        self.defaultValue = defaultValue
    }
    
    init (label: String, type: NodeValue)
    {
        self.label = label
        self.type = type
        self.defaultValue = 0
    }
}


let SNWidgetWidth: CGFloat = 200




