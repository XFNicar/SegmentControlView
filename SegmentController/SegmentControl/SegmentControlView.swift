//
//  SegmentControlView.swift
//  SegmentController
//
//  Created by YanYi on 2019/6/4.
//  Copyright © 2019 YanYi. All rights reserved.
//

import UIKit

// 选中事件 delegate
protocol SegmentControlDelegate : class {
    func didSelectedSegmentBar(segmentControl:SegmentControlView, atIndex index:Int)
    func didSelectedChildView(segmentControl:SegmentControlView, atIndex index:Int)
    
}

// DataSource
protocol SegmentControlDataSource: class {
    func segmentControlView(controlView:SegmentControlView, barItemAtIndex indexPath:IndexPath) -> UICollectionViewCell
    func segmentControlView(controlView:SegmentControlView, subViewAtIndex indexPath:IndexPath) -> UICollectionViewCell
    func segmentBarTitles(controlView:SegmentControlView) -> [String]
}
// 默认的UI
enum SegmentControlId: String {
    case segmentBarId = "segmentBarId"
    case childViewId  = "childViewId"
}


class SegmentControlView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
   
    weak var delegate: SegmentControlDelegate?
    weak var dataSource: SegmentControlDataSource?
    // 标题栏 collectionview
    private var segmentBar: UICollectionView!
    // 内容区域 collectionview
    private var childViewContent: UICollectionView!
    // 子标题 [string]
    private var segmentTitles:[String] = []
    public var barModels:[SegmentBarModel] = []
    private var currentSelectIndex: Int?
    // 初始化方法
    public class func initSegmentControlView(withFrame frame:CGRect, lineColor:UIColor) -> SegmentControlView {
        let segmentControlView = SegmentControlView.init(frame: frame)
//        segmentControlView.initSubViews()
        return segmentControlView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 为segmentContent注册子view Nib
    public func registerSubViewNib(subViewNib:UINib , identifier:String) {
        childViewContent.register(subViewNib, forCellWithReuseIdentifier: identifier)
    }
    // 为segmentBar注册子subBar Nib
    public func registerBarNib(subItemNib:UINib , identifier:String) {
        segmentBar.register(subItemNib, forCellWithReuseIdentifier: identifier)
    }
    
    // 为segmentContent注册子view class
    public func registerSubViewClass(subViewClass:AnyClass , identifier:String)  {
        childViewContent.register(subViewClass, forCellWithReuseIdentifier: identifier)
    }
    
    // 为segmentBar注册subBar class
    public func registerBarClass(subItemClass:AnyClass , identifier:String) {
        segmentBar.register(subItemClass, forCellWithReuseIdentifier: identifier)
    }
    
    
    func reloadData() {
        barModels.removeAll()
        let titles = dataSource?.segmentBarTitles(controlView: self)
        for title in titles! {
            let model = SegmentBarModel()
            model.title = title
            model.isSelected = false
            barModels.append(model)
        }
        barModels.first?.isSelected = true
        currentSelectIndex = 0
        segmentBar.reloadData()
        childViewContent.reloadData()
    }
    
    // 布局子view
    private func initSubViews() {
        let frame = self.frame
        let segmentBarFrame = CGRect(x: 0, y: 0, width: frame.width, height: 50)
        let childViewContentFrame = CGRect(x: 0, y: 52, width: frame.width, height: frame.height - 52)
        let barLayout = SegmentBarLayout()
        segmentBar = UICollectionView.init(frame: segmentBarFrame , collectionViewLayout: barLayout)
        let childLayout = SegmentSubViewLayout()
        childViewContent = UICollectionView.init(frame: childViewContentFrame, collectionViewLayout: childLayout)
        childViewContent.register(UINib.init(nibName: "SegmentSubViewCVCell", bundle: .main), forCellWithReuseIdentifier: SegmentControlId.childViewId.rawValue)
        segmentBar.register(UINib.init(nibName: "SegmentBarCVCell", bundle: .main), forCellWithReuseIdentifier: SegmentControlId.segmentBarId.rawValue)
        segmentBar.delegate = self
        segmentBar.dataSource = self
        childViewContent.delegate = self
        childViewContent.dataSource = self
        childViewContent.isPagingEnabled = true
        segmentBar.backgroundColor = .purple
        childViewContent.backgroundColor = .purple
        addSubview(segmentBar)
        addSubview(childViewContent)
    }

}


extension SegmentControlView {
    
    
    // 复用 barItem
    public func dequeueBarItemReusableCell(withReuseIdentifier reuseIdentifier: String, cellForitemAt indexPath: IndexPath) -> UICollectionViewCell {
        return segmentBar.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    }
    
    // 复用 subView
    public func dequeueSubViewReusableCell(withReuseIdentifier reuseIdentifier: String, cellForitemAt indexPath: IndexPath) -> UICollectionViewCell {
        return childViewContent.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barModels.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.isEqual(segmentBar) {
            return self.dataSource?.segmentControlView(controlView: self, barItemAtIndex: indexPath) ?? collectionView.dequeueReusableCell(withReuseIdentifier: SegmentControlId.segmentBarId.rawValue, for: indexPath)
        } else {
            return self.dataSource?.segmentControlView(controlView: self, subViewAtIndex: indexPath) ?? collectionView.dequeueReusableCell(withReuseIdentifier: SegmentControlId.childViewId.rawValue, for: indexPath)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isEqual(segmentBar) {
            let width = childViewContent.frame.size.width
            childViewContent.setContentOffset(CGPoint(x: CGFloat(indexPath.row) * width, y: 0), animated: true)
            self.delegate?.didSelectedSegmentBar(segmentControl: self, atIndex: indexPath.row)
        } else {
            self.delegate?.didSelectedChildView(segmentControl: self, atIndex: indexPath.row)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView.isEqual(childViewContent) {
            updateCurrentContentOffset()
//            self.delegate?.didSelectedSegmentBar(segmentControl: self, atIndex: currentSelectIndex!)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isEqual(childViewContent) {
            updateCurrentContentOffset()
            self.delegate?.didSelectedSegmentBar(segmentControl: self, atIndex: currentSelectIndex!)
        }
    }
    
    func updateCurrentContentOffset()  {
        var index = Int(childViewContent.contentOffset.x / childViewContent.frame.width)
        if index == currentSelectIndex {
            return
        }
        index = index < 0 ? 0 : index
        index = index > barModels.count - 1 ? barModels.count - 1 : index
        barModels[currentSelectIndex!].isSelected = false
        let lastSelectedIndex = currentSelectIndex!
        let lastIndexPath = IndexPath.init(row: lastSelectedIndex, section: 0)
        currentSelectIndex = index
        barModels[currentSelectIndex!].isSelected = true
        let currentIndexPath = IndexPath.init(row: index, section: 0)
        segmentBar.reloadItems(at: [lastIndexPath,currentIndexPath])
    }
    
}

class SegmentBarModel: NSObject {
    var title: String?
    var isSelected: Bool?
    var selectedColor: UIColor?
    var defaultColor: UIColor?
    var titleColor: UIColor?
    var titleNomalColor: UIColor?
}




class SegmentBarLayout: UICollectionViewLayout {
    private var attriArray:[UICollectionViewLayoutAttributes] = []
    private var itemWidth: CGFloat = 0
    private var itemHeight: CGFloat = 0
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat = 0
    override func prepare() {
        attriArray.removeAll()
        let allRow = self.collectionView?.dataSource?.collectionView(self.collectionView!, numberOfItemsInSection: 0)
        if allRow! <= 4 {
            itemWidth = (self.collectionView?.frame.width)! / CGFloat(allRow!)
            contentWidth = (self.collectionView?.frame.width)!
        } else {
            itemWidth = (self.collectionView?.frame.width)! / 4
            contentWidth = itemWidth * CGFloat(allRow!)
        }
        itemHeight = (self.collectionView?.frame.height)!
        if allRow == 0 {
            return
        }
        for row in 0...(allRow! - 1) {
            let indexPath = IndexPath.init(row: row, section: 0)
            self.attriArray.append(self.layoutAttributesForItem(at: indexPath )!)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attri = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        attri.frame = CGRect(x: itemWidth * CGFloat(indexPath.row), y: 0, width: itemWidth, height: itemHeight)
        return attri
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attriArray
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: contentWidth, height:contentHeight)
        }
    }
    
}

class SegmentSubViewLayout: UICollectionViewLayout {
    private var attriArray:[UICollectionViewLayoutAttributes] = []
    private var itemWidth: CGFloat = 0
    private var itemHeight: CGFloat = 0
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat = 0
    override func prepare() {
        attriArray.removeAll()
        let allRow = self.collectionView?.dataSource?.collectionView(self.collectionView!, numberOfItemsInSection: 0)
        itemWidth = (self.collectionView?.frame.width)!
        itemHeight = (self.collectionView?.frame.height)!
        contentWidth = itemWidth * CGFloat(allRow!)
        contentHeight = (self.collectionView?.frame.height)!
        if allRow == 0 {
            return
        }
        for row in 0...(allRow! - 1) {
            let indexPath = IndexPath.init(row: row, section: 0)
            self.attriArray.append(self.layoutAttributesForItem(at: indexPath )!)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attri = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        attri.frame = CGRect(x: itemWidth * CGFloat(indexPath.row), y: 0, width: itemWidth, height: itemHeight)
        return attri
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attriArray
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: contentWidth, height:contentHeight)
        }
    }
    
}

