//
//  MainMapCollectionViewCell.swift
//  DMZing
//
//  Created by 김예은 on 09/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import UIKit

class MainMapCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var smallLabel: UILabel!
    @IBOutlet weak var largeLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var totalPageLabel: UILabel!
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var hiddenImageView: UIImageView!
    @IBOutlet weak var hiddenLockImageView: UIImageView!
    @IBOutlet weak var hiddenStackView: UIStackView!
    @IBOutlet weak var dpLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.makeRounded(cornerRadius: 10)
        
        courseImageView.clipsToBounds = true
        courseImageView.layer.cornerRadius = 10
        courseImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        hiddenImageView.makeRounded(cornerRadius: 10)
        
        largeLabel.adjustsFontSizeToFitWidth = true
    }
}
