//
//  NodeSelectorModal.swift
//  AudioKitNodality
//
//  Created by Simon Gladman on 11/05/2016.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import UIKit

class NodeSelectorModal: UIViewController
{
    weak var delegate: NodeSelectorModalDelegate?
    
    let collectionView: UICollectionView
    
    required init()
    {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.itemSize = CGSize(width: 200, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.registerClass(NodeSelectorItemRenderer.self, forCellWithReuseIdentifier: "Cell")
        
        super.init(nibName: nil, bundle: nil)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        modalPresentationStyle = UIModalPresentationStyle.FormSheet
        modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        collectionView.backgroundColor = UIColor.darkGrayColor()
        
        view.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews()
    {
        collectionView.frame = view.bounds
    }
}

// MARK: UICollectionViewDelegate

extension NodeSelectorModal: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        delegate?.didSelectAudioKitNode(NodeType.types[indexPath.item])
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: UICollectionViewDataSource

extension NodeSelectorModal: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return NodeType.types.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! NodeSelectorItemRenderer
        
        cell.title = NodeType.types[indexPath.item].rawValue
        
        return cell
    }
}

// MARK: Protocol

protocol NodeSelectorModalDelegate: class
{
    func didSelectAudioKitNode(nodeType: NodeType)
}

// MARK: Item Renderer

class NodeSelectorItemRenderer: UICollectionViewCell
{
    var title: String = ""
    {
        didSet
        {
            label.text = title
        }
    }
    
    let label = UILabel()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        
        backgroundColor = UIColor.lightGrayColor()
        
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        label.frame = bounds
    }
}