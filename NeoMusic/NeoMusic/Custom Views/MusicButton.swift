//
//  MusicButton.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 6/8/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class MusicButton: UIButton {
    var companyLogo: UIImageView!
    var color: UIColor? {
        didSet {
            updateViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        companyLogo = UIImageView()
        
        insertSubview(companyLogo, at: 0)
        addConstraints([NSLayoutConstraint(item: companyLogo as Any, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 25), NSLayoutConstraint(item: companyLogo as Any, attribute: .width, relatedBy: .equal, toItem: companyLogo, attribute: .height, multiplier: 1, constant: 0), NSLayoutConstraint(item: companyLogo as Any, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
    }
    
    private func updateViews() {
        if let color = color {
            backgroundColor = color
            setTitleColor(color.textColor, for: .normal)
        } else {
            backgroundColor = .white
            setTitleColor(.black, for: .normal)
        }
        layer.cornerRadius = frame.height / 2
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        if let titleLabel = titleLabel, let text = titleLabel.text {
            widthAnchor.constraint(equalToConstant: text.size(withAttributes: [NSAttributedString.Key.font: titleLabel.font as Any]).width + (companyLogo.image == nil ? 40 : 100)).isActive = true
        }
    }
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        companyLogo.image = image
    }
}
