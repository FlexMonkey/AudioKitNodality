//
//  NodeType.swift
//  NodalityThree
//
//  Created by Simon Gladman on 13/10/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//
//  Adding a new node type: 
//      * Create enum
//      * Define input slots
//      * Add to `types`
//      * Define behaviour in NodeVO.recalculate()
//
//  Excluded:
//      * AKRolandTB303Filter

import UIKit

let SNNodeNumberType = NodeValue.Number(nil)
let SNNodeNodeType = NodeValue.Node(nil)
let SNNodeOutputType = NodeValue.Output

let SNNumberTypeName = "Number"
let SNNodeTypeName = "Node"
let SNOutputTypeName = "Output"

enum NodeType: String
{
    case Numeric
    
    // Generators
    case Oscillator
    case WhiteNoise
    case FMOscillator
    
    // Filters
    case DryWetMixer
    case StringResonator
    case MoogLadder
    
    // Mandatory output
    case Output
    
    var inputSlots: [NodeInputSlot]
    {
        switch self
        {
        case .Numeric:
            return []
            
        case .Output:
            return [ NodeInputSlot(label: "Input", type: SNNodeNodeType) ];
            
        case .DryWetMixer:
            return [
                NodeInputSlot(label: "Input 1", type: SNNodeNodeType),
                NodeInputSlot(label: "Input 2", type: SNNodeNodeType),
                NodeInputSlot(label: "Balance", type: SNNodeNumberType, defaultValue: 0.5)]
            
        case .Oscillator:
            return [
                NodeInputSlot(label: "Amplitude", type: SNNodeNumberType, defaultValue: 0.5),
                NodeInputSlot(label: "Frequency", type: SNNodeNumberType, defaultValue: 440)]
            
        case .WhiteNoise:
            return [
                NodeInputSlot(label: "Amplitude", type: SNNodeNumberType, defaultValue: 0.5)]
            
        case .StringResonator:
            return [
                NodeInputSlot(label: "Input", type: SNNodeNodeType),
                NodeInputSlot(label: "Frequency", type: SNNodeNumberType, defaultValue: 100),
                NodeInputSlot(label: "Feedback", type: SNNodeNumberType, defaultValue: 0.95)]
            
        case .MoogLadder:
            return [
                NodeInputSlot(label: "Input", type: SNNodeNodeType),
                NodeInputSlot(label: "Cut Off Freq.", type: SNNodeNumberType, defaultValue: 1000),
                NodeInputSlot(label: "Resonance", type: SNNodeNumberType, defaultValue: 0.5)]
        
        case .FMOscillator:
            return [
                NodeInputSlot(label: "Base Freq.", type: SNNodeNumberType, defaultValue: 440),
                NodeInputSlot(label: "Carrier Mult.", type: SNNodeNumberType, defaultValue: 1.0),
                NodeInputSlot(label: "Mod. Mult.", type: SNNodeNumberType, defaultValue: 1.0),
                NodeInputSlot(label: "Mod. Index", type: SNNodeNumberType, defaultValue: 1.0),
                NodeInputSlot(label: "Amplitude", type: SNNodeNumberType, defaultValue: 0.5)]

        }
    }
    
    var numInputSlots: Int
    {
        return inputSlots.count
    }
    
    static let types = [
        NodeType.Numeric, NodeType.Oscillator, NodeType.WhiteNoise,
        NodeType.MoogLadder, NodeType.DryWetMixer, NodeType.StringResonator,
        FMOscillator
        ].sort{$1.rawValue > $0.rawValue}
    
    static func createNodeOfType(nodeType: NodeType, model: NodalityModel) -> NodeVO
    {
        return NodeVO(type: nodeType, model: model)
    }
}