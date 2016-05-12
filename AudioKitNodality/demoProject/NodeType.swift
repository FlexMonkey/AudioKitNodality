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
//      * If node output is numeric, add to `outputType` and `outputTypeName` in NodeVO
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
    // Numerics
    case Numeric
    case NumericDouble
    case NumericHalve
    
    // Generators
    case Oscillator
    case WhiteNoise
    case PinkNoise
    case FMOscillator
    case SawtoothOscillator
    case SquareWaveOscillator
    case TriangleOscillator

    // Filters
    case DryWetMixer
    case StringResonator
    case MoogLadder
    case BitCrusher
    case Reverb
    case CostelloReverb
    case Decimator
    case Equalizer
    case AutoWah
    case RingModulator
    case VariableDelay
    case LowPassFilter
    case HighPassFilter
    
    // Mandatory output
    case Output
    
    var inputSlots: [NodeInputSlot]
    {
        switch self
        {
        case .Numeric:
            return []
            
        case .NumericDouble, .NumericHalve:
            return [ NodeInputSlot(label: "x", type: SNNodeNumberType) ];
            
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
            
        case .WhiteNoise, .PinkNoise:
            return [
                NodeInputSlot(label: "Amplitude", type: SNNodeNumberType, defaultValue: 0.5)]
            
        case .StringResonator:
            return [
                NodeInputSlot(label: "Input", type: SNNodeNodeType),
                NodeInputSlot(label: "Fundamental Freq.", type: SNNodeNumberType, defaultValue: 100),
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
            
        case .SawtoothOscillator:
            return [
                NodeInputSlot(label: "Frequency", type: SNNodeNumberType, defaultValue: 440),
                NodeInputSlot(label: "Amplitude", type: SNNodeNumberType, defaultValue: 0.5),
                NodeInputSlot(label: "Detuning Offset", type: SNNodeNumberType, defaultValue: 0),
                NodeInputSlot(label: "Detuning Mult.", type: SNNodeNumberType, defaultValue: 1)
            ]
            
        case .TriangleOscillator:
            return [
                NodeInputSlot(label: "Frequency", type: SNNodeNumberType, defaultValue: 440),
                NodeInputSlot(label: "Amplitude", type: SNNodeNumberType, defaultValue: 0.5),
                NodeInputSlot(label: "Detuning Offset", type: SNNodeNumberType, defaultValue: 0),
                NodeInputSlot(label: "Detuning Mult.", type: SNNodeNumberType, defaultValue: 1)
            ]
            
        case .SquareWaveOscillator:
            return [
                NodeInputSlot(label: "Frequency", type: SNNodeNumberType, defaultValue: 440),
                NodeInputSlot(label: "Amplitude", type: SNNodeNumberType, defaultValue: 0.5),
                NodeInputSlot(label: "Detuning Offset", type: SNNodeNumberType, defaultValue: 0),
                NodeInputSlot(label: "Detuning Mult.", type: SNNodeNumberType, defaultValue: 1),
                NodeInputSlot(label: "Pulse Width.", type: SNNodeNumberType, defaultValue: 0.5)
            ]

        case .BitCrusher:
            return [
                NodeInputSlot(label: "Input", type: SNNodeNodeType),
                NodeInputSlot(label: "Bit Depth", type: SNNodeNumberType, defaultValue: 8),
                NodeInputSlot(label: "Sample Rate", type: SNNodeNumberType, defaultValue: 10000)
            ]
            
        case .Reverb:
            return [
                NodeInputSlot(label: "Input", type: SNNodeNodeType),
                NodeInputSlot(label: "Dry Wet Mix", type: SNNodeNumberType, defaultValue: 0.5)
            ]
            
        case .CostelloReverb:
            return [
                NodeInputSlot(label: "Input", type: SNNodeNodeType),
                NodeInputSlot(label: "Feedback", type: SNNodeNumberType, defaultValue: 0.6),
                NodeInputSlot(label: "Cut Off Freq.", type: SNNodeNumberType, defaultValue: 4000),
            ]
            
        case .Decimator:
            return [
                NodeInputSlot(label: "Input", type: SNNodeNodeType),
                NodeInputSlot(label: "Decimation", type: SNNodeNumberType, defaultValue: 0.5),
                NodeInputSlot(label: "Rounding", type: SNNodeNumberType, defaultValue: 0),
                NodeInputSlot(label: "Mix", type: SNNodeNumberType, defaultValue: 1),
            ]
            
        case .Equalizer:
            return [
                NodeInputSlot(label: "Input", type: SNNodeNodeType),
                NodeInputSlot(label: "Center Frequency", type: SNNodeNumberType, defaultValue: 1000),
                NodeInputSlot(label: "Bandwidth", type: SNNodeNumberType, defaultValue: 100),
                NodeInputSlot(label: "Gain", type: SNNodeNumberType, defaultValue: 10)
            ]
            
        case .AutoWah:
            return [
                NodeInputSlot(label: "Input", type: SNNodeNodeType),
                NodeInputSlot(label: "Wah", type: SNNodeNumberType, defaultValue: 0),
                NodeInputSlot(label: "Mix", type: SNNodeNumberType, defaultValue: 1),
                NodeInputSlot(label: "Amplitude", type: SNNodeNumberType, defaultValue: 0.1)
            ]
            
        case .RingModulator:
            return [
                NodeInputSlot(label: "Input", type: SNNodeNodeType),
                NodeInputSlot(label: "Frequency 1", type: SNNodeNumberType, defaultValue: 220),
                NodeInputSlot(label: "Frequency 1", type: SNNodeNumberType, defaultValue: 440),
                NodeInputSlot(label: "Balance", type: SNNodeNumberType, defaultValue: 0.5),
                NodeInputSlot(label: "Mix", type: SNNodeNumberType, defaultValue: 1.0)]
            
        case .VariableDelay:
            return [
                NodeInputSlot(label: "Input", type: SNNodeNodeType),
                NodeInputSlot(label: "Time", type: SNNodeNumberType, defaultValue:1),
                NodeInputSlot(label: "Feedback", type: SNNodeNumberType, defaultValue: 0),
            ]
            
        case .LowPassFilter, .HighPassFilter:
            return [
                NodeInputSlot(label: "Input", type: SNNodeNodeType),
                NodeInputSlot(label: "Cutoff Freq.", type: SNNodeNumberType, defaultValue: 6900),
                NodeInputSlot(label: "Resonance", type: SNNodeNumberType, defaultValue: 0),
                NodeInputSlot(label: "Dry Wet Mix", type: SNNodeNumberType, defaultValue: 100)
            ]
        }
    }
    
    var numInputSlots: Int
    {
        return inputSlots.count
    }
    
    static let types = [
        Numeric, NumericDouble, NumericHalve,
        Oscillator, WhiteNoise, PinkNoise,
        MoogLadder, DryWetMixer, StringResonator,
        FMOscillator, SawtoothOscillator, SquareWaveOscillator, TriangleOscillator,
        BitCrusher, Reverb, CostelloReverb, Decimator,
        Equalizer, AutoWah, RingModulator, VariableDelay, LowPassFilter, HighPassFilter
    ].sort{$1.rawValue > $0.rawValue}
    
    static func createNodeOfType(nodeType: NodeType, model: NodalityModel) -> NodeVO
    {
        return NodeVO(type: nodeType, model: model)
    }
}