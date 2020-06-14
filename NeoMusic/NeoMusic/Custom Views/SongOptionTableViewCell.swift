//
//  SongOptionView.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 6/8/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class SongOptionView: UIView {
    var data: SongType? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak private var sectionTitleLabel: UILabel!
    @IBOutlet weak private var rightArrowImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateViews()
    }
    
    private func updateViews() {
        backgroundColor = .clear
        contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        
        if let data = data, let sectionTitleLabel = sectionTitleLabel, let rightArrowImageView = rightArrowImageView {
            sectionTitleLabel.tintColor = .buttonColor
            rightArrowImageView.tintColor = .buttonColor
            
            sectionTitleLabel.text = data.rawValue
        } else {
            
        }
    }
}
