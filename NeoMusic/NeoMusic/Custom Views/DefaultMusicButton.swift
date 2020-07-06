//
//  DefaultServiceCollectionViewCell.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 6/8/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class DefaultServiceCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    var jiggler: UIImpactFeedbackGenerator?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var connectServiceButton: UIButton!
    
    // MARK: - Superclass Functions

    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .clear
    }
    
    // MARK: - Functions
    func setImage(_ image: UIImage, for state: UIControl.State) {
        connectServiceButton.setImage(image, for: state)
    }

    
    // MARK: - Private Functions
    
    private func tap() {
        guard let jiggler = jiggler else { return }
        jiggler.impactOccurred()
    }
}
