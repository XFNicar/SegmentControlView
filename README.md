# SegmentControlView
**像TableView一样方便定制UI的段控制器**

该控件最大的好处就是高度定制化UI，只需要根据自己的需要定制`SegmentBar` 和 `subView` 即可，二者均为 `UICollectionViewCell` 的子类，实现 `SegmentControlDelegate` 和 `SegmentControlDataSource` 即可像 `UITableView` 一样简单易用。



* 初始化

  ```swift
  let frame = CGRect(x: 0, y: 34, width: self.view.frame.width, height: self.view.frame.height - 34)
  segmentControlView = SegmentControlView.initSegmentControlView(withFrame: frame, lineColor: .red)
  view.addSubview(segmentControlView)
  segmentControlView.delegate = self
  segmentControlView.dataSource = self
  segmentControlView.reloadData()
  ```

* 实现代理方法

  ```swift
  
  // 点击segmentBar 或者 subView 停止滚动也会调用该方法
  func didSelectedSegmentBar(segmentControl: SegmentControlView, atIndex index: Int) {
       print("点击了segmentBar \(String(index))")
   }
  
  // 点击subView
  func didSelectedChildView(segmentControl: SegmentControlView, atIndex index: Int) {
  		print("点击了segmentSubView\(String(index))")
  }
  
  
  // 返回 segmentBarItem 
  func segmentControlView(controlView: SegmentControlView, barItemAtIndex indexPath: IndexPath) -> UICollectionViewCell {
  
  		let cell = controlView.dequeueBarItemReusableCell(withReuseIdentifier: SegmentControlId.segmentBarId.rawValue, cellForitemAt: indexPath) as! SegmentBarCVCell
  		cell.updateUI(WithModel: controlView.barModels[indexPath.row])
  		return cell
  }
  // 返回segmentItemView 
  func segmentControlView(controlView: SegmentControlView, subViewAtIndex indexPath: IndexPath) -> UICollectionViewCell {
  
  		let cell = controlView.dequeueSubViewReusableCell(withReuseIdentifier: SegmentControlId.childViewId.rawValue, cellForitemAt: indexPath)
  		return cell
  }
  // 设置标题数组
  func segmentBarTitles(controlView: SegmentControlView) -> [String] {
  		return ["日本","马来西亚","新加坡"]
  }
  ```

