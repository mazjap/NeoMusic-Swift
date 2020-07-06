//
//  SongOptionView.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 6/8/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

protocol SongOptionDelegate: AnyObject {
    func buttonWasTapped(type: SongCategory)
}

class SongOptionView: UIView {
    var data: SongCategory? {
        didSet {
            setup()
            updateViews()
        }
    }
    
    var sectionTitleButton = EmbeddedButton()
    var rightArrowImageView = UIImageView()
    weak var delegate: SongOptionDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateViews()
    }
    
    private func setup() {
        sectionTitleButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        insertSubview(rightArrowImageView, at: 0)
        insertSubview(sectionTitleButton, at: 0)
        
        setButtonConstraints()
        setImageConstraints()
        
        sectionTitleButton.contentHorizontalAlignment = .left
    }
    
    private func setButtonConstraints() {
        sectionTitleButton.translatesAutoresizingMaskIntoConstraints = false
        
        sectionTitleButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        sectionTitleButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sectionTitleButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sectionTitleButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func setImageConstraints() {
        rightArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        rightArrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        rightArrowImageView.topAnchor.constraint(equalTo: topAnchor, constant: -10).isActive = true
        rightArrowImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10).isActive = true
        rightArrowImageView.widthAnchor.constraint(equalToConstant: frame.height - 20).isActive = true
    }
    
    private func updateViews() {
        backgroundColor = .clear
        
        if let data = data {
            sectionTitleButton.tintColor = .buttonColor
            rightArrowImageView.tintColor = .buttonColor
            
            sectionTitleButton.setTitle(data.rawValue, for: .normal)
        }
    }
    
    @objc
    private func handleTap(_ sender: SongOptionView) {
        guard let delegate = delegate, let data = data else { return }
        
        delegate.buttonWasTapped(type: data)
    }
}
