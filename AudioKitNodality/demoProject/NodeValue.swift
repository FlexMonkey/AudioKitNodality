//
//  NodeValue.swift
//  NodalityThree
//
//  Created by Simon Gladman on 13/10/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit
import AudioKit

enum NodeValue
{
    case Number(Double?)
    case Node(AKNode?)
    case Output
    
    // get non-optional associated value
    
    var numberValue: Double
    {
        switch self
        {
        case .Number(let value):
            return value ?? 0
            
        default:
            return 0
        }
    }
    
    var audioKitNode: AKNode?
    {
        switch self
        {
        case .Node(let value):
            return value 
            
        default:
            return nil
        }
    }
    
    // return the type name
    
    var typeName: String
    {
        switch self
        {
        case .Number:
            return SNNumberTypeName
        case .Node:
            return SNNodeTypeName
        case .Output:
            return SNOutputTypeName
        }
    }
}
