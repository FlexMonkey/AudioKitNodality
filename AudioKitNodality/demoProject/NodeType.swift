//
//  NodeType.swift
//  NodalityThree
//
//  Created by Simon Gladman on 13/10/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

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
            return [ NodeInputSlot(label: "Input", type: SNNodeNodeType, key: "", defaultValue: 0) ];
            
        case .DryWetMixer:
            return [
                NodeInputSlot(label: "Input 1", type: SNNodeNodeType),
                NodeInputSlot(label: "Input 2", type: SNNodeNodeType),
                NodeInputSlot(label: "Balance", type: SNNodeNumberType, key: "balance", defaultValue: 0.5)]
            
        case .Oscillator:
            return [
                NodeInputSlot(label: "Amplitude", type: SNNodeNumberType, key: "amplitude", defaultValue: 0.5),
                NodeInputSlot(label: "Frequency", type: SNNodeNumberType, key: "frequency", defaultValue: 440)]
            
        case .WhiteNoise:
            return [
                NodeInputSlot(label: "Amplitude", type: SNNodeNumberType, key: "amplitude", defaultValue: 0.5)]
            
        case .StringResonator:
            return [
                NodeInputSlot(label: "Input", type: SNNodeNodeType),
                NodeInputSlot(label: "Frequency", type: SNNodeNumberType, key: "fundamentalFrequency", defaultValue: 100),
                NodeInputSlot(label: "Feedback", type: SNNodeNumberType, key: "feedback", defaultValue: 0.95)]
            
        case .MoogLadder:
            return [
                NodeInputSlot(label: "Input", type: SNNodeNodeType),
                NodeInputSlot(label: "Cut Off Freq.", type: SNNodeNumberType, key: "cutoffFrequency", defaultValue: 1000),
                NodeInputSlot(label: "Resonance", type: SNNodeNumberType, key: "resonance", defaultValue: 0.5)]
        }
    }
    
    var numInputSlots: Int
    {
        return inputSlots.count
    }
    
    
}