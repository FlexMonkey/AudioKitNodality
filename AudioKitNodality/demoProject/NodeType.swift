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
            return [ NodeInputSlot(label: "Input", type: SNNodeNodeType) ];
            
        case .DryWetMixer:
            return [
                NodeInputSlot(label: "Input 1", type: SNNodeNodeType),
                NodeInputSlot(label: "Input 2", type: SNNodeNodeType),
                NodeInputSlot(label: "Balance", type: SNNodeNumberType)]
            
        case .Oscillator:
            return [
                NodeInputSlot(label: "Amplitude", type: SNNodeNumberType),
                NodeInputSlot(label: "Frequency", type: SNNodeNumberType)]
            
        case .WhiteNoise:
            return [
                NodeInputSlot(label: "Amplitude", type: SNNodeNumberType)]
            
        case .StringResonator:
            return [
                NodeInputSlot(label: "Input", type: SNNodeNodeType),
                NodeInputSlot(label: "Frequency", type: SNNodeNumberType),
                NodeInputSlot(label: "Feedback", type: SNNodeNumberType)]
            
        case .MoogLadder:
            return [
                NodeInputSlot(label: "Input", type: SNNodeNodeType),
                NodeInputSlot(label: "Cut Off Freq.", type: SNNodeNumberType),
                NodeInputSlot(label: "Resonance", type: SNNodeNumberType)]
        }
    }
    
    var numInputSlots: Int
    {
        return inputSlots.count
    }
    

}
