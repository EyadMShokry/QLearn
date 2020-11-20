//
//  TopTabBarView.swift
//  TopTabBarView
//
//  Created by SatoDaisuke on 7/21/15.
//  Copyright (c) 2015 com.daisukeSato. All rights reserved.
//

import UIKit

public protocol TopTabBarViewDelegate: class {
    
    
    // Called after the tab changes, be highlight and moves.
    func topTabBarViewDidHighlight(topTabBarView: TopTabBarView, index: Int)
    
}

public class TopTabBarView: UIView, UIScrollViewDelegate {
    
    public var delegate: TopTabBarViewDelegate?
    
    // MARK: Private properties
    private var scrollView: UIScrollView!
    private var underLine: UIView!
    private var topTabBarItems: [UIButton]!
    private var scrollViewCustomizedContentWidth: CGFloat!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public init(frame: CGRect, items: [TopTabBarItem]) {
        super.init(frame: frame)
        
        setupItems(items: items)
        setupScrollView()
        addItems()
        setupUnderLine()
        
        highlight(index: 0)
        
    }
    
    
    // MARK: Setup methods
    private func setupItems(items: [TopTabBarItem]) {
        
        self.topTabBarItems = [UIButton]()
        self.scrollViewCustomizedContentWidth = 0
        
        for idx: Int in 0..<items.count {
            
            let item = items[idx]
            
            let button = UIButton()
            
            button.tag = idx
            button.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: 14)
            button.setTitle(item.title, for: UIControl.State.normal)
            button.setTitleColor(item.color, for: UIControl.State.normal)
            button.setTitleColor(UIColor.white, for: .selected)
            button.backgroundColor = UIColor.white
            button.clipsToBounds = true
            button.layer.cornerRadius = 5.0
            button.sizeToFit()
            
            button.frame.size = CGSize(
                width: button.frame.width + (12 * 2),
                height: self.frame.height
            )
            
            button.frame.origin = CGPoint(
                x: self.scrollViewCustomizedContentWidth,
                y: 0.0
            )
            
            button.addTarget(self, action: #selector(didTouchUpInside(sender:)), for: .touchUpInside)
            
            self.topTabBarItems.append(button)
            
            self.scrollViewCustomizedContentWidth! += button.frame.width
            
        }
        
        
        // fix scrollView.ContentSize.width if shoter than dispaly's width
        if self.scrollViewCustomizedContentWidth < self.frame.width {
            
            fixContentWidth()
            
        }
        
    }
    
    private func setupScrollView() {
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.frame.width,
            height: self.frame.height
        )
        scrollView.contentSize = CGSize(
            width: scrollViewCustomizedContentWidth,
            height: self.frame.height
        )
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        self.addSubview(scrollView)
        
    }
    
    private func addItems() {
        
        for idx: Int in 0..<self.topTabBarItems.count {
            
            let button = self.topTabBarItems[idx]
            
            self.scrollView.addSubview(button)
            
        }
        
        
    }
    
    private func setupUnderLine() {
        
        let lineHeight: CGFloat = 5.0
        
        self.underLine = UIView()
        self.underLine.frame = CGRect(
            x: 0,
            y: self.frame.height - lineHeight,
            width: self.scrollViewCustomizedContentWidth,
            height: lineHeight
        )
        
        self.addSubview(self.underLine)
    }
    
    
    @objc private func didTouchUpInside(sender: UIButton) {
        
        highlight(index: sender.tag)
        
    }
    
    func highlight(index: Int) {
        
        for idx: Int in 0..<self.topTabBarItems.count {
            
            let button = self.topTabBarItems[idx]
            
            if idx == index {
                
                let highlightColor = button.titleColor(for: UIControl.State.normal)
                
                button.isSelected = true
                button.backgroundColor = highlightColor
                
                self.underLine.backgroundColor = highlightColor
                
            } else {
                
                button.isSelected = false
                button.backgroundColor = button.titleColor(for: .selected)
                
            }
            
        }
        
        move(index: index)
        
    }
    
    private func move(index: Int) {
        
        let button = self.topTabBarItems[index]
        
        _ = self.scrollView.contentSize.width - self.scrollView.contentOffset.x
        let distanceRight = self.scrollView.contentSize.width - button.center.x
        
        var newContentOffsetX: CGFloat = 0.0
        
        if button.center.x - (self.frame.width / 2) > 0 && distanceRight > self.frame.width / 2 {
            
            newContentOffsetX = button.center.x - (self.frame.width / 2)
            
        } else if button.center.x - (self.frame.width / 2) <= 0 {
            
            newContentOffsetX = 0.0
            
        } else {
            
            newContentOffsetX = self.scrollView.contentSize.width - self.frame.width
            
        }
        
        
        self.scrollView.setContentOffset(CGPoint(
            x: newContentOffsetX,
            y: 0.0
            ),
            animated: true
        )
        
        
        self.delegate?.topTabBarViewDidHighlight(topTabBarView: self, index: index)
        
    }
    
    private func fixContentWidth() {
        
        let remainingSpace = self.frame.width - self.scrollViewCustomizedContentWidth
        let dividedSpace = remainingSpace / CGFloat(self.topTabBarItems.count)
        let newSpace = dividedSpace / 2
        
        self.scrollViewCustomizedContentWidth = 0
        
        for idx: Int in 0..<self.topTabBarItems.count {
            
            let button = self.topTabBarItems[idx]
            button.frame.size = CGSize(
                width: button.frame.width + (newSpace * 2),
                height: self.frame.height
            )
            button.frame.origin = CGPoint(
                x: self.scrollViewCustomizedContentWidth,
                y: 0.0
            )
            
            self.scrollViewCustomizedContentWidth! += button.frame.width
            
        }
        
        
    }
    
    
}

public class TopTabBarItem {
    
    var title: String!
    var color: UIColor!
    var indexPath: NSIndexPath!
    
    public init(title: String, color: UIColor) {
        self.title = title
        self.color = color
        self.indexPath = NSIndexPath(index: 0)
    }
    
}
