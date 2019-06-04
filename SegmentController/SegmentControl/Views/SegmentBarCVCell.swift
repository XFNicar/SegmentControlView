//
//  SegmentBarCVCell.swift
//  SegmentController
//
//  Created by YanYi on 2019/6/4.
//  Copyright © 2019 YanYi. All rights reserved.
//

import UIKit

class SegmentBarCVCell: UICollectionViewCell {

    
    @IBOutlet weak var subBarTitleLab: UILabel!
    
    @IBOutlet weak var bottomLineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    func updateUI(WithModel model:SegmentBarModel)  {
        subBarTitleLab.text = model.title
        if model.isSelected! {
            subBarTitleLab.textColor = .red
        } else {
            subBarTitleLab.textColor = .white
        }
    }

}
