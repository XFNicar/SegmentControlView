//
//  SegmentViewController.swift
//  SegmentController
//
//  Created by YanYi on 2019/6/4.
//  Copyright © 2019 YanYi. All rights reserved.
//

import UIKit





class SegmentViewController: UIViewController,SegmentControlDataSource,SegmentControlDelegate {

    var segmentBarTitles:[String] = []
    var segmentControlView: SegmentControlView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initSubViews()
    }
    
    func initSubViews() {
        let frame = CGRect(x: 0, y: 34, width: self.view.frame.width, height: self.view.frame.height - 34)
        segmentControlView = SegmentControlView.initSegmentControlView(withFrame: frame, lineColor: .red)
        view.addSubview(segmentControlView)
        segmentControlView.delegate = self
        segmentControlView.dataSource = self
        segmentControlView.reloadData()
    }

}


extension SegmentViewController {
    
    func didSelectedSegmentBar(segmentControl: SegmentControlView, atIndex index: Int) {
        print("点击了segmentBar \(String(index))")
    }
    
    func didSelectedChildView(segmentControl: SegmentControlView, atIndex index: Int) {
        print("点击了segmentSubView\(String(index))")
    }
    
    func segmentControlView(controlView: SegmentControlView, barItemAtIndex indexPath: IndexPath) -> UICollectionViewCell {
        let cell = controlView.dequeueBarItemReusableCell(withReuseIdentifier: SegmentControlId.segmentBarId.rawValue, cellForitemAt: indexPath) as! SegmentBarCVCell
        cell.updateUI(WithModel: controlView.barModels[indexPath.row])
        return cell
    }
    
    func segmentControlView(controlView: SegmentControlView, subViewAtIndex indexPath: IndexPath) -> UICollectionViewCell {
        let cell = controlView.dequeueSubViewReusableCell(withReuseIdentifier: SegmentControlId.childViewId.rawValue, cellForitemAt: indexPath)
        return cell
    }
    
    func segmentBarTitles(controlView: SegmentControlView) -> [String] {
        return ["日本","马来西亚","新加坡"]
    }
    
    
}
