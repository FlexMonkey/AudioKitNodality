//
//  NodalityModel.swift
//  ShinpuruNodeUI
//
//  Created by Simon Gladman on 07/09/2015.
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

class NodalityModel
{
    var nodes = [NodeVO]()
    
    weak var view: SNView!
    
    init() 
    {
        let whiteNoise = NodeVO(name: "White Noise", position: CGPoint(x: 10, y: 10), type: NodeType.WhiteNoise, inputs: [], model: self)
        let oscillator = NodeVO(name: "Oscillator", position: CGPoint(x: 50, y: 370), type: NodeType.Oscillator, inputs: [], model: self)
        
        let mixer = NodeVO(name: "DryWetMixer", position: CGPoint(x: 450, y: 170), type: NodeType.DryWetMixer, inputs: [], model: self)
        
        let stringResonator = NodeVO(name: "MoogLadder", position: CGPoint(x: 450, y: 170), type: NodeType.MoogLadder, inputs: [], model: self)
        
        let output = NodeVO(name: "Output", position: CGPoint(x: 950, y: 50), type: NodeType.Output, inputs: [], model: self)
        
        nodes = [whiteNoise, oscillator, mixer, output, stringResonator] // [whiteNoise, mixer, oscillator, stringResonator, output]
        
        whiteNoise.freeValues[0] = NodeValue.Number(0.5)
        oscillator.freeValues[0] = NodeValue.Number(0.5)
        oscillator.freeValues[1] = NodeValue.Number(440)
        
        stringResonator.freeValues[1] = NodeValue.Number(100)
        stringResonator.freeValues[2] = NodeValue.Number(0.95)
        
        mixer.freeValues[2] = NodeValue.Number(0.5)
        
        whiteNoise.recalculate()
        oscillator.recalculate()
    }
    
    func toggleRelationship(sourceNode: NodeVO, targetNode: NodeVO, targetIndex: Int) -> [NodeVO]
    {
        if targetNode.inputs == nil
        {
            targetNode.inputs = [NodeVO]()
        }
        
        if targetIndex >= targetNode.inputs?.count
        {
            for _ in 0 ... targetIndex - targetNode.inputs!.count
            {
                targetNode.inputs?.append(nil)
            }
        }
        
        if targetNode.inputs![targetIndex] == sourceNode
        {
            targetNode.inputs![targetIndex] = nil
            
            return updateDescendantNodes(sourceNode.nodalityNode!, forceNode: targetNode.nodalityNode!)
        }
        else
        {
            targetNode.inputs![targetIndex] = sourceNode
            
            return updateDescendantNodes(sourceNode.nodalityNode!)
        }
    }
    
    func deleteNode(deletedNode: NodeVO) -> [NodeVO]
    {
        var updatedNodes = [NodeVO]()
        
        for node in nodes where node.inputs != nil && node.inputs!.contains({$0 == deletedNode})
        {
            for (idx, inputNode) in node.inputs!.enumerate() where inputNode == deletedNode
            {
                node.inputs?[idx] = nil
                
                node.recalculate()
                
                updatedNodes.appendContentsOf(updateDescendantNodes(node))
            }
        }
        
        if let deletedNodeIndex = nodes.indexOf(deletedNode)
        {
            nodes.removeAtIndex(deletedNodeIndex)
        }
        
        return updatedNodes
    }
    
    func addNodeAt(position: CGPoint) -> NodeVO
    {
        let newNode = NodeVO(name: "New!", position: position, value: NodeValue.Number(1), model: self)
        nodes.append(newNode)
        
        return newNode
    }
    
    func updateDescendantNodes(sourceNode: NodeVO, forceNode: NodeVO? = nil) -> [NodeVO]
    {
        var updatedDatedNodes = [[sourceNode]]
        
        for targetNode in nodes where targetNode != sourceNode
        {
            if let inputs = targetNode.inputs,
                targetNode = targetNode.nodalityNode where inputs.contains({$0 == sourceNode}) || targetNode == forceNode
            {
                targetNode.recalculate()
                
                updatedDatedNodes.append(updateDescendantNodes(targetNode))
            }
        }

        // view.refreshNodes(....)
        // TODO - does this need to be recursive????
        
        let updatedNodes = Array(Set<NodeVO>(updatedDatedNodes.flatMap{ $0 }))
        
        updatedNodes.forEach
        {
            view?.reloadNode($0)
        }
        
        return Array(Set<NodeVO>(updatedDatedNodes.flatMap{ $0 })) 
    }
    
    static func nodesAreRelationshipCandidates(sourceNode: NodeVO, targetNode: NodeVO, targetIndex: Int) -> Bool
    {
        // TODO - prevent circular! recursive function 
        
        if sourceNode.isAscendant(targetNode) || sourceNode == targetNode
        {
            return false
        }
        
        return sourceNode.outputTypeName == targetNode.type.inputSlots[targetIndex].type.typeName
    }
}
