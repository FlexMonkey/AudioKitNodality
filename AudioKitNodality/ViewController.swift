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
    let slider = SliderWidget()
    let shinpuruNodeUI = SNView()
    
    var model = NodalityModel()
    
    var ignoreSliderChange = false
    
    var createNewNodeLocation: CGPoint?
    
    lazy var nodeSelectorModal: NodeSelectorModal =
    {
        let modal = NodeSelectorModal()
        modal.delegate = self
        
        return modal
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        shinpuruNodeUI.nodeDelegate = self
        model.view = shinpuruNodeUI
        
        view.addSubview(shinpuruNodeUI)
        
        slider.alpha = 0
        slider.addTarget(
            self,
            action: #selector(ViewController.sliderChangeHandler),
            forControlEvents: .ValueChanged)
        view.addSubview(slider)
    
    }

    func sliderChangeHandler()
    {
        if let selectedNode = shinpuruNodeUI.selectedNode?.nodalityNode where selectedNode.type == .Numeric
        {
            if !ignoreSliderChange
            {
                selectedNode.value = NodeValue.Number(Double(slider.slider.value))
                selectedNode.maximumValue = slider.maximumValue

                model.updateDescendantNodes(selectedNode).forEach{ shinpuruNodeUI.reloadNode($0) }
            }
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        shinpuruNodeUI.frame = CGRect(
            x: 0,
            y: topLayoutGuide.length,
            width: view.frame.width,
            height: view.frame.height - topLayoutGuide.length)
        
        slider.frame = CGRect(
            x: 0,
            y: view.frame.height - slider.intrinsicContentSize().height - 20,
            width: view.frame.width,
            height: slider.intrinsicContentSize().height).insetBy(dx: 20, dy: 0)
    }
}

// MARK NodeSelectorModalDelegate

extension ViewController: NodeSelectorModalDelegate
{
    func didSelectAudioKitNode(nodeType: NodeType)
    {
        let newNode = model.addNodeOfType(nodeType, position: createNewNodeLocation ?? CGPointZero)
        
        shinpuruNodeUI.reloadNode(newNode)
        shinpuruNodeUI.selectedNode = newNode
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
        UIView.animateWithDuration(0.25)
        {
            self.slider.alpha = node?.nodalityNode?.type == .Numeric ? 1.0 : 0.0
        }
        ignoreSliderChange = true
        slider.maximumValue = node?.nodalityNode?.maximumValue ?? 1
        slider.value = node?.nodalityNode?.value
        ignoreSliderChange = false
    }
    
    func nodeMovedInView(view: SNView, node: SNNode)
    {
        // handle a node move - save to CoreData?
    }
    
    func nodeCreatedInView(view: SNView, position: CGPoint)
    {
        createNewNodeLocation = position
        
        nodeSelectorModal.popoverPresentationController?.sourceView = self.view
        
        presentViewController(
            nodeSelectorModal,
            animated: true,
            completion: nil)
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