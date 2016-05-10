//
//  ViewController.swift
//  AudioKitNodality
//
//  Created by Simon Gladman on 09/05/2016.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController
{

    let shinpuruNodeUI = SNView()
    var model = NodalityModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        shinpuruNodeUI.nodeDelegate = self
        model.view = shinpuruNodeUI
        
        view.addSubview(shinpuruNodeUI)
    }

    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        shinpuruNodeUI.frame = CGRect(
            x: 0,
            y: topLayoutGuide.length,
            width: view.frame.width,
            height: view.frame.height - topLayoutGuide.length)
    }


}

// MARK: SNDelegate

extension ViewController: SNDelegate
{
    func dataProviderForView(view: SNView) -> [SNNode]?
    {
        return model.nodes
    }
    
    func itemRendererForView(view: SNView, node: SNNode) -> SNItemRenderer
    {
        return ItemRenderer(node: node)
    }
    
    func inputRowRendererForView(view: SNView, inputNode: SNNode?, parentNode: SNNode, index: Int) -> SNInputRowRenderer
    {
        return DemoInputRowRenderer(index: index, inputNode: inputNode, parentNode: parentNode)
    }
    
    func outputRowRendererForView(view: SNView, node: SNNode) -> SNOutputRowRenderer
    {
        return DemoOutputRowRenderer(node: node)
    }
    
    func nodeSelectedInView(view: SNView, node: SNNode?)
    {
//        guard let node = node?.nodalityNode else
//        {
//            slider.enabled = false
//            operatorsControl.enabled = false
//            isOperatorSwitch.enabled = false
//            
//            return
//        }
//        
//        isOperatorSwitch.enabled = true
//        
//        if node.type.isImageFilter
//        {
//            filterControl.node = node
//            
//            filterControl.hidden = false
//            controlsStackView.hidden = true
//        }
//        else
//        {
//            filterControl.hidden = true
//            controlsStackView.hidden = false
//            
//            switch node.type
//            {
//            case .Numeric:
//                slider.enabled = true
//                operatorsControl.enabled = false
//                operatorsControl.selectedSegmentIndex = -1
//                isOperatorSwitch.on = false
//                
//                slider.value = node.value?.floatValue ?? 0
//                
//            case .Add, .Subtract, .Multiply, .Divide, .Color, .ColorAdjust:
//                slider.enabled = false
//                operatorsControl.enabled = true
//                isOperatorSwitch.on = true
//                
//                if let targetIndex = NodeType.operators.indexOf(NodeType(rawValue: node.type.rawValue)!)
//                {
//                    operatorsControl.selectedSegmentIndex = targetIndex
//                }
//                
//            case .Checkerboard, .GaussianBlur:
//                slider.enabled = false
//                operatorsControl.enabled = false
//                isOperatorSwitch.enabled = false
//            }
//        }
    }
    
    func nodeMovedInView(view: SNView, node: SNNode)
    {
        // handle a node move - save to CoreData?
    }
    
    func nodeCreatedInView(view: SNView, position: CGPoint)
    {
        let newNode = model.addNodeAt(position)
        
        view.reloadNode(newNode)
        
        view.selectedNode = newNode
    }
    
    func nodeDeletedInView(view: SNView, node: SNNode)
    {
        if let node = node.nodalityNode
        {
            model.deleteNode(node).forEach{ view.reloadNode($0) }
            
            view.renderRelationships(deletedNode: node)
        }
    }
    
    func relationshipToggledInView(view: SNView, sourceNode: SNNode, targetNode: SNNode, targetNodeInputIndex: Int)
    {
        if let targetNode = targetNode.nodalityNode,
            sourceNode = sourceNode.nodalityNode
        {
            model.toggleRelationship(sourceNode, targetNode: targetNode, targetIndex: targetNodeInputIndex).forEach{ view.reloadNode($0) }
        }
    }
    
    func defaultNodeSize(view: SNView) -> CGSize
    {
        return CGSize(width: SNWidgetWidth, height: SNWidgetWidth + SNNodeWidget.titleBarHeight * 2)
    }
    
    func nodesAreRelationshipCandidates(sourceNode: SNNode, targetNode: SNNode, targetIndex: Int) -> Bool
    {
        guard let sourceNode = sourceNode.nodalityNode,
            targetNode = targetNode.nodalityNode else
        {
            return false
        }
        
        return NodalityModel.nodesAreRelationshipCandidates(sourceNode, targetNode: targetNode, targetIndex: targetIndex)
    }
}